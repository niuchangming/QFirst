//
//  DBImage.h
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBClinic, DBUser;

NS_ASSUME_NONNULL_BEGIN

@interface DBImage : NSManagedObject

-(id) initWithJson:(NSDictionary*) dic;

@end

NS_ASSUME_NONNULL_END

#import "DBImage+CoreDataProperties.h"
