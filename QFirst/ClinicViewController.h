//
//  FirstViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBClinic.h"
#import "LocationService.h"

@interface ClinicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, LocationServiceDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *clinicTV;

@property (nonatomic, strong) CLLocation * location;
@property (strong, nonatomic) NSMutableArray<DBClinic *> *clinicArray;
@property (strong, nonatomic) NSMutableArray *searchResults;

- (IBAction)qrcodeBtClicked:(id)sender;

@end

