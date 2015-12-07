//
//  IWCAboutPageBuilder.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-26.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPPopupController.h"
#import "UIColor+IWCColors.h"
@import UIKit;

@interface IWCAboutPageBuilder : NSObject

- (NSArray <UIView *> *)buildAboutPage:(SelectionHandler) handler;

@end
