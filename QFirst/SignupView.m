//
//  SignupView.m
//  Task
//
//  Created by Niu Changming on 12/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "SignupView.h"
#import "Utils.h"
#import <JCAlertView/JCAlertView.h>
#import "ConstantValues.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation SignupView

@synthesize mobileTV;
@synthesize passwordTV;
@synthesize signupBtn;
@synthesize loadingBar;
@synthesize delegate;
@synthesize cancelBtn;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SignupView" owner:self options:nil]objectAtIndex:0];
    
        UIView *userIcon = [[UIView alloc] init];
        [userIcon setFrame:CGRectMake(0.0f, 0.0f, 58.0f, 24.0f)];
        [userIcon setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 16, 16)];
        [userImg setImage:[UIImage imageNamed:@"phone.png"]];
        [userIcon addSubview:userImg];
        
        UILabel *phonePrefixLbl = [[UILabel alloc] initWithFrame:CGRectMake(24, 4, 32, 16)];
        [phonePrefixLbl setTextColor:[Utils colorFromHexString:@"#4A4A4A"]];
        [phonePrefixLbl setText:@"+65"];
        [phonePrefixLbl setFont:[UIFont systemFontOfSize:14]];
        [userIcon addSubview:phonePrefixLbl];
        
        mobileTV.leftViewMode = UITextFieldViewModeAlways;
        mobileTV.leftView = userIcon;
        
        UIView *passwordIcon = [[UIView alloc] init];
        [passwordIcon setFrame:CGRectMake(0.0f, 0.0f, 24.0f, 24.0f)];
        [passwordIcon setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 16, 16)];
        [pwdImg setImage:[UIImage imageNamed:@"password.png"]];
        [passwordIcon addSubview:pwdImg];
        passwordTV.leftViewMode = UITextFieldViewModeAlways;
        passwordTV.leftView = passwordIcon;
        
        [mobileTV.layer setCornerRadius:4.0f];
        [passwordTV.layer setCornerRadius:4.0f];
        [signupBtn.layer setCornerRadius:4.0f];
    }
    return self;
}

- (IBAction)signupBtnClicked:(id)sender {
    if([Utils IsEmpty:mobileTV.text] || ![Utils isSingaporeMobileNo:[NSString stringWithFormat:@"+65%@", mobileTV.text]]){
        [delegate signupCompletedWithResponseData:nil withError:@"Mobile format is incorrect."];
        return;
    }
    
    if([Utils IsEmpty:passwordTV.text]) {
        [delegate signupCompletedWithResponseData:nil withError:@"Password cannot be empty."];
        return;
    }
    
    [loadingBar startAnimating];
    [signupBtn setEnabled:false];
    [cancelBtn setEnabled:false];
    
    NSString *url = [NSString stringWithFormat:@"%@UserController/signup", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSString stringWithFormat:@"+65%@", mobileTV.text] forKey: @"mobile"];
    [params setObject: passwordTV.text forKey: @"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [delegate signupCompletedWithResponseData:nil withError:errMsg];
            }else{
                [delegate signupCompletedWithResponseData:responseObject withError:nil];
            }
        }else{
            [delegate signupCompletedWithResponseData:nil withError:@"Unknown error"];
        }
        [loadingBar stopAnimating];
        [signupBtn setEnabled:true];
        [cancelBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate signupCompletedWithResponseData:nil withError:[error localizedDescription]];
        [loadingBar stopAnimating];
        [signupBtn setEnabled:true];
        [cancelBtn setEnabled:true];
    }];
}

- (IBAction)cancelBrnClicked:(id)sender {
    [((JCAlertView*)self.superview) dismissWithCompletion:^{
        mobileTV.text = @"";
        passwordTV.text = @"";
    }];
}

@end


















