//
//  PasscodeView.m
//  FirstQ
//
//  Created by ChangmingNiu on 28/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "PasscodeView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Utils.h"
#import "ConstantValues.h"
#import <JCAlertView/JCAlertView.h>

@implementation PasscodeView

@synthesize timer;
@synthesize mobileNumber;
@synthesize timeTV;
@synthesize codeTV;
@synthesize verifyBtn;
@synthesize loadingBar;
@synthesize seconds;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PasscodeView" owner:self options:nil]objectAtIndex:0];
        
        [timeTV.layer setCornerRadius:2.0f];
        [codeTV.layer setCornerRadius:2.0f];
        [verifyBtn.layer setCornerRadius:2.0f];
        
        seconds = 60;
        
        timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeRemain) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)timeRemain {
    if(seconds == 0){
        [verifyBtn setTitle:@"Re-send" forState:UIControlStateNormal];
        [verifyBtn setBackgroundColor:[Utils colorFromHexString:@"#8E8E93"]];
        return;
    }
    seconds--;
    timeTV.text = [NSString stringWithFormat:@"(%is)", seconds];
}

- (IBAction)verifyBtnClicked:(id)sender {
    if([verifyBtn.titleLabel.text isEqual:@"Re-send"]) {
        [self resend];
    }else{
        [self verify];
    }
}

- (IBAction)cancelBtnClicked:(id)sender {
    [((JCAlertView*)self.superview) dismissWithCompletion:^(){
        codeTV.text = @"";
        seconds = 60;
        [timer invalidate];
    }];
}

-(void) verify{
    [loadingBar startAnimating];
    [verifyBtn setEnabled:false];
    
    if([Utils IsEmpty:[Utils mobile]]) {
        [self cancelBtnClicked:nil];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@UserController/activeMobile", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [Utils mobile] forKey: @"mobile"];
    [params setObject: [NSNumber numberWithInteger:[codeTV.text intValue]] forKey: @"activeCode"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [delegate verifyCompletedWithResponseData:nil withError:errMsg];
            }else{
                [delegate verifyCompletedWithResponseData:responseObject withError:nil];
            }
        }else{
            [delegate verifyCompletedWithResponseData:nil withError:@"Unknown error"];
        }
        [loadingBar stopAnimating];
        [verifyBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate verifyCompletedWithResponseData:nil withError:[error localizedDescription]];
        [loadingBar stopAnimating];
        [verifyBtn setEnabled:true];
    }];
}

-(void) resend{
    [loadingBar startAnimating];
    [verifyBtn setEnabled:false];
    
    NSString *url = [NSString stringWithFormat:@"%@UserController/resendActiveCode", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [Utils mobile] forKey: @"mobile"];
    [params setObject: [Utils accessToken] forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [loadingBar stopAnimating];
        [verifyBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loadingBar stopAnimating];
        [verifyBtn setEnabled:true];
    }];
    
    [self reset];
}

-(void) reset{
    [verifyBtn setTitle:@"Verify" forState:UIControlStateNormal];
    [verifyBtn setBackgroundColor:[Utils colorFromHexString:@"#4CD964"]];
    seconds = 60;
}

@end












