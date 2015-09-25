//
//  IWCDataController.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentUser.h"
@import CoreLocation;

@protocol IWCLocationListenerDelegate <NSObject>

- (void)updatedLocation:(CLLocation *)newLocation;

@end


@interface IWCDataController : NSObject <CLLocationManagerDelegate> {
    CurrentUser *currentUser;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) CurrentUser *currentUser;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLLocation *savedLocation;
@property (assign) id<IWCLocationListenerDelegate> locationDelegate;

+ (id)sharedController;

- (BOOL)getUserFirstTimeOpeningApp;
- (void)setUserFirstTimeOpeningApp:(BOOL) firstTime;

@end