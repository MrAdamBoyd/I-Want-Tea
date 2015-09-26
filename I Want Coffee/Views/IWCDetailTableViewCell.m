//
//  IWCDetailTableViewCell.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-26.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCDetailTableViewCell.h"

@implementation IWCDetailTableViewCell

@synthesize header;
@synthesize mainText;
@synthesize actionURL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {    
        //Header for the cell
        header = [[UILabel alloc] init];
        [header setTranslatesAutoresizingMaskIntoConstraints:false];
        [self.contentView addSubview:header];
        [header setFont:[UIFont systemFontOfSize:18]];
        [header setTextColor:[UIColor blueColor]];
        
        //10px from top, left
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:header attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        
        
        //Main text of the cell
        mainText = [[UILabel alloc] init];
        [mainText setTranslatesAutoresizingMaskIntoConstraints:false];
        [self.contentView addSubview:mainText];
        [mainText setFont:[UIFont systemFontOfSize:16]];
        [mainText setTextColor:[UIColor blackColor]];
        mainText.numberOfLines = 0; //The address is multiple lines
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:mainText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:30]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:mainText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:mainText attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    }
    
    return self;
}

@end
