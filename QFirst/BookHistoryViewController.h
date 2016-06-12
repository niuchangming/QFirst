//
//  BookHistoryViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 9/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookHistoryViewController : UITableViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *reservations;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end
