//
//  ExpiredQueueViewController.m
//  QFirst
//
//  Created by ChangmingNiu on 24/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "UsedQueueViewController.h"

@interface UsedQueueViewController ()

@end

@implementation UsedQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.usedQueueTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.usedQueueTV setLayoutMargins:UIEdgeInsetsZero];
    }
    self.usedQueueTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usedQueues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Queue *queue = [self.usedQueues objectAtIndex:indexPath.row];
    
    UIImageView *logoIv = (UIImageView *)[cell viewWithTag:1];
    if([[queue.clinic images] count] > 0){
        [logoIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ClinicController/showClinicThumbnailLogo?id=%d", baseUrl, [[queue.clinic.images objectAtIndex:0] entityId]]]];
    }else{
        [logoIv setImage:[UIImage imageNamed:@"default_avatar"]];
    }
    
    logoIv.layer.cornerRadius = logoIv.frame.size.width / 2;
    logoIv.clipsToBounds = YES;
    logoIv.layer.masksToBounds = YES;
    
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    nameLbl.text = queue.clinic.name;
    
    UILabel *numberLbl = (UILabel *)[cell viewWithTag:3];
    if(queue.number < 9){
        numberLbl.text = [NSString stringWithFormat:@"%s0%i", queue.isApp ? "A" : "M", queue.number];
    }else{
        numberLbl.text = [NSString stringWithFormat:@"%s%i", queue.isApp ? "A" : "M", queue.number];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
