//
//  LocationService.h
//  QFirst
//
//  Created by ChangmingNiu on 12/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject <CLLocationManagerDelegate>

+(LocationService *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

- (void)startUpdatingLocation;

@end
