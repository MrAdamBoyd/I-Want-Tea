//
//  ViewController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+IWCColors.h"

#define kIntroViewTitleFont [UIFont systemFontOfSize:35]
#define kIntroViewDescFont [UIFont systemFontOfSize:25]
#define kIntroViewTitleY [[UIScreen mainScreen] bounds].size.height - 100
#define kIntroViewDescY [[UIScreen mainScreen] bounds].size.height - 150
#define kIntroPage1Image [UIImage imageNamed:@"Coffee.png"]
#define kIntroPage2Image [UIImage imageNamed:@"CoffeeArt.png"]

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView;
@synthesize navBar;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Showing the intro views
    [self setUpAndShowIntroViews];
    
    self.view.backgroundColor = [UIColor tiltDarkBlue];
    
    //Nav bar
    navBar = [[UIView alloc] init];
    [self.view addSubview:navBar];
    [navBar setTranslatesAutoresizingMaskIntoConstraints:false];
    navBar.backgroundColor = [UIColor tiltDarkBlue];
    
//    //20px from top, 0px from left, right, 44px height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    //Adding app title to UIView at top of screen
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"I Want Coffee";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [navBar addSubview:titleLabel];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //Centered on X and Y
    [navBar addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:-2]];
    [navBar addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //Map View
    mapView = [[MKMapView alloc] init];
    [self.view addSubview:mapView];
    [mapView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //0px from nav bar bottom, 0px from left, right, 0px from bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //Set the opacity to 0 if we are showing an intro view so we can animate it in
    if ([[IWCDataController sharedController] getUserFirstTimeOpeningApp] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        navBar.alpha = 0;
        mapView.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpAndShowIntroViews {
    NSMutableArray<EAIntroPage *> *introViewArray = [[NSMutableArray alloc] init];
    
    if ([[IWCDataController sharedController] getUserFirstTimeOpeningApp]) {
    //Introducing the app
        EAIntroPage *page1 = [[EAIntroPage alloc] init];
        page1.title = @"I Want Coffee";
        page1.titleFont = kIntroViewTitleFont;
        page1.titlePositionY = kIntroViewTitleY;
        page1.desc = @"This app is the fastest way to find the coffee around you. Simply open the app and enjoy.";
        page1.descFont = kIntroViewDescFont;
        page1.descPositionY = kIntroViewDescY;
        page1.bgImage = kIntroPage1Image;
        [introViewArray addObject:page1];
    }
    
    //If we don't have authorization status, show the page to request it
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        //Asking for permission for GPS while using the app
        EAIntroPage *page2 = [[EAIntroPage alloc] init];
        page2.title = @"GPS Usage";
        page2.titleFont = kIntroViewTitleFont;
        page2.titlePositionY = kIntroViewTitleY;
        page2.desc = @"I Want Coffee needs to use the GPS function on your device in order to function properly. You will be asked for permission when you close this page.";
        page2.descFont = kIntroViewDescFont;
        page2.descPositionY = kIntroViewDescY;
        page2.bgImage = [UIImage imageNamed:@"CoffeeArt.png"];
        page2.bgImage = [page2.bgImage applyBlurWithRadius:20.f tintColor:nil saturationDeltaFactor:1.f maskImage:nil];
        [introViewArray addObject:page2];
    }
    
    if (introViewArray.count > 0) {
        CGRect frameRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + 10);
        EAIntroView *introView = [[EAIntroView alloc] initWithFrame:frameRect];
        introView.pages = introViewArray;
        introView.delegate = self;
        [introView showInView:self.view animateDuration:0];
    }

}

#pragma mark EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView {
    [[IWCDataController sharedController] setUserFirstTimeOpeningApp:NO];
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([[[IWCDataController sharedController] locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[[IWCDataController sharedController] locationManager] requestWhenInUseAuthorization];
    }
    [[[IWCDataController sharedController] locationManager] startUpdatingLocation];
    
    //Animating the views in
    [UIView animateWithDuration:1.f animations:^{
        navBar.alpha = 1;
        mapView.alpha = 1;
    }];
}

#pragma mark StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark IWCLocationListenerProtocol
- (void)locationUpdated:(CLLocation *)newLocation {
    NSLog(@"%@", newLocation);
}

@end
