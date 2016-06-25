//
//  DBClinic.m
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "DBClinic.h"
#import "DBImage.h"
#import "DBUser.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation DBClinic

@synthesize distance;

-(id) initWithJson:(NSDictionary*) dic{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBClinic" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:[appDelegate managedObjectContext]];
    
    if(self){
        self.entityId = [NSNumber numberWithInt:[[dic valueForKey:@"entityId"] intValue]];
        self.name = [dic valueForKey:@"name"];
        self.contact = [dic valueForKey:@"contact"];
        self.address = [dic valueForKey:@"address"];
        self.desc = [dic valueForKey:@"description"];
        self.isCoop = [dic valueForKey:@"isCooperated"];
        self.latitude = [dic valueForKey:@"latitude"];
        self.longitude = [dic valueForKey:@"longtitude"];
        self.isBookmark = @NO;
        
        NSArray *imageArray = [dic valueForKey:@"images"];
        self.images = [[NSSet alloc] init];
        if(![Utils IsEmpty:imageArray] && imageArray.count > 0){
            for(NSDictionary *imageDic in imageArray) {
                DBImage *dbImage = [[DBImage alloc] initWithJson:imageDic];
                [self addImagesObject:dbImage];
            }
        }
        
        NSArray *doctorArray = [dic valueForKey:@"doctors"];
        self.users = [[NSSet alloc] init];
        if(![Utils IsEmpty:doctorArray] && doctorArray.count > 0){
            for(NSDictionary *doctorDic in doctorArray) {
                [self addUsersObject:[[DBUser alloc] initWithJson:doctorDic]];
            }
        }
    }
    
    return self;
}

+(NSMutableArray<DBClinic*> *) retrieveBy:(NSPredicate *) predicate{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *tableEntity = [NSEntityDescription entityForName:@"DBClinic" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:predicate];
    fetchRequest.returnsObjectsAsFaults = NO;
    [fetchRequest setEntity: tableEntity];
    
    NSError* error = nil;
    NSMutableArray<DBClinic*>* fetchArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchArray;
}

+(NSMutableArray<DBClinic*> *) retrieveAll{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *tableEntity = [NSEntityDescription entityForName:@"DBClinic" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.returnsObjectsAsFaults = NO;
    [fetchRequest setEntity: tableEntity];
    
    NSError* error = nil;
    NSMutableArray* fetchArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchArray;
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
