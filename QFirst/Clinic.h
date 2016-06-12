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

NS_ASSUME_NONNULL_BEGIN

@interface Clinic : NSManagedObject

@property int entityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) Image *logo;
@property int queue;
@property BOOL isCoop;
@property BOOL isBookmark;

@property (nonatomic, strong) NSMutableArray *doctors;

-(id) initWithJson:(NSDictionary*) dic;
-(Clinic *) save;
-(Clinic *) retrieve;
-(void) update;
-(void) delele;

@end

NS_ASSUME_NONNULL_END

#import "Clinic+CoreDataProperties.h"
