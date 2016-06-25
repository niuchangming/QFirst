//
//  LoginViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 24/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MozTopAlertView.h"
#import "Utils.h"
#import "ConstantValues.h"
#import "User.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize scrollView;
@synthesize mobileNoTf;
@synthesize passwordTf;
@synthesize submitBtn;
@synthesize signupPopView;
@synthesize verifyPopView;
@synthesize delegate;
@synthesize loadingBar;
@synthesize cancelBtn;
@synthesize forgotPwdPopView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self optimizeUIs];
    
    [self subscribeKeyboardNotifications];
}

-(void)optimizeUIs{
    UIView *phoneIcon = [[UIView alloc] init];
    [phoneIcon setFrame:CGRectMake(0.0f, 0.0f, 58.0f, 24.0f)];
    [phoneIcon setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 16, 16)];
    [phoneImg setImage:[UIImage imageNamed:@"phone.png"]];
    [phoneIcon addSubview:phoneImg];
    
    UILabel *phonePrefixLbl = [[UILabel alloc] initWithFrame:CGRectMake(24, 4, 32, 16)];
    [phonePrefixLbl setTextColor:[Utils colorFromHexString:@"#4A4A4A"]];
    [phonePrefixLbl setText:@"+65"];
    [phonePrefixLbl setFont:[UIFont systemFontOfSize:14]];
    [phoneIcon addSubview:phonePrefixLbl];
    
    mobileNoTf.leftViewMode = UITextFieldViewModeAlways;
    mobileNoTf.leftView = phoneIcon;
    mobileNoTf.layer.cornerRadius = 4;
    mobileNoTf.clipsToBounds = YES;
    
    UIView *passwordIcon = [[UIView alloc] init];
    [passwordIcon setFrame:CGRectMake(0.0f, 0.0f, 24.0f, 24.0f)];
    [passwordIcon setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *passwordImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 16, 16)];
    [passwordImg setImage:[UIImage imageNamed:@"password.png"]];
    [passwordIcon addSubview:passwordImg];
    
    passwordTf.leftViewMode = UITextFieldViewModeAlways;
    passwordTf.leftView = passwordIcon;
    passwordTf.layer.cornerRadius = 4;
    passwordTf.clipsToBounds = YES;
    
    submitBtn.layer.cornerRadius = 4;
    submitBtn.clipsToBounds = YES;
}

-(void) subscribeKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) popupSignupDialog{
    if(signupPopView == nil){
        SignupView *signupView = [[SignupView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        signupView.delegate = self;
        signupPopView = [[JCAlertView alloc] initWithCustomView:signupView dismissWhenTouchedBackground:NO];
    }
    
    [signupPopView show];
}

-(void) popupVerifyDialog{
    if(verifyPopView == nil){
        PasscodeView *passView = [[PasscodeView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        passView.delegate = self;
        verifyPopView = [[JCAlertView alloc] initWithCustomView:passView dismissWhenTouchedBackground:NO];
    }
    
    [verifyPopView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) signupCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
        [signupPopView dismissWithCompletion:nil];
        return;
    }
    
    [signupPopView dismissWithCompletion:nil];
    [self parseUser:resp];
    [self popupVerifyDialog];
}

-(void) parseUser:(id) responseObject{
    if([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *obj = (NSDictionary *)responseObject;
        NSString *errMsg = [obj valueForKey:@"error"];
    
        if(![Utils IsEmpty:errMsg]) {
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else{
            User *user = [[User alloc] initWithJson:obj];
            [self storeUserInfo:user];
            [delegate loginComplete:nil];
        }
    }else{
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
    }
}

-(void) storeUserInfo: (User *) user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.accessToken forKey:@"access_token"];
    [defaults setObject:user.mobile forKey:@"mobile"];
    [defaults setBool:user.isActive forKey:@"is_active"];
    [defaults setObject:user.name forKey:@"name"];
    [defaults setObject:user.ic forKey:@"ic"];
    [defaults setObject:user.email forKey:@"email"];
    [defaults setInteger:user.entityId forKey:@"entity_id"];
    [defaults setObject:user.role forKey:@"role"];
    [defaults synchronize];
}

-(void) verifyCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [delegate loginComplete:err];
    }else{
        [self parseUser:resp];
    }
    
    [verifyPopView dismissWithCompletion:nil];
    [self cancelBtnClicked:nil];
}

- (IBAction)submitBtnClicked:(id)sender {
    if([Utils IsEmpty:mobileNoTf.text] || ![Utils isSingaporeMobileNo:[NSString stringWithFormat:@"+65%@", mobileNoTf.text]]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Mobile format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([Utils IsEmpty:passwordTf.text]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Password cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    [loadingBar startAnimating];
    [submitBtn setEnabled:false];
    [cancelBtn setEnabled:false];
    
    NSString *url = [NSString stringWithFormat:@"%@UserController/signin", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSString stringWithFormat:@"+65%@", mobileNoTf.text] forKey: @"mobile"];
    [params setObject: passwordTf.text forKey: @"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                [self parseUser:responseObject];
                [self cancelBtnClicked:nil];
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error" doText:nil doBlock:nil parentView:self.view];
        }
        [loadingBar stopAnimating];
        [submitBtn setEnabled:true];
        [cancelBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
        [submitBtn setEnabled:true];
        [cancelBtn setEnabled:true];
    }];
}

-(void) popupForgotPwdDialog{
    if(forgotPwdPopView == nil){
        ForgotPasswordView *forgotView = [[ForgotPasswordView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        forgotView.delegate = self;
        forgotPwdPopView = [[JCAlertView alloc] initWithCustomView:forgotView dismissWhenTouchedBackground:NO];
    }
    
    [forgotPwdPopView show];
}

-(void) askPwdCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
    }else{
        [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"New password sent." doText:nil doBlock:nil parentView:self.view];
    }
    [forgotPwdPopView dismissWithCompletion:nil];
}

- (IBAction)signupBtnClicked:(id)sender {
    [self popupSignupDialog];
}

- (IBAction)forgetPwdBtnClicked:(id)sender {
    [self popupForgotPwdDialog];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end







