//
//  TimeCell.h
//  FirstQ
//
//  Created by ChangmingNiu on 21/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *tagIv;
@property (weak, nonatomic) IBOutlet UILabel *tagNameLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightContraint;

@property (nonatomic) BOOL showDetails;

@end
