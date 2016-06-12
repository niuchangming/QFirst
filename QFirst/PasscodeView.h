//
//  PasscodeView.h
//  FirstQ
//
//  Created by ChangmingNiu on 28/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasscodeViewDelegate <NSObject>

@required
-(void) verifyCompletedWithResponseData:(id)resp withError:(NSString*) err;

@end

@interface PasscodeView : UIView
@property int seconds;
@property (strong, nonatomic) NSString *mobileNumber;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) id<PasscodeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeTV;
@property (weak, nonatomic) IBOutlet UITextField *codeTV;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
- (IBAction)verifyBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;
-(void) reset;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@end
