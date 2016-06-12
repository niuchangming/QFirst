//
//  SecondViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BookmarkViewController : UITableViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *bookmarkClinics;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

