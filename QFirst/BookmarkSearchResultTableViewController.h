//
//  BookmarkSearchResultTableViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 7/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBClinic.h"

@interface BookmarkSearchResultTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<DBClinic*> *clinicResults;

@end
