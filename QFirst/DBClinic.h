//
//  DBClinic.h
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBImage, DBUser;

NS_ASSUME_NONNULL_BEGIN

@interface DBClinic : NSManagedObject

@property float distance;

-(id) initWithJson:(NSDictionary*) dic;

+(NSMutableArray<DBClinic*> *) retrieveBy:(NSPredicate *) predicate;
+(NSMutableArray<DBClinic*> *) retrieveAll;

-(void) delele;

@end

NS_ASSUME_NONNULL_END

#import "DBClinic+CoreDataProperties.h"
