//
//  IWCShopDetailViewController.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+IWCColors.h"
#import "IWCShop.h"

@interface IWCShopDetailViewController : UIViewController

@property (nonatomic, retain) UIView *navBar;
@property (nonatomic, retain) IWCShop *shop;

@end
