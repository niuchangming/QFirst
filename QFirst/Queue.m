//
//  Queue.m
//  QFirst
//
//  Created by ChangmingNiu on 23/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "Queue.h"
#import "Utils.h"

@implementation Queue

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.number = [[dic valueForKey:@"number"] intValue];
        self.isApp = [NSNumber numberWithBool:[dic valueForKey:@"isApp"]];
        self.isValid = [NSNumber numberWithBool:[dic valueForKey:@"isValid"]];
        self.clinic = [[Clinic alloc] initWithJson:[dic valueForKey:@"clinic"]];
    }
    
    return self;
}

@end
