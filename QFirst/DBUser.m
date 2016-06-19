//
//  DBUser.m
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "DBUser.h"
#import "DBClinic.h"
#import "DBImage.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation DBUser

@synthesize accessToken;

-(id) initWithJson:(NSDictionary*) dic{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBUser" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:[appDelegate managedObjectContext]];
    
    if(self){
        self.entityId = [NSNumber numberWithInt:[[dic valueForKey:@"entityId"] intValue]];
        self.name = [Utils IsEmpty:[dic valueForKey:@"name"]] ? @"" : [dic valueForKey:@"name"];
        self.email = [Utils IsEmpty:[dic valueForKey:@"email"]] ? @"" : [dic valueForKey:@"email"];
        self.mobile = [dic valueForKey:@"mobile"];
        self.ic = [Utils IsEmpty:[dic valueForKey:@"ic"]] ? @"" : [dic valueForKey:@"ic"];
        self.accessToken = [dic valueForKey:@"accessToken"];
        self.role = [dic valueForKey:@"role"];
        self.isActive = [NSNumber numberWithBool:[dic valueForKey:@"isActive"]];
        
        NSArray *imageArray = [dic valueForKey:@"images"];
        if(![Utils IsEmpty:imageArray] && imageArray.count > 0){
            self.image = [[DBImage alloc] initWithJson:[imageArray objectAtIndex:0]];
        }
        
        //        NSArray *patientArray = [dic valueForKey:@"patientReservations"];
        //        self.patientReservations = [[NSSet alloc] init];
        //        if(![Utils IsEmpty:patientArray] && patientArray.count > 0){
        //            for(NSDictionary *patientReservation in patientArray) {
        //                [self.patientReservations setByAddingObject:[[Reservation alloc] initWithJson:patientReservation]];
        //            }
        //        }
        //
        //        NSArray *doctorArray = [dic valueForKey:@"doctorReservations"];
        //        self.doctorReservations = [[NSSet alloc] init];
        //        if(![Utils IsEmpty:doctorArray] && doctorArray.count > 0){
        //            for(NSDictionary *doctorReservation in doctorArray) {
        //                [self.doctorReservations setByAddingObject:[[Reservation alloc] initWithJson:doctorReservation]];
        //            }
        //        }
    }
    
    return self;
}

@end
