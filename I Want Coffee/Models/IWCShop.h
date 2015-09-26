//
//  IWCShop.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWCShop : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *unformattedPhone;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *twitter;

@property (nonatomic, strong) NSString *formattedAddress;
@property (nonatomic, strong) NSArray<NSString *> *addressArray;
@property (nonatomic, strong) NSString *urlReadyAddress;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;

@property (nonatomic, strong) NSString *menuURL;

@end
