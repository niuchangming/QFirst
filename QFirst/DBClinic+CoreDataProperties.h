//
//  DBClinic+CoreDataProperties.h
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBClinic.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBClinic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *contact;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *entityId;
@property (nullable, nonatomic, retain) NSNumber *isBookmark;
@property (nullable, nonatomic, retain) NSNumber *isCoop;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<DBImage *> *images;
@property (nullable, nonatomic, retain) NSSet<DBUser *> *users;

@end

@interface DBClinic (CoreDataGeneratedAccessors)

- (void)addUsersObject:(DBUser *)value;
- (void)removeUsersObject:(DBUser *)value;
- (void)addUsers:(NSSet<DBUser *> *)values;
- (void)removeUsers:(NSSet<DBUser *> *)values;

- (void)addImagesObject:(DBImage *)value;
- (void)removeImagesObject:(DBImage *)value;
- (void)addImages:(NSSet<DBImage *> *)values;
- (void)removeImages:(NSSet<DBImage *> *)values;

@end

NS_ASSUME_NONNULL_END
