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
- (NSArray <NSURLQueryItem *> *)buildParameters:(CLLocationCoordinate2D) coordinate {
    return @[[NSURLQueryItem queryItemWithName:@"client_id" value:kFSClientID],
             [NSURLQueryItem queryItemWithName:@"client_secret" value:kFSClientSecret],
             [NSURLQueryItem queryItemWithName:@"v" value:kFSVersion],
             [NSURLQueryItem queryItemWithName:@"ll" value:[self buildLocationString:coordinate]],
             [NSURLQueryItem queryItemWithName:@"query" value:self.searchMode == SearchModeCoffee ? @"coffee" : @"tea"]];
}

//Makes a search request on the Foursquare API. If the request is successful, it will add the pins to the MKMapView on the ViewController.
- (void)startSearchWithDelegate:(__weak id<IWCNetworkRequestDelegate>)delegate {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.foursquare.com/v2/venues/search"];
    
    [urlComponents setQueryItems:[self buildParameters:self.searchingCoordinate]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:urlComponents.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            //Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    //JSON parsing error
                    if (delegate) {
                        [delegate networkRequestEncounteredError:jsonError];
                    }
                    
                } else {
                    //JSON parsing worked
                    FoursquareResponseParser *parser = [[FoursquareResponseParser alloc] init];
                    NSArray *shops = [parser parseAPIResponse:jsonDictionary];
                    
                    if (delegate) {
                        [delegate addShopsToScreen:shops];
                    }
                    
                }
            } else {
                //Web server error
                if (delegate) {
                    [delegate networkRequestEncounteredError:nil];
                }
            }
        } else {
            //Other error
            if (delegate) {
                [delegate networkRequestEncounteredError:error];
            }
        }
    }] resume];
    
    [session finishTasksAndInvalidate];
}

@end
