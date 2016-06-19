//
//  DBImage.m
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "DBImage.h"
#import "DBClinic.h"
#import "DBUser.h"
#import "AppDelegate.h"

@implementation DBImage

-(id) initWithJson:(NSDictionary*) dic{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBImage" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:[appDelegate managedObjectContext]];
    
    if(self){
        self.entityId = [NSNumber numberWithInt:[[dic valueForKey:@"entityId"] intValue]];
    }
    
    return self;
}


@end
