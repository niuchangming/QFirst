//
//  TimeLine.h
//  QFirst
//
//  Created by ChangmingNiu on 13/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLine : NSObject

@property (strong, nonatomic) NSString *tagIvPath;
@property (strong, nonatomic) NSString *tagName;
@property (strong, nonatomic) NSString *subTagName;
@property (strong, nonatomic) NSMutableArray *times;

@end
