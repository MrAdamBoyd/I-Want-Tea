//
//  IWCDetailTableViewCell.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-26.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWCDetailTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *header;
@property (nonatomic, retain) UILabel *mainText;
@property (nonatomic, retain) NSString *actionURL;

@end
