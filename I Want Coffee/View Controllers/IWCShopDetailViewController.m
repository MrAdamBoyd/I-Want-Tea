//
//  IWCShopDetailViewController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCShopDetailViewController.h"

@interface IWCShopDetailViewController ()

@end

@implementation IWCShopDetailViewController

@synthesize navBar;
@synthesize shop;

- (id)init:(IWCShop *)shopToShow {
    if (self = [super init]) {
        shop = shopToShow;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor tiltDarkBlue];
    
    navBar = [[UIView alloc] init];
    [self.view addSubview:navBar];
    [navBar setTranslatesAutoresizingMaskIntoConstraints:false];
    navBar.backgroundColor = [UIColor tiltDarkBlue];
    
    //20px from top, 0px from left, right, 44px height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
