//
//  BookHistoryViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 9/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "BookHistoryViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "ConstantValues.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "Reservation.h"
#import "HZSigmentScrollView.h"
#import "MozTopAlertView.h"
#import "DBUser.h"
#import "CurrentBookHistoryViewController.h"
#import "ExpiredBookHistoryViewController.h"

@interface BookHistoryViewController ()

@property (nonatomic, strong) HZSigmentScrollView * SingmentScrollView;
@property (nonatomic, strong) CurrentBookHistoryViewController * currentVC;
@property (nonatomic, strong) ExpiredBookHistoryViewController * expiredVC;

@end

@implementation BookHistoryViewController

@synthesize reservations;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.currentVC = (CurrentBookHistoryViewController *)[sb instantiateViewControllerWithIdentifier:@"current_book_history_vc"];
    self.expiredVC = (ExpiredBookHistoryViewController *)[sb instantiateViewControllerWithIdentifier:@"expired_book_history_vc"];
    
    self.SingmentScrollView = [[HZSigmentScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.SingmentScrollView.sigmentView.bottomLineColor = [Utils colorFromHexString:@"#19B0EC"];
    self.SingmentScrollView.sigmentView.titleColorNormal = [Utils colorFromHexString:@"#4A4A4A"];
    self.SingmentScrollView.sigmentView.titleColorSelect = [Utils colorFromHexString:@"#19B0EC"];
    self.SingmentScrollView.sigmentView.titleLineColor = [Utils colorFromHexString:@"#19B0EC"];
    self.SingmentScrollView.titleScrollArrys = @[@"Current",@"Expired"].mutableCopy;
    self.SingmentScrollView.titleControllerArrys = @[self.currentVC,self.expiredVC].mutableCopy;
    [self.view addSubview:self.SingmentScrollView];
    
    [self loadReservations];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) loadReservations{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    [HUD showInView:self.navigationController.view];
    
    NSString *url = [NSString stringWithFormat:@"%@ClinicController/getReservationsByUser", baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [Utils accessToken] forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            reservations = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Reservation *reservation = [[Reservation alloc]initWithJson:data];
                [reservations addObject:reservation];
            }
            [self setupViewControllers:reservations];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [HUD dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [HUD dismissAnimated:YES];
    }];
}

-(void) setupViewControllers: (NSMutableArray *) reservs{
    NSMutableArray *currentReservations = [[NSMutableArray alloc] init];
    NSMutableArray *expiredReservations = [[NSMutableArray alloc] init];
    
    for(Reservation *reservation in reservs){
        if([self date:reservation.reservationDatetime isBefore:[NSDate date]]){
            [expiredReservations addObject:reservation];
        }else{
            [currentReservations addObject:reservation];
        }
    }
    
    self.currentVC.currentReservations = currentReservations;
    self.expiredVC.expiredReservatons = expiredReservations;
    
    [self.currentVC.currentBookTV reloadData];
    [self.expiredVC.expiredBookTV reloadData];
}

- (BOOL)date:(NSDate *)dateA isBefore:(NSDate *)dateB{
    if([dateA compare:dateB] == NSOrderedAscending){
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
