//
//  IWCViewController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCViewController.h"

@implementation IWCViewController

@synthesize navBar;
@synthesize titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tiltBlue];
    
    //Nav bar
    navBar = [[UIView alloc] init];
    [self.view addSubview:navBar];
    [navBar setTranslatesAutoresizingMaskIntoConstraints:false];
    navBar.backgroundColor = [UIColor tiltBlue];
    
    //20px from top, 0px from left, right, 44px height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    //Adding app title to UIView at top of screen
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [navBar addSubview:titleLabel];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    //Centered on X and centered -2px on Y
    [navBar addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:-2]];
    [navBar addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeLeft multiplier:1 constant:65]];
    [navBar addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeRight multiplier:1 constant:-65]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
