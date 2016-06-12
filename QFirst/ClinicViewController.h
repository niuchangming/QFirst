//
//  FirstViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClinicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *clinicTV;

@property (strong, nonatomic) NSMutableArray *clinicArray;
@property (strong, nonatomic) NSMutableArray *searchResults;

- (IBAction)qrcodeBtClicked:(id)sender;

@end

