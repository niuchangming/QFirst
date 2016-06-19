//
//  DoctorDetailViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 19/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#
#import "MozTopAlertView.h"
#import "ConstantValues.h"
#import "Reservation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DBClinic.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface DoctorDetailViewController (){
    int next;
    int doctorIndex;
    NSTimeInterval day;
    NSArray *doctors;
    NSMutableDictionary *reservationMap;
}

@end

@implementation DoctorDetailViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blurView.blurRadius = 30;
    
    self.avatarIv.layer.cornerRadius = self.avatarIv.frame.size.width / 2;
    self.avatarIv.clipsToBounds = YES;
    self.avatarIv.layer.masksToBounds = YES;
    self.avatarIv.layer.borderWidth = 2.0f;
    self.avatarIv.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.clipsToBounds = YES;
    self.submitBtn.layer.masksToBounds = YES;
    
    [self subscribeKeyboardNotifications];
    
    if(self.isQuickMode){
        [self.scrollView setHidden:YES];
        doctors = [self.clinic.users allObjects];
        [self loadClinicReservations];
        [self getDefaultDayInterval];
    }else{
        self.nameLbl.text = [self.doctor name];
        self.timeLbl.text = [Utils getReadableDateString:[NSDate dateWithTimeIntervalSince1970:self.datetime]];
        self.clinicInfoLbl.text = self.doctor.clinic.name;
        [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%@", baseUrl, [[self.doctor image] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }
}

-(void) viewDidLayoutSubviews{
    CALayer *nameBorder = [CALayer layer];
    CGFloat borderWidth = 1;
    nameBorder.borderColor = [UIColor darkGrayColor].CGColor;
    nameBorder.frame = CGRectMake(0, self.nameTf.frame.size.height - borderWidth, self.nameTf.frame.size.width, self.nameTf.frame.size.height);
    nameBorder.borderWidth = borderWidth;
    [self.nameTf.layer addSublayer:nameBorder];
    self.nameTf.layer.masksToBounds = YES;
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.borderColor = [UIColor darkGrayColor].CGColor;
    emailBorder.frame = CGRectMake(0, self.emailTf.frame.size.height - borderWidth, self.emailTf.frame.size.width, self.emailTf.frame.size.height);
    emailBorder.borderWidth = borderWidth;
    [self.emailTf.layer addSublayer:emailBorder];
    self.emailTf.layer.masksToBounds = YES;
    
    CALayer *phoneBorder = [CALayer layer];
    phoneBorder.borderColor = [UIColor darkGrayColor].CGColor;
    phoneBorder.frame = CGRectMake(0, self.phoneTf.frame.size.height - borderWidth, self.phoneTf.frame.size.width, self.phoneTf.frame.size.height);
    phoneBorder.borderWidth = borderWidth;
    [self.phoneTf.layer addSublayer:phoneBorder];
    self.phoneTf.layer.masksToBounds = YES;
    
    CALayer *icBorder = [CALayer layer];
    icBorder.borderColor = [UIColor darkGrayColor].CGColor;
    icBorder.frame = CGRectMake(0, self.iCard.frame.size.height - borderWidth, self.iCard.frame.size.width, self.iCard.frame.size.height);
    icBorder.borderWidth = borderWidth;
    [self.iCard.layer addSublayer:icBorder];
    self.iCard.layer.masksToBounds = YES;
}

-(void) getDefaultDayInterval{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitCalendar fromDate:[NSDate date]];
    NSInteger minute = [comp minute];
    int remainder = minute % 30;
    long rounded = minute + 30 - remainder;
    [comp setMinute:rounded];
    
    day = [[comp date] timeIntervalSince1970];
}

-(void) subscribeKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    CGPoint tableViewBottomPoint = CGPointMake(0, CGRectGetMaxY([self.scrollView bounds]));
    CGPoint convertedTableViewBottomPoint = [self.scrollView convertPoint:tableViewBottomPoint toView:keyWindow];
    CGFloat keyboardOverlappedSpaceHeight = convertedTableViewBottomPoint.y - keyBoardFrame.origin.y;
    if (keyboardOverlappedSpaceHeight > 0){
        UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(0, 0, keyboardOverlappedSpaceHeight, 0);
        [self.scrollView setContentInset:tableViewInsets];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    [self.scrollView setContentInset:tableViewInsets];
}

-(void) loadClinicReservations{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    [HUD showInView:self.navigationController.view];
    
    NSString *url = [NSString stringWithFormat:@"%@ClinicController/getAllReservationsByClinic", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: self.clinic.entityId forKey: @"clinicId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            for(NSDictionary *data in array){
                reservationMap = [[NSMutableDictionary alloc] init];
                Reservation *reservation = [[Reservation alloc] initWithJson:data];
                [reservationMap setObject:reservation forKey:[NSNumber numberWithLongLong:[reservation.reservationDatetime timeIntervalSince1970]]];
            }
            [self.scrollView setHidden:NO];
            [self nextBtnClicked:self.nextBtn];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [HUD dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [HUD dismissAnimated:YES];
    }]; 
}

- (IBAction)nextBtnClicked:(id)sender {
    NSTimeInterval currentTimeInterval = day + (next + 1) * 30 * 60;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger hour = [[cal components:NSCalendarUnitHour fromDate:[NSDate dateWithTimeIntervalSince1970:currentTimeInterval]] hour];
    if(hour >= 0 && hour < 8){
        next = next + (16 - (int)hour * 2);
        [self nextBtnClicked:sender];
    }
    
    Reservation *reservation = [reservationMap objectForKey:[NSNumber numberWithLongLong:currentTimeInterval]];
    
    if(reservation == nil){
        [self updateAvailableReservation:[doctors objectAtIndex:doctorIndex] with:currentTimeInterval];
        if(doctorIndex == doctors.count - 1){
            doctorIndex = 0;
            next++;
        }else{
            doctorIndex++;
        }
    }else{
        if([doctors objectAtIndex:doctorIndex] == reservation.doctor.entityId){
            if(doctorIndex == doctors.count - 1){
                doctorIndex = 0;
                next++;
            }else{
                doctorIndex++;
            }
            [self nextBtnClicked:sender];
        }else{
            [self updateAvailableReservation:[doctors objectAtIndex:doctorIndex] with:currentTimeInterval];
            if(doctorIndex == doctors.count - 1){
                doctorIndex = 0;
                next++;
            }else{
                doctorIndex++;
            }
        }
    }
}

-(void) updateAvailableReservation: (DBUser*) doctor with:(NSTimeInterval) timeInterval{
    self.nameLbl.text = [self.doctor name];
    self.timeLbl.text = [Utils getReadableDateString:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    self.clinicInfoLbl.text = doctor.clinic.name;
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%@", baseUrl, [[self.doctor image] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
}

- (IBAction)submitBtnClicked:(id)sender {
    if([Utils IsEmpty:self.nameTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Name format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:self.emailTf.text] || ![Utils isValidEmail:self.emailTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Email format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:self.phoneTf.text] || ![Utils isSingaporeMobileNo:self.phoneTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Mobile format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:self.iCard.text] || ![Utils isSingaporeIC:self.iCard.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"IC number format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:[Utils accessToken]]) {
        [self login];
    }else{
        [self submitReservation];
    }
}

-(void) submitReservation{
    NSString *url = [NSString stringWithFormat:@"%@ClinicController/reserveDoctor", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [Utils accessToken] forKey: @"accessToken"];
    [params setObject: self.doctor.entityId forKey: @"doctorId"];
    [params setObject: [NSNumber numberWithInteger: self.datetime * 1000] forKey:@"datetime"];
    [params setObject: self.nameTf.text forKey:@"name"];
    [params setObject:self.emailTf.text forKey:@"email"];
    [params setObject:self.phoneTf.text forKey:@"mobile"];
    [params setObject:self.iCard.text forKey:@"ic"];
    
    [self.loadingBar startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                if([self.delegate respondsToSelector:@selector(reserveCompletedWithResponseData:withError:)]){
                    [self.delegate reserveCompletedWithResponseData:responseObject withError:errMsg];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error" doText:nil doBlock:nil parentView:self.view];
        }
        [self.loadingBar stopAnimating];
        [self.submitBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [self.loadingBar stopAnimating];
        [self.submitBtn setEnabled:true];
    }];
}

-(void) login{
    [self performSegueWithIdentifier:@"segue_login_doctor_detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue_login_doctor_detail"]){
        LoginViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

-(void) loginComplete:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end























