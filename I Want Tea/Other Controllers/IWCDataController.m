//
//  IWCDataController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCDataController.h"

#define kCurrentUserKey @"kCurrentUserKey"

#define kFSClientID @"OS1VJWS2NDEVGRGZFR2ZPSCHFHH1XKC1LGVUZRTICRL2KZ2O"
#define kFSClientSecret @"TRYE2KREOYL0IKHANOXDTLGFI2KN0CRL54WG2KRBUINOIPTO"
#define kFSVersion @"20130815"

@implementation IWCDataController

@synthesize currentUser;
@synthesize locationManager;
@synthesize iwcDelegate;
@synthesize savedLocation;
@synthesize mode;

- (id)init {
    if (self = [super init]) {
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

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (self.iwcDelegate) {
            [self.iwcDelegate userAuthorizedLocationUse];
        }
    } else if (status == kCLAuthorizationStatusDenied) {
        if (self.iwcDelegate) {
            [self.iwcDelegate userDeniedLocationUse];
        }
    }
}

# pragma mark Location methods
- (void)updateLocation:(CLLocation *)newLocation {
    //If we have (no location or the distance from the new location to the saved one is more than 50 meters) and the accuracy is less than 150 meters
    if ((!savedLocation || [savedLocation distanceFromLocation:newLocation] > 50) && newLocation.horizontalAccuracy < 75) {
        savedLocation = newLocation;
        
        [self searchForNearbyCoffeeOrTea:savedLocation.coordinate];
    }
}

//Building the lat, lon string for the parameters
-(NSString *)buildLocationString:(CLLocationCoordinate2D) coordinate {
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    return locationString;
}

//Building the parameters for the search
- (NSDictionary *)buildParameters:(CLLocationCoordinate2D) coordinate {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    //API information
    [parameters setValue:kFSClientID forKey:@"client_id"];
    [parameters setValue:kFSClientSecret forKey:@"client_secret"];
    [parameters setValue:kFSVersion forKey:@"v"];
    
    NSString *locationString = [self buildLocationString:coordinate];
    [parameters setValue:locationString forKey:@"ll"];
    
    NSString *searchModeString = mode == SearchModeCoffee ? @"coffee" : @"tea";
    [parameters setValue:searchModeString forKey:@"query"];
    
    return parameters;
}

//Makes a search request on the Foursquare API. If the request is successful, it will add the pins to the MKMapView on the ViewController.
- (void)searchForNearbyCoffeeOrTea:(CLLocationCoordinate2D) coordinateToSearch {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = [self buildParameters:coordinateToSearch];
    
    //Tell VC to show HUD
    if (self.iwcDelegate) {
        [self.iwcDelegate showLoadingHUD];
    }
    
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *apiResponse = (NSDictionary *)responseObject;
        
        FoursquareResponseParser *parser = [[FoursquareResponseParser alloc] init];
        NSArray *shops = [parser parseAPIResponse:apiResponse];
        
        //Add the shops to the screen of the delegate (the view controller)
        if (self.iwcDelegate) {
            [self.iwcDelegate addShopsToScreen:shops];
        }
        
        if (self.iwcDelegate) {
            [self.iwcDelegate hideLoadingHUD];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)setMode:(SearchMode)newMode shouldSearchAgain:(BOOL)yesOrNo withPoint:(CLLocationCoordinate2D)location {
    self.mode = newMode;
    
    //We should search again
    if (yesOrNo) {
        [self searchForNearbyCoffeeOrTea:location];
    }
}

@end