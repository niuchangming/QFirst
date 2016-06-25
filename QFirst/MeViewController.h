//
//  MeViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 7/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "User.h"
#import "LoginViewController.h"
#import "EditMeInfoViewController.h"

@interface MeViewController : UIViewController<LoginViewControllerDelegate, EditMeInfoDelegate>

@property (strong, nonatomic) UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *roleIv;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarIv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) User *user;


@end
