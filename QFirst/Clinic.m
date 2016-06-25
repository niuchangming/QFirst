//
//  Clinic.m
//  QFirst
//
//  Created by ChangmingNiu on 23/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "Clinic.h"
#import "Utils.h"

@implementation Clinic

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.name = [dic valueForKey:@"name"];
        self.address = [dic valueForKey:@"address"];
        self.contact = [dic valueForKey:@"contact"];
        self.desc = [dic valueForKey:@"description"];
        self.latitude = [dic valueForKey:@"latitude"];
        self.longitude = [dic valueForKey:@"longitude"];
        self.isCoop = [NSNumber numberWithBool:[dic valueForKey:@"isCoop"]];
        
        NSArray *imageArray = [dic valueForKey:@"images"];
        self.images = [[NSMutableArray alloc] init];
        if(![Utils IsEmpty:imageArray] && imageArray.count > 0){
            for(NSDictionary *imageDic in imageArray) {
                Image *image = [[Image alloc] initWithJson:imageDic];
                [self.images addObject:image];
            }
        }
        
        NSArray *doctorArray = [dic valueForKey:@"doctors"];
        self.users = [[NSMutableArray alloc] init];
        if(![Utils IsEmpty:doctorArray] && doctorArray.count > 0){
            for(NSDictionary *doctorDic in doctorArray) {
                User *user = [[User alloc] initWithJson:doctorDic];
                [self.users addObject:user];
            }
        }
    }
    
    return self;
}


@end
