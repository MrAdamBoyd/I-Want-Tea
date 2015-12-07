//
//  CurrentUser.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "CurrentUser.h"

#define kFirstTimeOpeningAppKey @"kFirstTimeOpeningAppKey"

@implementation CurrentUser

@synthesize firstTimeOpeningApp;

- (id)init {
    if (self = [super init]) {
        firstTimeOpeningApp = YES;
    }
    
    return self;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    //We saved the bool as an NSNumber because BOOL types are not savable with an NSCoder
    NSNumber *firstTimeOpeningAppNumber = [aDecoder decodeObjectForKey:kFirstTimeOpeningAppKey];
    firstTimeOpeningApp = firstTimeOpeningAppNumber.boolValue;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //First, convert the bool to an NSNumber
    NSNumber *firstTimeOpeningAppNumber = [[NSNumber alloc] initWithBool:firstTimeOpeningApp];
    [aCoder encodeObject:firstTimeOpeningAppNumber forKey:kFirstTimeOpeningAppKey];
}

@end
