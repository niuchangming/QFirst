//
//  ExpiredBookHistoryViewController.h
//  QFirst
//
//  Created by ChangmingNiu on 22/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reservation.h"

@interface ExpiredBookHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *expiredBookTV;

@property (strong, nonatomic) NSMutableArray *expiredReservatons;

@end
