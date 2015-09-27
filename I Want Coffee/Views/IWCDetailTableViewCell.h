//
//  IWCDetailTableViewCell.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-26.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWCDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *header;
@property (nonatomic, strong) UILabel *mainText;
@property (nonatomic, strong) NSString *actionURL;

@end
