//
//  IWCShopDetailViewController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCShopDetailViewController.h"

@implementation IWCShopDetailViewController

@synthesize shop;
@synthesize detailView;
@synthesize closeButton;

- (id)initWithShop:(IWCShop *)shopToShow {
    if (self = [super init]) {
        shop = shopToShow;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = shop.name;
    
    //Setting the close button
    closeButton = [[UIButton alloc] init];
    [closeButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [closeButton addTarget:self action:@selector(closeDetailViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:closeButton];
    
    //Setting the text
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateHighlighted];
    
    //10px from right, centered on x,
    [self.navBar addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:-2]];
    [self.navBar addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
    //Detail view
    detailView = [[UIView alloc] init];
    [self.view addSubview:detailView];
    detailView.backgroundColor = [UIColor whiteColor];
    [detailView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //0px below navBar, 0px on left, right, bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeDetailViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
