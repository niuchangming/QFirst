//
//  DoctorDetailViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 19/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "DBUser.h"
#import "DBImage.h"
#import "LoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ReserveDelegate <NSObject>

@required
-(void) reserveCompletedWithResponseData:(id)resp withError:(NSString*) err;

@end

@interface DoctorDetailViewController : UIViewController<LoginViewControllerDelegate>

@property (nonnull,strong, nonatomic) DBUser *doctor;
@property (strong, nonnull) DBClinic *clinic;
@property NSTimeInterval datetime;
@property bool isQuickMode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UIImageView *avatarBg;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *termLbl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *clinicInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *iCard;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBtn;

@property (weak, nonatomic) id<ReserveDelegate> delegate;
- (IBAction)nextBtnClicked:(id)sender;

- (IBAction)submitBtnClicked:(id)sender;
@end

NS_ASSUME_NONNULL_END
