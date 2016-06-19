//
//  DBUser+CoreDataProperties.h
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *entityId;
@property (nullable, nonatomic, retain) NSString *ic;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *role;
@property (nullable, nonatomic, retain) DBClinic *clinic;
@property (nullable, nonatomic, retain) DBImage *image;

@end

NS_ASSUME_NONNULL_END
