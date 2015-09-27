//
//  FoursquareResponseParser.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "FoursquareResponseParser.h"

@implementation FoursquareResponseParser

- (NSArray<IWCShop *> *)parseAPIResponse:(NSDictionary *)response {
    NSMutableArray<IWCShop *> *arrayOfShops = [[NSMutableArray alloc] init];
    
    NSArray *venues = [[response objectForKey:@"response"] objectForKey:@"venues"];
    
    for (NSDictionary *venue in venues) {
        [arrayOfShops addObject:[self parseSingleStop:venue]];
    }
    
    
    return arrayOfShops;
}

//Creating a single IWCShop instance from the dictionary that contains information about the store
- (IWCShop *)parseSingleStop:(NSDictionary *)dictionary {
    IWCShop *shop = [[IWCShop alloc] init];
    
    shop.name = [dictionary objectForKey:@"name"];
    
    shop.ident = [dictionary objectForKey:@"id"];
    
    NSDictionary *contact = [dictionary objectForKey:@"contact"];
    shop.unformattedPhone = [contact objectForKey:@"phone"];
    shop.phoneNumber = [contact objectForKey:@"formattedPhone"];
    shop.twitter = [contact objectForKey:@"twitter"];
    
    NSDictionary *location = [dictionary objectForKey:@"location"];
    shop.addressArray = [location objectForKey:@"formattedAddress"];
    shop.formattedAddress = [self formatAddressFromArray:shop.addressArray];
    shop.lat = [location objectForKey:@"lat"];
    shop.lon = [location objectForKey:@"lng"];
    
    NSMutableArray *goingToFormatAddress = [[NSMutableArray alloc] init];
    
    if ([location objectForKey:@"address"]) {
        NSString *streetAddress = [location objectForKey:@"address"];
        [goingToFormatAddress addObject:streetAddress];
    }
    
    NSString *city = [location objectForKey:@"city"];
    NSString *state = [location objectForKey:@"state"];
    [goingToFormatAddress addObjectsFromArray:@[city, state]];
    
    NSString *urlReady = [goingToFormatAddress componentsJoinedByString:@","];
    urlReady = [urlReady stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    shop.urlReadyAddress = urlReady;
    
    if ([[dictionary objectForKey:@"hasMenu"] boolValue]) {
    
        NSDictionary *menu = [dictionary objectForKey:@"menu"];
        shop.menuURL = [menu objectForKey:@"url"];

    }
    return shop;
}

//Creating a single string of the address from the different lines of the address
- (NSString *)formatAddressFromArray:(NSArray *)addressArray {
    NSString *address = [addressArray componentsJoinedByString:@"\n"];
    
    return address;
}

@end
