//
//  User.h
//  FirstQ
//
//  Created by ChangmingNiu on 28/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import <CoreData/CoreData.h>

@interface User : NSObject

@property int entityId;
@property (nonatomic, strong) Image *avatar;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* ic;
@property bool isActive;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSMutableArray *patientReservations;
@property (nonatomic, strong) NSMutableArray *doctorReservations;

-(id) initWithJson:(NSDictionary*) dic;

@end
