//
//  Reservation.h
//  FirstQ
//
//  Created by ChangmingNiu on 8/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Reservation : NSObject

@property int entityId;
@property bool isValid;
@property (nonatomic, strong) NSDate *reservationDatetime;
@property (nonatomic, strong) User *doctor;
@property (nonatomic, strong) User *patient;

-(id) initWithJson:(NSDictionary*) dic;

@end
