//
//  IWCNetworkController.m
//  I Want Tea
//
//  Created by Adam Boyd on 17/4/25.
//  Copyright © 2017 Adam Boyd. All rights reserved.
//

#import "IWCNetworkRequestHandler.h"

@implementation IWCNetworkRequestHandler

#define kFSClientID @"OS1VJWS2NDEVGRGZFR2ZPSCHFHH1XKC1LGVUZRTICRL2KZ2O"
#define kFSClientSecret @"TRYE2KREOYL0IKHANOXDTLGFI2KN0CRL54WG2KRBUINOIPTO"
#define kFSVersion @"20130815"

@synthesize searchingCoordinate, searchMode;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andSearchMode:(SearchMode)mode {
    if (self = [super init]) {
        self.searchingCoordinate = coordinate;
        self.searchMode = mode;
    }
    
    return self;
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
    
    NSString *searchModeString = self.searchMode == SearchModeCoffee ? @"coffee" : @"tea";
    [parameters setValue:searchModeString forKey:@"query"];
    
    return parameters;
}

//Makes a search request on the Foursquare API. If the request is successful, it will add the pins to the MKMapView on the ViewController.
- (void)startSearchWithDelegate:(__weak id<IWCNetworkRequestDelegate>)delegate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = [self buildParameters:self.searchingCoordinate];
    
    //Tell VC to show HUD
    if (delegate) {
        [delegate showLoadingHUD];
    }
    
    
    [manager GET:@"https://api.foursquare.com/v2/venues/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *apiResponse = (NSDictionary *)responseObject;
        
        FoursquareResponseParser *parser = [[FoursquareResponseParser alloc] init];
        NSArray *shops = [parser parseAPIResponse:apiResponse];
        
        //Add the shops to the screen of the delegate (the view controller)
        if (delegate) {
            [delegate addShopsToScreen:shops];
            [delegate hideLoadingHUD];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
