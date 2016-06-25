//
//  User.m
//  QFirst
//
//  Created by ChangmingNiu on 19/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "User.h"
#import "Utils.h"
#import "Queue.h"

@implementation User

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.name = [dic valueForKey:@"name"];
        self.email = [dic valueForKey:@"email"];
        self.mobile = [[dic valueForKey:@"mobile"] stringByReplacingOccurrencesOfString:@"+65" withString:@""];
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
        
        NSArray *queueArray = [dic valueForKey:@"queues"];
        if(![Utils IsEmpty:queueArray] && queueArray.count > 0){
            self.queues = [[NSMutableArray alloc] init];
            for(NSDictionary *queueDic in queueArray) {
                [self.queues addObject:[[Queue alloc] initWithJson:queueDic]];
            }
        }
    }
    
    return self;
}

@end
