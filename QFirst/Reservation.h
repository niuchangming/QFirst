//
//  Reservation.h
//  QFirst
//
//  Created by ChangmingNiu on 13/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@interface Reservation : NSObject

@property (nonatomic, strong) NSDate *reservationDatetime;
@property int entityId;
@property bool isValid;
@property (nonatomic, strong) User *doctor;
@property (nonatomic, strong) User *patient;

-(id) initWithJson:(NSDictionary*) dic;

@end

