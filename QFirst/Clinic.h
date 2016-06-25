//
//  Clinic.h
//  QFirst
//
//  Created by ChangmingNiu on 23/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "User.h"

@interface Clinic : NSObject

@property int entityId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *desc;
@property bool isCoop;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSMutableArray<Image *> *images;
@property (strong, nonatomic) NSMutableArray<User *> *users;

-(id) initWithJson:(NSDictionary*) dic;

@end
