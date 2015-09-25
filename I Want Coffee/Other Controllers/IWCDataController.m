//
//  IWCDataController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCDataController.h"

#define kCurrentUserKey @"kCurrentUserKey"

@implementation IWCDataController

@synthesize currentUser;
@synthesize locationManager;
@synthesize locationDelegate;
@synthesize savedLocation;

- (id)init {
    if (self == [super init]) {
        //Getting the current user
        NSData *unarchivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        CurrentUser *user;
        
        if (unarchivedObject) {
            user = (CurrentUser *)[NSKeyedUnarchiver unarchiveObjectWithData:unarchivedObject];
        } else {
            //User doesn't exist, create one
            user = [[CurrentUser alloc] init];
        }
        currentUser = user;
        
        [self saveCurrentUser];
        
        //Setting up the CLLocationManager
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    
    return self;
}

# pragma mark Singleton methods

+ (id)sharedController {
    static IWCDataController *sharedIWCDataController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIWCDataController = [[self alloc] init];
    });
    
    return sharedIWCDataController;
}

# pragma mark CurrentUser methods

- (void)saveCurrentUser {
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:kCurrentUserKey];
}

- (BOOL)getUserFirstTimeOpeningApp {
    return currentUser.firstTimeOpeningApp;
}

- (void)setUserFirstTimeOpeningApp:(BOOL) firstTime {
    currentUser.firstTimeOpeningApp = firstTime;
    [self saveCurrentUser];
}

# pragma mark locationDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.locationDelegate) {
        [locationDelegate updatedLocation:[locations lastObject]];
    }
}

@end
