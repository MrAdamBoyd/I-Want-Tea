//
//  FoursquareResponseParser.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWCShop.h"

@interface FoursquareResponseParser : NSObject

- (NSArray<IWCShop *> *)parseAPIResponse:(NSDictionary *)response;

@end
