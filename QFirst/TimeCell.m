//
//  TimeCell.m
//  FirstQ
//
//  Created by ChangmingNiu on 21/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "TimeCell.h"

const float lowPriorityHeight = 250;
const float highPriorityHeight = 999;

@implementation TimeCell

@synthesize mainView;
@synthesize detailView;
@synthesize tagIv;
@synthesize tagNameLbl;
@synthesize detailViewHeightContraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailViewHeightContraint.constant = 0;
}

- (void)setShowDetails:(BOOL)showDetails{
    _showDetails = showDetails;
    if(showDetails){
        self.detailViewHeightContraint.constant = 159;
    }else{
        self.detailViewHeightContraint.constant = 0;
    }
    self.detailViewHeightContraint.priority = (showDetails) ? lowPriorityHeight : highPriorityHeight;
}

@end
