//
//  Clinic.h
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import <CoreData/CoreData.h>

@interface Clinic : NSManagedObject

@property int entityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) Image *logo;
@property BOOL isCoop;

@property (nonatomic, strong) NSMutableArray *doctors;

-(id) initWithJson:(NSDictionary*) dic;

-(Clinic *) createDBClinicByOriginal;

-(Clinic *) retrieve;

-(void) delele;

@end

