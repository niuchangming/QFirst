//
//  User.m
//  QFirst
//
//  Created by ChangmingNiu on 19/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "User.h"
#import "Utils.h"

@implementation User

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [NSNumber numberWithInt:[[dic valueForKey:@"entityId"] intValue]];
        self.name = [dic valueForKey:@"name"];
        self.email = [dic valueForKey:@"email"];
        self.mobile = [dic valueForKey:@"mobile"];
        self.ic = [dic valueForKey:@"ic"];
        self.accessToken = [dic valueForKey:@"accessToken"];
        self.role = [dic valueForKey:@"role"];
        self.isActive = [NSNumber numberWithBool:[dic valueForKey:@"isActive"]];
        
        NSArray *imageArray = [dic valueForKey:@"images"];
        if(![Utils IsEmpty:imageArray] && imageArray.count > 0){
            self.image = [[Image alloc] initWithJson:[imageArray objectAtIndex:0]];
        }
        
        NSArray *patientArray = [dic valueForKey:@"patientReservations"];
        if(![Utils IsEmpty:patientArray] && patientArray.count > 0){
            self.patientReservations = [[NSMutableArray alloc] init];
            for(NSDictionary *patientDic in patientArray) {
                [self.patientReservations addObject:[[User alloc] initWithJson:patientDic]];
            }
        }
        
        NSArray *doctorArray = [dic valueForKey:@"doctorReservations"];
        if(![Utils IsEmpty:doctorArray] && doctorArray.count > 0){
            self.doctorReservations = [[NSMutableArray alloc] init];
            for(NSDictionary *doctorDic in doctorArray) {
                [self.doctorReservations addObject:[[User alloc] initWithJson:doctorDic]];
            }
        }
    }
    
    return self;
}

@end
