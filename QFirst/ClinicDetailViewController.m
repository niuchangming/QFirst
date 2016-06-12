//
//  ClinicDetailViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 4/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "ClinicDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DoctorCell.h"
#import "Utils.h"
#import "MozTopAlertView.h"
#import "UILabel+DynamicSize.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"
#import "ConstantValues.h"
#import "AppDelegate.h"
#import "TimelineViewController.h"
#import "DoctorDetailViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ClinicDetailViewController (){
    NSLayoutConstraint *topContraint;
    CGPoint tempContentOffset;
    int doctorContainerHeight;
    bool isFirstLoad;
    Clinic *dbClinic;
    bool isQuick;
}

@end

@implementation ClinicDetailViewController

@synthesize scrollView;
@synthesize clinicMapView;
@synthesize clinicLogo;
@synthesize addressLbl;
@synthesize clinicName;
@synthesize locationManager;
@synthesize expandArrow;
@synthesize descLbl;
@synthesize doctorContainer;
@synthesize clincInfoCell;
@synthesize queueBtn;
@synthesize clinic;
@synthesize bookmarkBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstLoad = true;
    isQuick = false;
    
    descLbl.text = clinic.desc;
    clinicName.text = clinic.name;
    addressLbl.text = clinic.address;
    [descLbl resizeToFit];
    
    clinicLogo.layer.cornerRadius = self.clinicLogo.frame.size.width / 2;
    clinicLogo.clipsToBounds = YES;
    clinicLogo.layer.masksToBounds = YES;
    [clinicLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%i", baseUrl, [[clinic logo] entityId]]]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self loadMapView];
    
    [self setupDoctorCells];
    
    topContraint = [NSLayoutConstraint
                    constraintWithItem:doctorContainer
                    attribute:NSLayoutAttributeTopMargin
                    relatedBy:NSLayoutRelationEqual
                    toItem:descLbl
                    attribute:NSLayoutAttributeTopMargin
                    multiplier: 1.0f
                    constant: -9.0f];
    
    descLbl.center = CGPointMake(descLbl.center.x, descLbl.center.y - descLbl.frame.size.height - 8);
    descLbl.alpha = 0.0;
    
    [scrollView addConstraint:topContraint];
    
    [self checkBookmark];
}

-(void) viewDidAppear:(BOOL)animated{
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.clinicMapView.frame.size.height + self.clincInfoCell.frame.size.height + doctorContainerHeight + 16)];
    
    if(isFirstLoad){
        CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([clinic.latitude doubleValue], [clinic.longitude doubleValue])
                                                           altitude:0
                                                 horizontalAccuracy:0
                                                   verticalAccuracy:0
                                                          timestamp:[NSDate date]];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locObj.coordinate, 800, 800);
        [self.clinicMapView setRegion:region animated:YES];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([clinic.latitude doubleValue], [clinic.longitude doubleValue]);
        annotation.title = clinic.name;
        annotation.subtitle = clinic.address;
        
        [self.clinicMapView addAnnotation:annotation];
        
        isFirstLoad = false;
    }
}

-(void) checkBookmark{
    dbClinic = [clinic retrieve];
    if(dbClinic != nil){
        clinic.isBookmark = true;
        [bookmarkBtn setBackgroundImage:[UIImage imageNamed:@"star_filled"] forState:UIControlStateNormal];
    }
}

-(void) loadMapView{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    clinicMapView.showsUserLocation = YES;
    [clinicMapView setMapType:MKMapTypeStandard];
    [clinicMapView setZoomEnabled:YES];
    [clinicMapView setScrollEnabled:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [clinicMapView addSubview:view];
}

-(void) setupDoctorCells{
    if(clinic.isCoop){
        if(clinic.doctors.count > 0){
            for(int i = 0; i < [clinic.doctors count]; i++){
                UIView *spiltor = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, i * 73, self.view.frame.size.width, 1)];
                [spiltor setBackgroundColor:[Utils colorFromHexString:@"#EFEFF4"]];
                [self.doctorContainer addSubview:spiltor];
                
                UIView *doctorCell = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, i * 72 + i + 1, self.view.frame.size.width, 72)];
                
                UIImageView *avatarIV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 48, 48)];
                avatarIV.layer.cornerRadius = avatarIV.frame.size.width / 2;
                avatarIV.clipsToBounds = YES;
                avatarIV.contentMode = UIViewContentModeScaleAspectFill;
                avatarIV.layer.masksToBounds = YES;
                [avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserController/showUserAvatar?id=%i", baseUrl, [[[clinic.doctors objectAtIndex:i] avatar] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
                [doctorCell addSubview:avatarIV];
                
                UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(64, 25, self.view.frame.size.width - 152, 22)];
                nameLbl.text = [[clinic.doctors objectAtIndex:i] name];
                nameLbl.numberOfLines = 1;
                nameLbl.clipsToBounds = YES;
                nameLbl.backgroundColor = [UIColor clearColor];
                nameLbl.textColor = [Utils colorFromHexString:@"#4A4A4A"];
                nameLbl.textAlignment = NSTextAlignmentLeft;
                [doctorCell addSubview:nameLbl];
                
                UIButton *reserveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 21, 72, 30)];
                reserveBtn.layer.cornerRadius = 2;
                reserveBtn.clipsToBounds = YES;
                reserveBtn.layer.masksToBounds = YES;
                reserveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [reserveBtn setTitle:@"Reserve" forState:UIControlStateNormal];
                [reserveBtn setBackgroundColor:[Utils colorFromHexString:@"#4CD964"]];
                [reserveBtn addTarget:self action:@selector(reserveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [reserveBtn setTag:i];
                [doctorCell addSubview:reserveBtn];
                
                
                [self.doctorContainer addSubview:doctorCell];
                
                doctorContainerHeight += spiltor.frame.size.height + doctorCell.frame.size.height;
                
                if(i == [clinic.doctors count] - 1) {
                    UIView *bottomSpiltor = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, [clinic.doctors count] * 72 + [clinic.doctors count] + 1, self.view.frame.size.width, 1)];
                    [bottomSpiltor setBackgroundColor:[Utils colorFromHexString:@"#EFEFF4"]];
                    [self.doctorContainer addSubview:bottomSpiltor];
                    
                    [self setupActionButtons:@"queue" afterView:bottomSpiltor];
                }
            }
        }else{
            UIView *bottomSpiltor = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 1, self.view.frame.size.width, 1)];
            [bottomSpiltor setBackgroundColor:[Utils colorFromHexString:@"#EFEFF4"]];
            [self.doctorContainer addSubview:bottomSpiltor];
            
           [self setupActionButtons:@"queue" afterView:bottomSpiltor];
        }
    }else{
        UIView *bottomSpiltor = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 1, self.view.frame.size.width, 1)];
        [bottomSpiltor setBackgroundColor:[Utils colorFromHexString:@"#EFEFF4"]];
        [self.doctorContainer addSubview:bottomSpiltor];
        
        [self setupActionButtons:@"call" afterView:bottomSpiltor];
    }
    
    NSLayoutConstraint *bottomContraint = [NSLayoutConstraint
                    constraintWithItem:doctorContainer
                    attribute:NSLayoutAttributeBottomMargin
                    relatedBy:NSLayoutRelationEqual
                    toItem:queueBtn
                    attribute:NSLayoutAttributeBottomMargin
                    multiplier: 1.0f
                    constant: 0.0f];
    bottomContraint.priority = 1000;
    
    [scrollView addConstraint:bottomContraint];
}

-(void) setupActionButtons:(NSString *) type afterView: (UIView*) bottomSpiltor{
    queueBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, bottomSpiltor.frame.origin.y + bottomSpiltor.frame.size.height + 8, self.view.frame.size.width - 16, 40)];
    
    if([type isEqualToString:@"call"]){
        [queueBtn setTitle:@"Call (67398273)" forState:UIControlStateNormal];
        [queueBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [queueBtn setBackgroundColor:[Utils colorFromHexString:@"#007AFF"]];
    }else{
        [queueBtn setTitle:@"Take A Queue" forState:UIControlStateNormal];
        [queueBtn addTarget:self action:@selector(queueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [queueBtn setBackgroundColor:[Utils colorFromHexString:@"#4CD964"]];
    }
    
    [queueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queueBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    queueBtn.layer.cornerRadius = 4;
    queueBtn.clipsToBounds = YES;
    queueBtn.layer.masksToBounds = YES;
    
    [self.doctorContainer addSubview:queueBtn];
    
    doctorContainerHeight += queueBtn.frame.size.height + bottomSpiltor.frame.size.height;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{}

- (void)toggleView:(UIView*)view {
    if(view.alpha == 0){
        [scrollView removeConstraint: topContraint];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             view.center = CGPointMake(view.center.x, view.center.y + view.frame.size.height + 8);
                             view.alpha = 1.0;
                        
                             [scrollView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [expandArrow setImage:[UIImage imageNamed:@"collapse_arrow.png"] forState:UIControlStateNormal];
        
                             [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.clinicMapView.frame.size.height + self.clincInfoCell.frame.size.height + doctorContainerHeight + descLbl.frame.size.height + 32)];
                         }];
    }else{
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             view.center = CGPointMake(view.center.x, view.center.y - view.frame.size.height - 8);
                             view.alpha = 0.0;
                             
                             [scrollView addConstraint:topContraint];
                             [scrollView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [expandArrow setImage:[UIImage imageNamed:@"expand_arrow.png"] forState:UIControlStateNormal];
                             
                             [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.clinicMapView.frame.size.height + self.clincInfoCell.frame.size.height + doctorContainerHeight + 16)];
                         }];
    }
}

- (IBAction)expandArrowBtnClicked:(id)sender {
    [self toggleView: descLbl];
}

- (IBAction)quickBtnClicked:(id)sender {
    isQuick = true;
    [self performSegueWithIdentifier:@"segue_book" sender:sender];
}

- (IBAction)bookmarkBtnClicked:(id)sender {
    if(clinic.isBookmark){
        clinic.isBookmark = false;
        [bookmarkBtn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }else{
        clinic.isBookmark = true;
        [bookmarkBtn setBackgroundImage:[UIImage imageNamed:@"star_filled"] forState:UIControlStateNormal];
    }
    
    if (dbClinic == nil) {
        dbClinic = [clinic save];
    }else{
        [dbClinic delele];
        dbClinic = nil;
    }
}

- (void)reserveBtnClicked:(id) sender{
    if(descLbl.alpha == 1){
        [self toggleView:descLbl];
    }
    [self performSegueWithIdentifier:@"segue_timeline" sender:sender];
}

- (void)queueBtnClicked:(id) sender{
    if([Utils IsEmpty:[Utils accessToken]]){
        [self login];
        return;
    }
    
    if(descLbl.alpha == 1){
        [self toggleView:descLbl];
    }
    [self performSegueWithIdentifier:@"segue_book" sender:nil];
}

-(void) login{
    [self performSegueWithIdentifier:@"segue_login_clinic_detail" sender:nil];
}

-(void) call:(id)sender{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[clinic contact]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue_login"]){
        LoginViewController *loginVC = [segue destinationViewController];
        loginVC.delegate = self;
    }else if([[segue identifier] isEqualToString:@"segue_timeline"]){
        UIButton *reserveBtn = (UIButton *) sender;
        TimelineViewController *timelineVC = [segue destinationViewController];
        timelineVC.clinicName = [clinic name];
        timelineVC.doctor = [clinic.doctors objectAtIndex: [reserveBtn tag]];
    }else if([[segue identifier] isEqualToString:@"segue_book"]){
        if(isQuick){
            DoctorDetailViewController *doctorDetailVC = [segue destinationViewController];
            doctorDetailVC.doctor = [clinic.doctors objectAtIndex: 0];
            doctorDetailVC.clinicName = [clinic name];
            doctorDetailVC.datetimeString = @"2016-06-09 16:00:00";
        }
    }
}

-(void) dismisswithError:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
    }
}

@end
