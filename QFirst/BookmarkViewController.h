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
#import "DBClinic.h"

@interface BookmarkViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bookmarkClinicTB;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<DBClinic *> *bookmarkClinics;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

