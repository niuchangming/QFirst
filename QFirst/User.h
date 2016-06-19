//
//  User.h
//  QFirst
//
//  Created by ChangmingNiu on 19/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *entityId;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *ic;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) Image *image;
@property (nonatomic, strong) NSMutableArray *patientReservations;
@property (nonatomic, strong) NSMutableArray *doctorReservations;

-(id) initWithJson:(NSDictionary*) dic;

@end
