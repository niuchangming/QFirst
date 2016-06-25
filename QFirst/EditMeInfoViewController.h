//
//  EditEmailViewController.h
//  QFirst
//
//  Created by ChangmingNiu on 19/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"
#import "PasscodeView.h"

@protocol EditMeInfoDelegate <NSObject>

@required
-(void) updateCompletedWithResponseData:(NSString*)data withType:(NSString*) type;

@end

@interface EditMeInfoViewController : UIViewController<PasscodeViewDelegate>

@property (strong, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *editTf;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@property (weak, nonatomic) IBOutlet UITextView *noteTv;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) id<EditMeInfoDelegate> delegate;
- (IBAction)submitBtnClicked:(id)sender;

@end
