//
//  Reservation.m
//  FirstQ
//
//  Created by ChangmingNiu on 8/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "Reservation.h"
#import "Utils.h"

@implementation Reservation

@synthesize entityId;
@synthesize isValid;
@synthesize reservationDatetime;
@synthesize doctor;
@synthesize patient;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.isValid = [[dic valueForKey:@"isValid"] boolValue];
    
        self.reservationDatetime = [NSDate dateWithTimeIntervalSince1970:([[dic valueForKey:@"reservationDatetime"] longLongValue] / 1000.0)];
        
        self.reservationDatetime = [Utils getLocalDateFrom:self.reservationDatetime];
        
        self.doctor = [[User alloc] initWithJson:[dic valueForKey:@"doctor"]];
        self.patient = [[User alloc] initWithJson:[dic valueForKey:@"patient"]];
    }
    
    return self;
}

@end
