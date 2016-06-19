//
//  DBImage+CoreDataProperties.h
//  QFirst
//
//  Created by ChangmingNiu on 18/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *entityId;
@property (nullable, nonatomic, retain) DBClinic *clinic;
@property (nullable, nonatomic, retain) DBUser *user;

@end

NS_ASSUME_NONNULL_END
