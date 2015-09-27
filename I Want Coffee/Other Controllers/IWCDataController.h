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
#import "AFNetworking.h"
#import "FoursquareResponseParser.h"

@protocol IWCLocationListenerDelegate <NSObject>

- (void)userAuthorizedLocationUse;
- (void)userDeniedLocationUse;
- (void)addShopsToScreen:(NSArray<IWCShop *> *)shops;
- (void)showLoadingHUD;
- (void)hideLoadingHUD;

@end


@interface IWCDataController : NSObject <CLLocationManagerDelegate> {
    CurrentUser *currentUser;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) CurrentUser *currentUser;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLLocation *savedLocation;
@property (assign) id<IWCLocationListenerDelegate> iwcDelegate;

+ (id)sharedController;

- (BOOL)getUserFirstTimeOpeningApp;
- (void)setUserFirstTimeOpeningApp:(BOOL) firstTime;
- (void)searchForNearbyCoffee:(CLLocationCoordinate2D) coordinateToSearch;

@end