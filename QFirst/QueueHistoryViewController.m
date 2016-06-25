//
//  QueueViewController.m
//  QFirst
//
//  Created by ChangmingNiu on 24/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "QueueHistoryViewController.h"
#import "CurrentQueueViewController.h"
#import "UsedQueueViewController.h"
#import "HZSigmentScrollView.h"
#import "Utils.h"
#import "Queue.h"
#import "Clinic.h"

@interface QueueHistoryViewController ()

@property (nonatomic, strong) HZSigmentScrollView * SingmentScrollView;
@property (nonatomic, strong) CurrentQueueViewController * currentVC;
@property (nonatomic, strong) UsedQueueViewController * usedVC;

@end

@implementation QueueHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.currentVC = (CurrentQueueViewController *)[sb instantiateViewControllerWithIdentifier:@"current_queue_vc"];
    self.usedVC = (UsedQueueViewController *)[sb instantiateViewControllerWithIdentifier:@"expired_queue_vc"];
    
    self.SingmentScrollView = [[HZSigmentScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.SingmentScrollView.sigmentView.bottomLineColor = [Utils colorFromHexString:@"#19B0EC"];
    self.SingmentScrollView.sigmentView.titleColorNormal = [Utils colorFromHexString:@"#4A4A4A"];
    self.SingmentScrollView.sigmentView.titleColorSelect = [Utils colorFromHexString:@"#19B0EC"];
    self.SingmentScrollView.sigmentView.titleLineColor = [Utils colorFromHexString:@"#19B0EC"];
    self.SingmentScrollView.titleScrollArrys = @[@"Current",@"Used"].mutableCopy;
    self.SingmentScrollView.titleControllerArrys = @[self.currentVC,self.usedVC].mutableCopy;
    [self.view addSubview:self.SingmentScrollView];
    
    if(self.queues != nil && self.queues.count > 0){
        [self setupViewControllers];
    }
}

-(void) setupViewControllers{
    NSMutableArray *currentQueues = [[NSMutableArray alloc] init];
    NSMutableArray *usedQueues = [[NSMutableArray alloc] init];
    
    for(Queue *queue in self.queues){
        if(queue.isValid){
            [currentQueues addObject:queue];
        }else{
            [usedQueues addObject:queue];
        }
    }
    
    self.currentVC.currentQueues = currentQueues;
    self.usedVC.usedQueues = usedQueues;
    
    [self.currentVC.currentQueueTV reloadData];
    [self.usedVC.usedQueueTV reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
