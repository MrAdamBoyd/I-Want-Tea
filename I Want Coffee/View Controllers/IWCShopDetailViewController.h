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
#import "IWCDetailTableViewCell.h"

@interface IWCShopDetailViewController : IWCViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IWCShop *shop;
@property (nonatomic, retain) UITableView *detailTableView;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) NSMutableArray<NSString *> *titleArray;
@property (nonatomic, retain) NSMutableArray<NSString *> *descArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *actionArray;

- (id)initWithShop:(IWCShop *)shopToShow;

@end
