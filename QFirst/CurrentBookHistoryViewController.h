//
//  CurrentBookHistoryViewController.h
//  QFirst
//
//  Created by ChangmingNiu on 22/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reservation.h"

@interface CurrentBookHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *currentBookTV;

@property (strong, nonatomic) NSMutableArray *currentReservations;

@end
