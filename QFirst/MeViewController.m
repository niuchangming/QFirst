//
//  MeViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 7/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "MeViewController.h"
#import "Utils.h"
#import "ConstantValues.h"
#import "Reservation.h"
#import "User.h"
#import "MozTopAlertView.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "DBImage.h"

@interface MeViewController (){
    UILabel *mobileLbl;
    UILabel *emailLbl;
    UILabel *icLbl;
    UILabel *bookLbl;
    UILabel *queueLbl;
}

@end

@implementation MeViewController

@synthesize signBtn;
@synthesize bgImageView;
@synthesize blurBgView;
@synthesize nameLbl;
@synthesize roleIv;
@synthesize userAvatarIv;
@synthesize scrollView;
@synthesize container;
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    blurBgView.blurRadius = 30;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    signBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, self.view.frame.size.width, 44)];
    [signBtn setBackgroundColor:[Utils colorFromHexString:@"FF4444"]];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(signBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:signBtn];
    
    [self setupViews];
    [self getUserInfo];
}

-(void) viewWillAppear:(BOOL)animated{
    [self resetSignBtn];
}

-(void) setupViews{
    userAvatarIv.layer.cornerRadius = 52;
    userAvatarIv.layer.masksToBounds = YES;
    userAvatarIv.layer.borderWidth = 2.0f;
    userAvatarIv.layer.borderColor = [UIColor whiteColor].CGColor;
    [userAvatarIv setUserInteractionEnabled:YES];
    
    [userAvatarIv setImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    [bgImageView setImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    
    CGRect mobileFrame = CGRectMake(0, blurBgView.frame.origin.y + blurBgView.frame.size.height + 8, self.view.frame.size.width, 40);
    UIView *mobileView = [self getRowViewWithKey:@"Mobile" AndValue:@"" AndFrame: mobileFrame];
    mobileLbl = (UILabel *) [mobileView viewWithTag:1];
    
    CGRect emailFrame = CGRectMake(0, mobileFrame.origin.y + mobileFrame.size.height + 8, self.view.frame.size.width, 40);
    UIView *emailView = [self getRowViewWithKey:@"Email" AndValue:@"" AndFrame:emailFrame];
    emailLbl = (UILabel*)[emailView viewWithTag:1];
    
    CGRect icFrame = CGRectMake(0, emailFrame.origin.y + emailFrame.size.height + 8, self.view.frame.size.width, 40);
    UIView *icView = [self getRowViewWithKey:@"IC" AndValue:@"" AndFrame:icFrame];
    icLbl = (UILabel*)[icView viewWithTag:1];
    
    CGRect bookFrame = CGRectMake(0, icFrame.origin.y + icFrame.size.height + 8, self.view.frame.size.width, 40);
    UIView *bookView = [self getRowViewWithKey:@"Book History" AndValue:@"" AndFrame:bookFrame];
    UITapGestureRecognizer *bookTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookRowClicked)];
    bookTap.numberOfTapsRequired = 1;
    [bookView addGestureRecognizer:bookTap];
    bookLbl = (UILabel*)[bookView viewWithTag:1];
    
    CGRect queueFrame = CGRectMake(0, bookFrame.origin.y + bookFrame.size.height + 8, self.view.frame.size.width, 40);
    UIView *queueView = [self getRowViewWithKey:@"Queue History" AndValue:@"" AndFrame:queueFrame];
    queueLbl = (UILabel*)[queueView viewWithTag:1];
    
    signBtn.frame = CGRectMake(0, queueFrame.origin.y + queueFrame.size.height + 8, self.view.frame.size.width, 40);
}

-(UIView *) getRowViewWithKey: (NSString *) key AndValue:(NSString*) value AndFrame: (CGRect)frame{
    UIView *row = [[UIView alloc] initWithFrame:frame];
    [row setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *keyLbl = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 20)];
    keyLbl.text = key;
    [keyLbl setTag:0];
    keyLbl.textColor = [Utils colorFromHexString:@"#4A4A4A"];
    keyLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
    [row addSubview:keyLbl];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward.png"]];
    arrow.frame = CGRectMake(self.view.frame.size.width - 24, 12, 16, 16);
    [row addSubview:arrow];
    
    UILabel *valueLbl;
    if([key isEqualToString:@"Book History"] || [key isEqualToString:@"Queue History"]){
        valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(arrow.frame.origin.x - 24, 10, 20, 20)];
        [valueLbl setBackgroundColor:[Utils colorFromHexString:@"#FF5E3A"]];
        valueLbl.layer.cornerRadius = 10;
        valueLbl.layer.masksToBounds = YES;
        valueLbl.textColor = [UIColor whiteColor];
        valueLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        [valueLbl setHidden:YES];
        valueLbl.textAlignment = NSTextAlignmentCenter;
    }else{
        valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(116, 10, self.view.frame.size.width - 116 - 28, 20)];
        valueLbl.textColor = [Utils colorFromHexString:@"#4A4A4A"];
        valueLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
        valueLbl.textAlignment = NSTextAlignmentRight;
    }
    valueLbl.text = value;
    [valueLbl setTag:1];
    [row addSubview:valueLbl];
    
    [container addSubview:row];
    
    return row;
}

-(void) updateContentHeight{
    int contentHeight = MAX(signBtn.frame.origin.y + signBtn.frame.size.height, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
}

-(void) getUserInfo{
    if([Utils IsEmpty:[Utils accessToken]]) return;
    NSString *url = [NSString stringWithFormat:@"%@UserController/getUser", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [Utils accessToken] forKey: @"accessToken"];
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    [HUD showInView:self.navigationController.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            
            NSString *errMsg = [obj valueForKey:@"error"];
            if(![Utils IsEmpty:errMsg]) {
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                user = [[User alloc] initWithJson:obj];
                if(![Utils IsEmpty:user]){
                    [self setValueForViews];
                }else{
                    [MozTopAlertView showWithType:MozAlertTypeError text:@"Parsing failed." doText:nil doBlock:nil parentView:self.view];
                }
            }
        } else {
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Data type error." doText:nil doBlock:nil parentView:self.view];
        }
        [HUD dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [HUD dismissAnimated:YES];
    }];
}

-(void) setValueForViews{
    [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserController/showUserAvatarThumbnail?id=%d", baseUrl, [user.image entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [userAvatarIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserController/showUserAvatarThumbnail?id=%d", baseUrl, [user.image entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    nameLbl.attributedText = [[NSAttributedString alloc] initWithString:user.name attributes:underlineAttribute];
    
    if([user.role isEqualToString:@"NORMAL"]){
        [roleIv setImage:[UIImage imageNamed:@"user"]];
    }else if([user.role isEqualToString:@"DOCTOR"]){
        [roleIv setImage:[UIImage imageNamed:@"doctor"]];
    }else if([user.role isEqualToString:@"ADMIN"]){
        [roleIv setImage:[UIImage imageNamed:@"admin"]];
    }else if([user.role isEqualToString:@"CLINIC"]){
        [roleIv setImage:[UIImage imageNamed:@"clinic"]];
    }else{
        [roleIv setImage:[UIImage imageNamed:@"contact"]];
    }
    
    if(![Utils IsEmpty:user.email]){
        emailLbl.text = user.email;
    }
    
    if(![Utils IsEmpty:user.mobile]){
        mobileLbl.text = user.mobile;
    }
    
    if(![Utils IsEmpty:user.ic]){
        if([user.ic length] == 9) {
            NSString *modifiedStr = [user.ic substringToIndex:6];
            icLbl.text = [NSString stringWithFormat:@"%@%@", modifiedStr, @"***"];
        }else{
            icLbl.text = user.ic;
        }
    }
    
    if(user.patientReservations.count > 0){
        bookLbl.text = [NSString stringWithFormat:@"%lu", user.patientReservations.count];
        [bookLbl setHidden:NO];
    }else{
        [bookLbl setHidden:YES];
    }
    
    if(user.doctorReservations.count > 0){
        queueLbl.text = [NSString stringWithFormat:@"%lu", user.doctorReservations.count];
        [queueLbl setHidden:NO];
    }else{
        [queueLbl setHidden:YES];
    }
}

-(void) bookRowClicked{
    if ([Utils IsEmpty:[Utils accessToken]]) {
        [self login];
        return;
    }
    [self performSegueWithIdentifier:@"segue_book_me" sender:self];
}

-(void) login{
    [self performSegueWithIdentifier:@"segue_login_me" sender:nil];
}

-(void) logout{
    [self clearStore];
    
    nameLbl.text = @"";
    emailLbl.text = @"";
    mobileLbl.text = @"";
    icLbl.text = @"";
  
    if(bookLbl != nil){
        [bookLbl setHidden:YES];
    }
    
    if(icLbl != nil){
        [icLbl setHidden:YES];
    }
    
    [userAvatarIv setImage:[UIImage imageNamed:@"default_avatar"]];
    [bgImageView setImage:[UIImage imageNamed:@"default_avatar"]];
    
    [self login];
}

- (void)signBtnClicked:(id)sender {
    if([Utils IsEmpty:[Utils accessToken]]){
        [self login];
    }else{
        [self logout];
    }
}

-(void) clearStore{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) resetSignBtn{
    if ([Utils IsEmpty:[Utils accessToken]]) {
        [signBtn setBackgroundColor:[Utils colorFromHexString:@"#4CD964"]];
        [signBtn setTitle:@"Log in" forState:UIControlStateNormal];
    }else{
        [signBtn setBackgroundColor:[Utils colorFromHexString:@"#FF5E3A"]];
        [signBtn setTitle:@"Log out" forState:UIControlStateNormal];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue_login_me"]){
        LoginViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

-(void) loginComplete:(NSString *)err{
    if([Utils IsEmpty:err]){
        [self resetSignBtn];
        [self getUserInfo];
        
    }
}


@end
