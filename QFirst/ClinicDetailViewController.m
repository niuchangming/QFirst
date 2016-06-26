//
//  ClinicDetailViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 4/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DoctorCell.h"
#import "Utils.h"
#import "MozTopAlertView.h"
#import "DBImage.h"
#import "ClinicDetailViewController.h"
#import "UILabel+DynamicSize.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DBUser+CoreDataProperties.h"
#import "ConstantValues.h"
#import "AppDelegate.h"
#import "TimelineViewController.h"
#import "DoctorDetailViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Queue.h"

@interface ClinicDetailViewController (){
    NSLayoutConstraint *topContraint;
    CGPoint tempContentOffset;
    int doctorContainerHeight;
    bool isFirstLoad;
}

@end

@implementation ClinicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doctorArray = [self.clinic.users allObjects];
    
    isFirstLoad = true;
    
    if(!self.clinic.isCoop.boolValue){
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.descLbl.text = self.clinic.desc;
    self.clinicName.text = self.clinic.name;
    self.addressLbl.text = self.clinic.address;
    [self.descLbl resizeToFit];
    
    self.clinicLogo.layer.cornerRadius = self.clinicLogo.frame.size.width / 2;
    self.clinicLogo.clipsToBounds = YES;
    self.clinicLogo.layer.masksToBounds = YES;
    if([[self.clinic images] count] > 0){
        [self.clinicLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%@", baseUrl, [[[[self.clinic images] allObjects] objectAtIndex:0] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }else{
        [self.clinicLogo setImage:[UIImage imageNamed:@"default_avatar"]];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self loadMapView];
    
    [self setupDoctorCells];
    
    topContraint = [NSLayoutConstraint
                    constraintWithItem:self.doctorContainer
                    attribute:NSLayoutAttributeTopMargin
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.descLbl
                    attribute:NSLayoutAttributeTopMargin
                    multiplier: 1.0f
                    constant: -9.0f];
    
    self.descLbl.center = CGPointMake(self.descLbl.center.x, self.descLbl.center.y - self.descLbl.frame.size.height - 8);
    self.descLbl.alpha = 0.0;
    
    [self.scrollView addConstraint:topContraint];
    
    [self checkBookmark];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.clinicMapView.frame.size.height + self.clincInfoCell.frame.size.height + doctorContainerHeight + 16)];
    
    if(isFirstLoad){
        CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.clinic.latitude doubleValue], [self.clinic.longitude doubleValue])
                                                           altitude:0
                                                 horizontalAccuracy:0
                                                   verticalAccuracy:0
                                                          timestamp:[NSDate date]];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locObj.coordinate, 800, 800);
        
        @try{
            [self.clinicMapView setRegion:region animated:YES];
        }@catch(NSException *e){
            NSLog(@"Region Error:%@ ", e);
        }

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([self.clinic.latitude doubleValue], [self.clinic.longitude doubleValue]);
        annotation.title = self.clinic.name;
        annotation.subtitle = self.clinic.address;
        
        [self.clinicMapView addAnnotation:annotation];
        
        isFirstLoad = false;
    }
}

-(void) checkBookmark{
    if(self.clinic.isBookmark.boolValue == YES){
        [self.bookmarkBtn setBackgroundImage:[UIImage imageNamed:@"star_filled"] forState:UIControlStateNormal];
    }
}

-(void) loadMapView{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.clinicMapView.showsUserLocation = YES;
    [self.clinicMapView setMapType:MKMapTypeStandard];
    [self.clinicMapView setZoomEnabled:YES];
    [self.clinicMapView setScrollEnabled:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self.clinicMapView addSubview:view];
}

-(void) setupDoctorCells{
    if(self.clinic.isCoop.boolValue){
        if(self.doctorArray.count > 0){
            for(int i = 0; i < [self.doctorArray count]; i++){
                UIView *spiltor = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, i * 73, self.view.frame.size.width, 1)];
                [spiltor setBackgroundColor:[Utils colorFromHexString:@"#EFEFF4"]];
                [self.doctorContainer addSubview:spiltor];
                
                UIView *doctorCell = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, i * 72 + i + 1, self.view.frame.size.width, 72)];
                
                UIImageView *avatarIV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 48, 48)];
                avatarIV.layer.cornerRadius = avatarIV.frame.size.width / 2;
                avatarIV.clipsToBounds = YES;
                avatarIV.contentMode = UIViewContentModeScaleAspectFill;
                avatarIV.layer.masksToBounds = YES;
                if([[[self.doctorArray objectAtIndex:i] images] count] > 0){
                    [avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserController/showUserAvatarThumbnail?id=%@", baseUrl, [[[[[self.doctorArray objectAtIndex:i] images] allObjects] objectAtIndex:0] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
                }else{
                    [avatarIV setImage:[UIImage imageNamed:@"default_avatar"]];
                }
                [doctorCell addSubview:avatarIV];
                
                UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(64, 25, self.view.frame.size.width - 152, 22)];
                nameLbl.text = [[self.doctorArray objectAtIndex:i] name];
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
                
                if(i == [self.doctorArray count] - 1) {
                    UIView *bottomSpiltor = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, [self.doctorArray count] * 72 + [self.doctorArray count] + 1, self.view.frame.size.width, 1)];
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
                    constraintWithItem:self.doctorContainer
                    attribute:NSLayoutAttributeBottomMargin
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.queueBtn
                    attribute:NSLayoutAttributeBottomMargin
                    multiplier: 1.0f
                    constant: 0.0f];
    bottomContraint.priority = 1000;
    
    [self.scrollView addConstraint:bottomContraint];
}

-(void) setupActionButtons:(NSString *) type afterView: (UIView*) bottomSpiltor{
    self.queueBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, bottomSpiltor.frame.origin.y + bottomSpiltor.frame.size.height + 8, self.view.frame.size.width - 16, 40)];
    
    if([type isEqualToString:@"call"]){
        [self.queueBtn setTitle:[NSString stringWithFormat:@"Call (%@)", [Utils removeWhiteSpace:self.clinic.contact]]forState:UIControlStateNormal];
        [self.queueBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self.queueBtn setBackgroundColor:[Utils colorFromHexString:@"#007AFF"]];
    }else{
        [self.queueBtn setTitle:@"Take A Queue" forState:UIControlStateNormal];
        [self.queueBtn addTarget:self action:@selector(queueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.queueBtn setBackgroundColor:[Utils colorFromHexString:@"#4CD964"]];
    }
    
    [self.queueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.queueBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    self.queueBtn.layer.cornerRadius = 4;
    self.queueBtn.clipsToBounds = YES;
    self.queueBtn.layer.masksToBounds = YES;
    
    [self.doctorContainer addSubview:self.queueBtn];
    
    doctorContainerHeight += self.queueBtn.frame.size.height + bottomSpiltor.frame.size.height;
    
    self.loadingBar = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingBar.frame = CGRectMake(self.queueBtn.frame.size.width - 28, 10, 20, 20);
    [self.queueBtn addSubview:self.loadingBar];
    [self.loadingBar hidesWhenStopped];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{}

- (void)toggleView:(UIView*)view {
    if(view.alpha == 0){
        [self.scrollView removeConstraint: topContraint];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             view.center = CGPointMake(view.center.x, view.center.y + view.frame.size.height + 8);
                             view.alpha = 1.0;
                        
                             [self.scrollView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [self.expandArrow setImage:[UIImage imageNamed:@"collapse_arrow.png"] forState:UIControlStateNormal];
        
                             [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.clinicMapView.frame.size.height + self.clincInfoCell.frame.size.height + doctorContainerHeight + self.descLbl.frame.size.height + 32)];
                         }];
    }else{
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             view.center = CGPointMake(view.center.x, view.center.y - view.frame.size.height - 8);
                             view.alpha = 0.0;
                             
                             [self.scrollView addConstraint:topContraint];
                             [self.scrollView layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [self.expandArrow setImage:[UIImage imageNamed:@"expand_arrow.png"] forState:UIControlStateNormal];
                             
                             [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.clinicMapView.frame.size.height + self.clincInfoCell.frame.size.height + doctorContainerHeight + 16)];
                         }];
    }
}

- (IBAction)expandArrowBtnClicked:(id)sender {
    [self toggleView: self.descLbl];
}

- (IBAction)quickBtnClicked:(id)sender {
    if([Utils IsEmpty:self.clinic.users] || self.clinic.users.count == 0){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"No reservation service." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    [self performSegueWithIdentifier:@"segue_quick_book" sender:sender];
}

- (IBAction)bookmarkBtnClicked:(id)sender {
    if(self.clinic.isBookmark.boolValue){
        [self.bookmarkBtn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        self.clinic.isBookmark = [NSNumber numberWithBool:NO];
    }else{
        [self.bookmarkBtn setBackgroundImage:[UIImage imageNamed:@"star_filled"] forState:UIControlStateNormal];
        self.clinic.isBookmark = [NSNumber numberWithBool:YES];
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

- (void)reserveBtnClicked:(id) sender{
    if(self.descLbl.alpha == 1){
        [self toggleView:self.descLbl];
    }
    [self performSegueWithIdentifier:@"segue_timeline" sender:sender];
}

- (void)queueBtnClicked:(id) sender{
    if([Utils IsEmpty:[Utils accessToken]]){
        [self login];
        return;
    }
    
    [self.loadingBar startAnimating];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[Utils accessToken] forKey: @"accessToken"];
    [params setObject:self.clinic.entityId forKey: @"clinicId"];
    [params setObject:[NSNumber numberWithBool:YES] forKey: @"isApp"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@ClinicController/takeQueue", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            if(![Utils IsEmpty:errMsg]){
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                Queue *queue = [[Queue alloc] initWithJson:obj];
                if(queue != nil){
                    [MozTopAlertView showWithType:MozAlertTypeSuccess text:[NSString stringWithFormat:@"You queue number is: A%i", queue.number] doText:nil doBlock:nil parentView:self.view];
                    
                    [self postUserInfoUpdateNotification];
                }
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [self.loadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [self.loadingBar stopAnimating];
    }];
}

-(void) postUserInfoUpdateNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_INFO_UPDATE object:nil userInfo:nil];
}

-(void) login{
    [self performSegueWithIdentifier:@"segue_login_clinic_detail" sender:nil];
}

-(void) call:(id)sender{
    NSString *contactNo = [Utils removeWhiteSpace:self.clinic.contact];
    if([Utils isSingaporeContactNo:contactNo]){
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:contactNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }else{
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Phone number cannot be called." doText:nil doBlock:nil parentView:self.view];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue_login"]){
        LoginViewController *loginVC = [segue destinationViewController];
        loginVC.delegate = self;
    }else if([[segue identifier] isEqualToString:@"segue_timeline"]){
        UIButton *reserveBtn = (UIButton *) sender;
        TimelineViewController *timelineVC = [segue destinationViewController];
        timelineVC.clinicName = [self.clinic name];
        timelineVC.doctor = [self.doctorArray objectAtIndex: [reserveBtn tag]];
    }else if([[segue identifier] isEqualToString:@"segue_quick_book"]){
        DoctorDetailViewController *doctorDetailVC = [segue destinationViewController];
        doctorDetailVC.clinic = self.clinic;
        doctorDetailVC.isQuickMode = true;
        doctorDetailVC.delegate = self;
        doctorDetailVC.datetime = [[NSDate date] timeIntervalSince1970];
    }
}

-(void) reserveCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if([Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Reserve successfully." doText:nil doBlock:nil parentView:self.view];
    }
}

-(void) loginComplete:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeSuccess text:err doText:nil doBlock:nil parentView:self.view];
    }
}

@end
