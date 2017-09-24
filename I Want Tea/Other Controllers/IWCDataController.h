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
#import "FoursquareResponseParser.h"
#import "IWCNetworkRequestHandler.h"

@protocol IWCLocationListenerDelegate <NSObject, IWCNetworkRequestDelegate>

- (void)userAuthorizedLocationUse;
- (void)userDeniedLocationUse;

@end


@interface IWCDataController : NSObject <CLLocationManagerDelegate> {
    CurrentUser *currentUser;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) CurrentUser *currentUser;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *savedLocation;
@property (nonatomic, weak) id<IWCLocationListenerDelegate> iwcDelegate;
@property (nonatomic) SearchMode searchMode;

+ (instancetype)sharedController;

- (BOOL)getUserFirstTimeOpeningApp;
- (void)setUserFirstTimeOpeningApp:(BOOL) firstTime;

@end
