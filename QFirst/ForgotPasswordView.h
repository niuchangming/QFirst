//
//  ForgotPasswordView.h
//  QFirst
//
//  Created by ChangmingNiu on 25/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgotPwsViewDelegate <NSObject>

@required
-(void) askPwdCompletedWithResponseData:(id)resp withError:(NSString*) err;

@end

@interface ForgotPasswordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) id<ForgotPwsViewDelegate> delegate;
- (IBAction)cancelBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@end
