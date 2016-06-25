//
//  FirstViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "ClinicViewController.h"
#import "DBClinic.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "DBImage.h"
#import <QuartzCore/QuartzCore.h>
#import "ClinicDetailViewController.h"
#import "DBUser.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "ConstantValues.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClinicSearchResultTableViewController.h"
#import "LocationService.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ClinicViewController (){
    NSIndexPath *indexPathForSelectedRow;
    UIBarButtonItem *rightButton;
    AppDelegate *appDelegate;
}

@end

@implementation ClinicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([self.clinicTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.clinicTV setLayoutMargins:UIEdgeInsetsZero];
    }
    self.clinicTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initSearchBarController];
    
    [self loadClinics];
    
    LocationService *locationService = [LocationService sharedInstance];
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [locationService.locationManager requestWhenInUseAuthorization];
    }
#endif
    locationService.delegate = self;
    [locationService startUpdatingLocation];
    
    [self storeLastUpdateInfo];
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
    self.clinicArray = [DBClinic retrieveAll];
    if(![Utils connected]){
        [self.clinicTV reloadData];
    }else{
        [self loadClinicOnline];
    }
}

-(void) loadClinicOnline{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    [HUD showInView:self.navigationController.view];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    long long lastUpdateTime = [[userDefault objectForKey:@"last_update"] longLongValue];
    
    NSMutableDictionary *params = nil;
    if(lastUpdateTime != 0){
        params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithLongLong:lastUpdateTime] forKey: @"lastSyncDatetime"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@ClinicController/clinics", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            for(NSDictionary *data in array){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entityId = %@", [data valueForKey:@"entityId"]];
                NSMutableArray *oldClinics = [DBClinic retrieveBy:predicate];
                
                DBClinic *newClinic = [[DBClinic alloc]initWithJson:data];
                
                if(oldClinics != nil){
                    for(DBClinic *oldClinic in oldClinics) {
                        newClinic.isBookmark = oldClinic.isBookmark;
                        [self.clinicArray removeObject:oldClinic];
                        
                        NSManagedObjectContext *context = [appDelegate managedObjectContext];
                        [context deleteObject:oldClinic];
                    }
                }
                [self.clinicArray addObject:newClinic];
            }
            
            [appDelegate saveContext];
            [self storeLastUpdateInfo];
            
            self.searchResults = [NSMutableArray arrayWithCapacity:[self.clinicArray count]];
            [self.clinicTV reloadData];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        
        [HUD dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [HUD dismissAnimated:YES];
    }];
}

-(void) storeLastUpdateInfo{
    NSTimeInterval lastUpdate = [[NSDate date] timeIntervalSince1970] * 1000;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithLongLong:lastUpdate] forKey:@"last_update"];
    [defaults synchronize];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clinicArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *clinicLogoIv = (UIImageView *)[cell viewWithTag:1];
    
    if([[[self.clinicArray objectAtIndex:indexPath.row] images] count] > 0){
        [clinicLogoIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%@", baseUrl, [[[[[self.clinicArray objectAtIndex:indexPath.row] images] allObjects] objectAtIndex:0] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }else{
        [clinicLogoIv setImage:[UIImage imageNamed:@"default_avatar"]];
    }
    
    clinicLogoIv.layer.cornerRadius = clinicLogoIv.frame.size.width / 2;
    clinicLogoIv.clipsToBounds = YES;
    clinicLogoIv.layer.masksToBounds = YES;
    
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    nameLbl.text = [[self.clinicArray objectAtIndex:indexPath.row] name];
    
    UILabel *distanceLbl = (UILabel *)[cell viewWithTag:3];
    distanceLbl.text = [NSString stringWithFormat:@"%.1fkm", [self.clinicArray objectAtIndex:indexPath.row].distance / 1000];
    
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
        clinicDetailVC.clinic = [self.clinicArray objectAtIndex:indexPath.row];
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

    for (DBClinic *clinic in self.clinicArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange nameRange = NSMakeRange(0, clinic.name.length);
        NSRange foundRange = [clinic.name rangeOfString:name options:searchOptions range:nameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:clinic];
        }
    }
}

-(void) locationUpdated:(CLLocation *)location{
    if(self.location == nil){
        self.location = location;
        [self updateClinicDistances];
    }
}

-(void) updateClinicDistances{
    for (DBClinic *clinic in self.clinicArray) {
        CLLocation *clinicLocation = [[CLLocation alloc] initWithLatitude:[[clinic latitude] doubleValue] longitude:[[clinic longitude] doubleValue]];
        CLLocationDistance distance = [self.location distanceFromLocation:clinicLocation];
        clinic.distance = distance;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.clinicArray sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.clinicArray removeAllObjects];
    [self.clinicArray addObjectsFromArray:sortedArray];
    
    [self.clinicTV reloadData];
}

@end









