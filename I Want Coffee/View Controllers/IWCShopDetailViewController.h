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
#import "IWCViewController.h"

@interface IWCShopDetailViewController : IWCViewController

@property (nonatomic, retain) IWCShop *shop;
@property (nonatomic, retain) UIView *detailView;
@property (nonatomic, retain) UIButton *closeButton;

- (id)initWithShop:(IWCShop *)shopToShow;

@end
