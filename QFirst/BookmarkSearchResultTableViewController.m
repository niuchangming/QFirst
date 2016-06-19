//
//  BookmarkSearchResultTableViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 7/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "BookmarkSearchResultTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ConstantValues.h"
#import "DBClinic.h"
#import "ClinicDetailViewController.h"

@interface BookmarkSearchResultTableViewController ()

@end

@implementation BookmarkSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.clinicResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *clinicLogoIv = (UIImageView *)[cell viewWithTag:1];
    [clinicLogoIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%@", baseUrl, [[self.clinicResults objectAtIndex:indexPath.row] entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    clinicLogoIv.layer.cornerRadius = clinicLogoIv.frame.size.width / 2;
    clinicLogoIv.clipsToBounds = YES;
    clinicLogoIv.layer.masksToBounds = YES;
    
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    nameLbl.text = [[self.clinicResults objectAtIndex:indexPath.row] name];
    
    UILabel *distanceLbl = (UILabel *)[cell viewWithTag:3];
    distanceLbl.text = @"10km";
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBClinic *clinic = [self.clinicResults objectAtIndex:indexPath.row];
    ClinicDetailViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"ClinicDetailViewController"];
    vc.clinic = clinic;
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
