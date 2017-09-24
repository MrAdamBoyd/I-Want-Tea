//
//  IWCNetworkController.h
//  I Want Tea
//
//  Created by Adam Boyd on 17/4/25.
//  Copyright © 2017 Adam Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "FoursquareResponseParser.h"

//Search mode
typedef enum SearchMode {
    SearchModeCoffee,
    SearchModeTea
} SearchMode;

@protocol IWCNetworkRequestDelegate <NSObject>

- (void)addShopsToScreen:(NSArray<IWCShop *> *)shops;
- (void)networkRequestEncounteredError:(NSError *)error;

@end

@interface IWCNetworkRequestHandler : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D searchingCoordinate;
@property (nonatomic) SearchMode searchMode;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andSearchMode:(SearchMode)mode;
- (void)startSearchWithDelegate:(__weak id<IWCNetworkRequestDelegate>)delegate;

@end
