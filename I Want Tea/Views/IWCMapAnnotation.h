//
//  IWCMapAnnotation.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IWCShop.h"

@interface IWCMapAnnotation : MKPointAnnotation

@property (nonatomic, strong) IWCShop *currentShop;

@end
