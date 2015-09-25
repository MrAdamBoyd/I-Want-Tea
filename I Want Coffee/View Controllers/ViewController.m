//
//  ViewController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"

#define kIntroViewTitleFont [UIFont systemFontOfSize:35]
#define kIntroViewDescFont [UIFont systemFontOfSize:25]
#define kIntroViewTitleY [[UIScreen mainScreen] bounds].size.height - 100
#define kIntroViewDescY [[UIScreen mainScreen] bounds].size.height - 150
#define kIntroPage1Image [UIImage imageNamed:@"Coffee.png"]
#define kIntroPage2Image [UIImage imageNamed:@"CoffeeArt.png"]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Showing the intro views
    [self setUpAndShowIntroViews];
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
        EAIntroView *introView = [[EAIntroView alloc] initWithFrame:frameRect andPages:introViewArray];
        introView.delegate = self;
        [introView showInView:self.view animateDuration:0];
    }
    
}

#pragma mark EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView {
    [[IWCDataController sharedController] setUserFirstTimeOpeningApp:NO];
    [[[IWCDataController sharedController] locationManager] requestWhenInUseAuthorization];
    [[[IWCDataController sharedController] locationManager] startUpdatingLocation];
}

#pragma mark StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
