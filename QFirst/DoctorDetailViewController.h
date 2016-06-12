//
//  DoctorDetailViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 19/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "User.h"

@protocol ReserveDelegate <NSObject>

@required
-(void) reserveCompletedWithResponseData:(id)resp withError:(NSString*) err;

@end

@interface DoctorDetailViewController : UIViewController

@property (strong, nonatomic) User *doctor;
@property (strong, nonatomic) NSString *clinicName;
@property (strong, nonatomic) NSString *datetimeString;
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

@property (weak, nonatomic) id<ReserveDelegate> delegate;

- (IBAction)submitBtnClicked:(id)sender;
@end
