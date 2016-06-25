//
//  CurrentBookHistoryViewController.m
//  QFirst
//
//  Created by ChangmingNiu on 22/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "CurrentBookHistoryViewController.h"
#import "Utils.h"
#import "ConstantValues.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CurrentBookHistoryViewController ()

@end

@implementation CurrentBookHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.currentBookTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.currentBookTV setLayoutMargins:UIEdgeInsetsZero];
    }
    self.currentBookTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentReservations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UIImageView *avatarIv = (UIImageView *)[cell viewWithTag:1];
    [avatarIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserController/showUserAvatarThumbnail?id=%d", baseUrl, [[[self.currentReservations objectAtIndex:indexPath.row] doctor] entityId]]]];

    avatarIv.layer.cornerRadius = avatarIv.frame.size.width / 2;
    avatarIv.clipsToBounds = YES;
    avatarIv.layer.masksToBounds = YES;

    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    nameLbl.text = [[[self.currentReservations objectAtIndex:indexPath.row] doctor] name];

    UILabel *distanceLbl = (UILabel *)[cell viewWithTag:3];
    distanceLbl.text = [Utils getReadableDateString:[[self.currentReservations objectAtIndex:indexPath.row] reservationDatetime]];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

@end
