//
//  Clinic.m
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "Clinic.h"
#import "User.h"
#import "AppDelegate.h"

@implementation Clinic

@synthesize entityId;
@synthesize name;
@synthesize address;
@synthesize latitude;
@synthesize longitude;
@synthesize contact;
@synthesize desc;
@synthesize logo;
@synthesize isCoop;
@synthesize doctors;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.name = [dic valueForKey:@"name"];
        self.address = [dic valueForKey:@"address"];
        self.desc = [dic valueForKey:@"description"];
        self.isCoop = [[dic valueForKey:@"isCooperated"] boolValue];
        self.latitude = [dic valueForKey:@"latitude"];
        self.longitude = [dic valueForKey:@"longtitude"];
        
        NSArray *imageArray = [dic valueForKey:@"images"];
        if(![imageArray isKindOfClass:[NSNull class]] && imageArray.count > 0){
            self.logo = [[Image alloc] initWithJson:[imageArray objectAtIndex:0]];
        }else{
            self.logo = [[Image alloc] init];
        }
        
        NSArray *doctorArray = [dic valueForKey:@"doctors"];
        self.doctors = [[NSMutableArray alloc] init];
        if(![doctorArray isKindOfClass:[NSNull class]] && doctorArray.count > 0){
            for(NSDictionary *doctorDic in doctorArray) {
                [self.doctors addObject: [[User alloc] initWithJson:doctorDic]];
            }
        }
    }
    
    return self;
}

-(Clinic *) createDBClinicByOriginal{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clinic" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    Clinic *dbClinic = [[Clinic alloc] initWithEntity:entity insertIntoManagedObjectContext:[appDelegate managedObjectContext]];
    
    NSError *error = nil;
    if (![[appDelegate managedObjectContext] save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    return dbClinic;
}

-(Clinic *) retrieve{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *tableEntity = [NSEntityDescription entityForName:@"Clinic" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"entityId == %i", self.entityId];
    [fetchRequest setPredicate:predicate];
    fetchRequest.returnsObjectsAsFaults = NO;
    [fetchRequest setEntity: tableEntity];
    
    NSError* error = nil;
    NSMutableArray* fetchArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    Clinic* clinicTbObj = nil;
    if(fetchArray != nil && [fetchArray count] == 1) {
        clinicTbObj = [fetchArray objectAtIndex:0];
    }
    
    return clinicTbObj;
}

-(void) delele {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [context deleteObject:self];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
    }
}

@end



























