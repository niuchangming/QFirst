//
//  ExpiredQueueViewController.h
//  QFirst
//
//  Created by ChangmingNiu on 24/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ConstantValues.h"
#import "Image.h"
#import "Clinic.h"
#import "Queue.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UsedQueueViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *usedQueues;
@property (weak, nonatomic) IBOutlet UITableView *usedQueueTV;

@end
