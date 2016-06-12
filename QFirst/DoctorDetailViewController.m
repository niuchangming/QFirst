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
#import "MozTopAlertView.h"
#import "ConstantValues.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface DoctorDetailViewController ()

@end

@implementation DoctorDetailViewController

@synthesize scrollView;
@synthesize doctor;
@synthesize clinicName;
@synthesize datetimeString;
@synthesize blurView;
@synthesize avatarIv;
@synthesize nameLbl;
@synthesize clinicInfoLbl;
@synthesize timeLbl;
@synthesize avatarBg;
@synthesize nameTf;
@synthesize emailTf;
@synthesize phoneTf;
@synthesize iCard;
@synthesize submitBtn;
@synthesize loadingBar;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    blurView.blurRadius = 30;
    
    avatarIv.layer.cornerRadius = self.avatarIv.frame.size.width / 2;
    avatarIv.clipsToBounds = YES;
    avatarIv.layer.masksToBounds = YES;
    avatarIv.layer.borderWidth = 2.0f;
    avatarIv.layer.borderColor = [UIColor whiteColor].CGColor;
    
    submitBtn.layer.cornerRadius = 4;
    submitBtn.clipsToBounds = YES;
    submitBtn.layer.masksToBounds = YES;

    nameLbl.text = [doctor name];
    timeLbl.text = [Utils getReadableDateString:[Utils getDateByDateString:datetimeString]];
    clinicInfoLbl.text = clinicName;
    
    [self subscribeKeyboardNotifications];
}

-(void) viewDidLayoutSubviews{
    CALayer *nameBorder = [CALayer layer];
    CGFloat borderWidth = 1;
    nameBorder.borderColor = [UIColor darkGrayColor].CGColor;
    nameBorder.frame = CGRectMake(0, nameTf.frame.size.height - borderWidth, nameTf.frame.size.width, nameTf.frame.size.height);
    nameBorder.borderWidth = borderWidth;
    [nameTf.layer addSublayer:nameBorder];
    nameTf.layer.masksToBounds = YES;
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.borderColor = [UIColor darkGrayColor].CGColor;
    emailBorder.frame = CGRectMake(0, emailTf.frame.size.height - borderWidth, emailTf.frame.size.width, emailTf.frame.size.height);
    emailBorder.borderWidth = borderWidth;
    [emailTf.layer addSublayer:emailBorder];
    emailTf.layer.masksToBounds = YES;
    
    CALayer *phoneBorder = [CALayer layer];
    phoneBorder.borderColor = [UIColor darkGrayColor].CGColor;
    phoneBorder.frame = CGRectMake(0, phoneTf.frame.size.height - borderWidth, phoneTf.frame.size.width, phoneTf.frame.size.height);
    phoneBorder.borderWidth = borderWidth;
    [phoneTf.layer addSublayer:phoneBorder];
    phoneTf.layer.masksToBounds = YES;
    
    CALayer *icBorder = [CALayer layer];
    icBorder.borderColor = [UIColor darkGrayColor].CGColor;
    icBorder.frame = CGRectMake(0, iCard.frame.size.height - borderWidth, iCard.frame.size.width, iCard.frame.size.height);
    icBorder.borderWidth = borderWidth;
    [iCard.layer addSublayer:icBorder];
    iCard.layer.masksToBounds = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)submitBtnClicked:(id)sender {
    if([Utils IsEmpty:nameTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Name format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:emailTf.text] || ![Utils isValidEmail:emailTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Email format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:phoneTf.text] || ![Utils isSingaporeMobileNo:phoneTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Mobile format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:iCard.text] || ![Utils isSingaporeIC:iCard.text]){
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
    [params setObject: [NSNumber numberWithInt:doctor.entityId] forKey: @"doctorId"];
    [params setObject: datetimeString forKey:@"datetime"];
    [params setObject: nameTf.text forKey:@"name"];
    [params setObject:emailTf.text forKey:@"email"];
    [params setObject:phoneTf.text forKey:@"mobile"];
    [params setObject:iCard.text forKey:@"ic"];
    
    [loadingBar startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Reserve successfully" doText:nil doBlock:nil parentView:self.view];
                if([self.delegate respondsToSelector:@selector(reserveCompletedWithResponseData:withError:)]){
                    [self.delegate reserveCompletedWithResponseData:responseObject withError:errMsg];
                }
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error" doText:nil doBlock:nil parentView:self.view];
        }
        [loadingBar stopAnimating];
        [submitBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
        [submitBtn setEnabled:true];
    }];
}

-(void) login{
    [self performSegueWithIdentifier:@"segue_login_doctor_detail" sender:nil];
}

@end























