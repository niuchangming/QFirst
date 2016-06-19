//
//  LocationService.h
//  QFirst
//
//  Created by ChangmingNiu on 12/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationServiceDelegate <NSObject>

@optional
-(void) locationUpdated:(CLLocation*) location;

@end

@interface LocationService : NSObject <CLLocationManagerDelegate>

+(LocationService *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) id<LocationServiceDelegate> delegate;

- (void)startUpdatingLocation;

@end
