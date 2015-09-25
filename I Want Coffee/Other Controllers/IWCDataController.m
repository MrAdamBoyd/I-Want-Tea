//
//  IWCDataController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCDataController.h"

#define kCurrentUserKey @"kCurrentUserKey"


#define kFSVersion @"20130815"

@implementation IWCDataController

@synthesize currentUser;
@synthesize locationManager;
@synthesize iwcDelegate;
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
    [self updateLocation:[locations lastObject]];
}

# pragma mark Location methods
- (void)updateLocation:(CLLocation *)newLocation {
    //If we have (no location or the distance from the new location to the saved one is more than 20 meters) and the accuracy is less than 20 meters
    if ((!savedLocation || [savedLocation distanceFromLocation:newLocation] > 50) && newLocation.horizontalAccuracy < 50) {
        savedLocation = newLocation;
        
        
        [self searchForNearbyCoffee];
    }
}

//Building the lat, lon string for the parameters
-(NSString *)buildLocationString {
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", savedLocation.coordinate.latitude, savedLocation.coordinate.longitude];
    return locationString;
}

//Building the parameters for the search
- (NSDictionary *)buildParameters {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    //API information
    [parameters setValue:kFSClientID forKey:@"client_id"];
    [parameters setValue:kFSClientSecret forKey:@"client_secret"];
    [parameters setValue:kFSVersion forKey:@"v"];
    
    NSString *locationString = [self buildLocationString];
    [parameters setValue:locationString forKey:@"ll"];
    [parameters setValue:@"coffee" forKey:@"query"];
    
    return parameters;
}

- (void)searchForNearbyCoffee {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = [self buildParameters];
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *apiResponse = (NSDictionary *)responseObject;
        
        FoursquareResponseParser *parser = [[FoursquareResponseParser alloc] init];
        NSArray *shops = [parser parseAPIResponse:apiResponse];
        
        if (self.iwcDelegate) {
            [self.iwcDelegate addShopsToScreen:shops];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
