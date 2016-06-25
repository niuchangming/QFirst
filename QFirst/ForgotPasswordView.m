//
//  ForgotPasswordView.m
//  QFirst
//
//  Created by ChangmingNiu on 25/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "ForgotPasswordView.h"
#import "Utils.h"
#import <JCAlertView/JCAlertView.h>
#import "ConstantValues.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation ForgotPasswordView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ForgotPasswordView" owner:self options:nil]objectAtIndex:0];
        
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
        
        self.mobileTf.leftViewMode = UITextFieldViewModeAlways;
        self.mobileTf.leftView = userIcon;
        
        self.mobileTf.layer.cornerRadius = 4;
        self.mobileTf.clipsToBounds = YES;
        
        self.submitBtn.layer.cornerRadius = 4;
        self.submitBtn.clipsToBounds = YES;
        
        self.mobileTf.text = [Utils mobile];
    }
    return self;
}

- (IBAction)submitBtnClicked:(id)sender {
    if([Utils IsEmpty:self.mobileTf.text] || ![Utils isSingaporeMobileNo:self.mobileTf.text]) {
        [self.delegate askPwdCompletedWithResponseData:nil withError:@"Mobile format is incorrect."];
        return;
    }
    
    [self.loadingBar startAnimating];
    [self.submitBtn setEnabled:false];
    
    NSString *url = [NSString stringWithFormat:@"%@UserController/forgotpassword", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSString stringWithFormat:@"+65%@", self.mobileTf.text] forKey: @"mobile"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [self.delegate askPwdCompletedWithResponseData:nil withError:errMsg];
            }else{
                [self.delegate askPwdCompletedWithResponseData:responseObject withError:nil];
            }
        }else{
            [self.delegate askPwdCompletedWithResponseData:nil withError:@"Unknown error"];
        }
        [self.loadingBar stopAnimating];
        [self.submitBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate askPwdCompletedWithResponseData:nil withError:[error localizedDescription]];
        [self.loadingBar stopAnimating];
        [self.submitBtn setEnabled:true];
    }];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [((JCAlertView*)self.superview) dismissWithCompletion:^{
        self.mobileTf.text = @"";
    }];
}
@end
