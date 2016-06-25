//
//  LoginViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 24/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JCAlertView/JCAlertView.h>
#import "SignupView.h"
#import "PasscodeView.h"
#import "ForgotPasswordView.h"

@protocol LoginViewControllerDelegate <NSObject>

@required
-(void) loginComplete:(NSString*) err;

@end

@interface LoginViewController : UIViewController<SignupViewDelegate, PasscodeViewDelegate, ForgotPwsViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) JCAlertView *signupPopView;
@property (strong, nonatomic) JCAlertView *verifyPopView;
@property (strong, nonatomic) JCAlertView *forgotPwdPopView;
@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;
- (IBAction)submitBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
- (IBAction)signupBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
- (IBAction)forgetPwdBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;

@end
