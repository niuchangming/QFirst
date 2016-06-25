//
//  Queue.h
//  QFirst
//
//  Created by ChangmingNiu on 23/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clinic.h"

@interface Queue : NSObject

@property int entityId;
@property bool isApp;
@property bool isValid;
@property int number;
@property (strong, nonatomic) NSDate *generateDateTime;
@property (strong, nonatomic) Clinic *clinic;

-(id) initWithJson:(NSDictionary*) dic;

@end
