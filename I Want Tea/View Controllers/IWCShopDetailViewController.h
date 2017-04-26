//
//  IWCShopDetailViewController.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "UIColor+IWCColors.h"
#import "IWCShop.h"
#import "IWCDetailTableViewCell.h"

@interface IWCShopDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IWCShop *shop;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *titleArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *descArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *actionArray;

- (id)initWithShop:(IWCShop *)shopToShow;

@end
