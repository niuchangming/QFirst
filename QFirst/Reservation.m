//
//  Reservation.m
//  QFirst
//
//  Created by ChangmingNiu on 13/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "Reservation.h"
#import "Utils.h"
#import "AppDelegate.h"

@implementation Reservation

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.isValid = [NSNumber numberWithBool:[dic valueForKey:@"isValid"]];
        self.reservationDatetime = [NSDate dateWithTimeIntervalSince1970:([[dic valueForKey:@"reservationDatetime"] longLongValue] / 1000.0)];
        
        self.doctor = [[User alloc] initWithJson:[dic valueForKey:@"doctor"]];
        self.patient = [[User alloc] initWithJson:[dic valueForKey:@"patient"]];
    }
    
    return self;
}

@end
