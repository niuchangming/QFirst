//
//  FirstViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "ClinicViewController.h"
#import "Clinic.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "ClinicDetailViewController.h"
#import "User.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "ConstantValues.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClinicSearchResultTableViewController.h"

@interface ClinicViewController (){
    NSIndexPath *indexPathForSelectedRow;
    UIBarButtonItem *rightButton;
}

@end

@implementation ClinicViewController

@synthesize searchController;
@synthesize clinicTV;
@synthesize clinicArray;
@synthesize searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if ([clinicTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [clinicTV setLayoutMargins:UIEdgeInsetsZero];
    }
    clinicTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initSearchBarController];
    
    [self loadClinics];
}

-(void) initSearchBarController{
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ClinicSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.clinicTV.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

-(void) loadClinics{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    [HUD showInView:self.navigationController.view];
    
    NSString *url = [NSString stringWithFormat:@"%@ClinicController/clinics", baseUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            clinicArray = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Clinic *clinic = [[Clinic alloc]initWithJson:data];
                [clinicArray addObject:clinic];
            }
            self.searchResults = [NSMutableArray arrayWithCapacity:[clinicArray count]];
            [clinicTV reloadData];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [HUD dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [HUD dismissAnimated:YES];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return clinicArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *clinicLogoIv = (UIImageView *)[cell viewWithTag:1];
    [clinicLogoIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%i", baseUrl, [[[clinicArray objectAtIndex:indexPath.row] logo] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    clinicLogoIv.layer.cornerRadius = clinicLogoIv.frame.size.width / 2;
    clinicLogoIv.clipsToBounds = YES;
    clinicLogoIv.layer.masksToBounds = YES;
    
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    nameLbl.text = [[clinicArray objectAtIndex:indexPath.row] name];
    
    UILabel *distanceLbl = (UILabel *)[cell viewWithTag:3];
    distanceLbl.text = @"10km";
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_clinicdetail"]) {
        NSIndexPath *indexPath = [self.clinicTV indexPathForSelectedRow];
        ClinicDetailViewController *clinicDetailVC = segue.destinationViewController;
        clinicDetailVC.clinic = [clinicArray objectAtIndex:indexPath.row];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    indexPathForSelectedRow = indexPath;
    [self performSegueWithIdentifier:@"segue_clinicdetail" sender:self];
}

- (IBAction)qrcodeBtClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue_qrscan" sender:nil];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    
    [self updateFilteredContentForClinic:searchString];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        ClinicSearchResultTableViewController *vc = (ClinicSearchResultTableViewController *)navController.topViewController;
        vc.clinicResults = self.searchResults;
        [vc.tableView reloadData];
    }
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForClinic:(NSString *)name{
    if ([Utils IsEmpty:name]) {
        return;
    }
    
    [self.searchResults removeAllObjects];

    for (Clinic *clinic in clinicArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange nameRange = NSMakeRange(0, clinic.name.length);
        NSRange foundRange = [clinic.name rangeOfString:name options:searchOptions range:nameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:clinic];
        }
    }
}

@end









