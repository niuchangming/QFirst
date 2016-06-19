//
//  DBUser.h
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBClinic, DBImage;

NS_ASSUME_NONNULL_BEGIN

@interface DBUser : NSManagedObject

@property (nonatomic, strong) NSString *accessToken;

-(id) initWithJson:(NSDictionary*) dic;

@end

NS_ASSUME_NONNULL_END

#import "DBUser+CoreDataProperties.h"
