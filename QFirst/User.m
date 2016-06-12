//
//  User.m
//  FirstQ
//
//  Created by ChangmingNiu on 28/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "User.h"
#import "Reservation.h"
#import "Utils.h"
#import "Clinic.h"

@implementation User

@synthesize entityId;
@synthesize avatar;
@synthesize email;
@synthesize mobile;
@synthesize ic;
@synthesize isActive;
@synthesize accessToken;
@synthesize role;
@synthesize name;
@synthesize patientReservations;
@synthesize doctorReservations;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.name = [dic valueForKey:@"name"];
        self.email = [dic valueForKey:@"email"];
        self.mobile = [dic valueForKey:@"mobile"];
        self.ic = [dic valueForKey:@"ic"];
        self.isActive = [[dic valueForKey:@"isActive"] boolValue];
        self.accessToken = [dic valueForKey:@"accessToken"];
        self.role = [dic valueForKey:@"role"];
        
        NSArray *imageArray = [dic valueForKey:@"avatars"];
        if(![imageArray isKindOfClass:[NSNull class]] && imageArray.count > 0){
            self.avatar = [[Image alloc] initWithJson:[imageArray objectAtIndex:0]];
        }else{
            self.avatar = [[Image alloc] init];
        }
        
        NSArray *patientReservationArray = [dic valueForKey:@"patientReservations"];
        self.patientReservations = [[NSMutableArray alloc] init];
        if(![Utils IsEmpty:patientReservationArray] && patientReservationArray.count > 0){
            for(NSDictionary *patientReservationDic in patientReservationArray) {
                [self.patientReservations addObject: [[Reservation alloc] initWithJson:patientReservationDic]];
            }
        }
        
        NSArray *doctorReservationArray = [dic valueForKey:@"doctorReservations"];
        self.doctorReservations = [[NSMutableArray alloc] init];
        if(![Utils IsEmpty:doctorReservationArray] && doctorReservationArray.count > 0){
            for(NSDictionary *doctorReservationDic in doctorReservationArray) {
                [self.doctorReservations addObject: [[Reservation alloc] initWithJson:doctorReservationDic]];
            }
        }

    }
    
    return self;
}

@end
