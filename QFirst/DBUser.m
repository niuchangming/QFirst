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
        self.mobile = [[dic valueForKey:@"mobile"] stringByReplacingOccurrencesOfString:@"+65" withString:@""];
        self.ic = [Utils IsEmpty:[dic valueForKey:@"ic"]] ? @"" : [dic valueForKey:@"ic"];
        self.accessToken = [dic valueForKey:@"accessToken"];
        self.role = [dic valueForKey:@"role"];
        self.isActive = [NSNumber numberWithBool:[dic valueForKey:@"isActive"]];
        
        NSArray *imageArray = [dic valueForKey:@"avatars"];
        if(![Utils IsEmpty:imageArray] && imageArray.count > 0){
            for(NSDictionary *imageDic in imageArray) {
                [self addImagesObject:[[DBImage alloc] initWithJson:imageDic]];
            }
        }
    }
    
    return self;
}

@end
