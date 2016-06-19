//
//  SecondViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "BookmarkViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "ConstantValues.h"
#import "DBClinic.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BookmarkSearchResultTableViewController.h"
#import "ClinicDetailViewController.h"

@interface BookmarkViewController (){
    NSIndexPath *indexPathForSelectedRow;
}

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initSearchBarController];
}

-(void) viewDidAppear:(BOOL)animated{
    [self getBookmarks];
}

-(void) initSearchBarController{
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"BookmarkSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

-(void) getBookmarks{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmark = %@", [NSNumber numberWithBool:YES]];
    self.bookmarkClinics = [DBClinic retrieveBy:predicate];
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.bookmarkClinics count]];
    [self.tableView reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookmarkClinics.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *clinicLogoIv = (UIImageView *)[cell viewWithTag:1];
    [clinicLogoIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%@", baseUrl, [[self.bookmarkClinics objectAtIndex:indexPath.row] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    clinicLogoIv.layer.cornerRadius = clinicLogoIv.frame.size.width / 2;
    clinicLogoIv.clipsToBounds = YES;
    clinicLogoIv.layer.masksToBounds = YES;
    
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    nameLbl.text = [[self.bookmarkClinics objectAtIndex:indexPath.row] name];
    
    UILabel *distanceLbl = (UILabel *)[cell viewWithTag:3];
    distanceLbl.text = @"10km";
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self.bookmarkClinics objectAtIndex:indexPath.row] setIsBookmark:[NSNumber numberWithBool:FALSE]];
    [self.bookmarkClinics removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    indexPathForSelectedRow = indexPath;
    [self performSegueWithIdentifier:@"segue_clinicdetail_bookmark" sender:self];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"empty_bookmark"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"You have not add any clinic in your bookmark.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [Utils colorFromHexString:@"#C7C7CC"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    
    [self updateFilteredContentForClinic:searchString];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        BookmarkSearchResultTableViewController *vc = (BookmarkSearchResultTableViewController *)navController.topViewController;
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
    
    for (DBClinic *clinic in self.bookmarkClinics) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange nameRange = NSMakeRange(0, clinic.name.length);
        NSRange foundRange = [clinic.name rangeOfString:name options:searchOptions range:nameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:clinic];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_clinicdetail_bookmark"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ClinicDetailViewController *clinicDetailVC = segue.destinationViewController;
        clinicDetailVC.clinic = [self.bookmarkClinics objectAtIndex:indexPath.row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
