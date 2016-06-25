//
//  CurrentQueueViewController.h
//  QFirst
//
//  Created by ChangmingNiu on 24/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentQueueViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *currentQueues;
@property (weak, nonatomic) IBOutlet UITableView *currentQueueTV;

@end
