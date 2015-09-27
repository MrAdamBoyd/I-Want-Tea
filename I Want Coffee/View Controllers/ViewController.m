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

@interface IWCViewController ()

@end

@implementation ViewController

@synthesize mainMapView;
@synthesize bottomToolbar;
@synthesize searchAreaButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[IWCDataController sharedController] setIwcDelegate:self];
    
    self.titleLabel.text = @"I Want Coffee";
    
    //Map View
    mainMapView = [[MKMapView alloc] init];
    [self.view addSubview:mainMapView];
    [mainMapView setTranslatesAutoresizingMaskIntoConstraints:false];
    mainMapView.delegate = self;
    
    //0px from nav bar bottom, 0px from left, right, 0px from bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainMapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainMapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainMapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainMapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    //Toolbar at the bottom
    bottomToolbar = [[UIToolbar alloc] init];
    [self.view addSubview:bottomToolbar];
    [bottomToolbar setBackgroundColor:[UIColor tiltBlue]];
    [bottomToolbar setTintColor:[UIColor whiteColor]];
    [bottomToolbar setBarTintColor:[UIColor tiltBlue]];
    [bottomToolbar setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //0px from bottom, left, right, 44px high
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomToolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomToolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomToolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomToolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    
    //Button that tracks user's location
    MKUserTrackingBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:mainMapView];
    [bottomToolbar setItems:@[userTrackingButton]];
    
    
    //Button that lets user search for any area they want
    searchAreaButton = [[UIButton alloc] init];
    [self.view addSubview:searchAreaButton];
    [searchAreaButton.layer setCornerRadius:15];
    [searchAreaButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [searchAreaButton setTitle:@"Search in Area" forState:UIControlStateNormal];
    [searchAreaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchAreaButton setBackgroundColor:[UIColor whiteColor]];
    [searchAreaButton addTarget:self action:@selector(searchInArea) forControlEvents:UIControlEventTouchUpInside];
    [searchAreaButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    //Highlight animation
    [searchAreaButton setTitleColor:[UIColor colorWithWhite:0 alpha:.3] forState:UIControlStateHighlighted];
    
    //Shadow on button
    searchAreaButton.layer.shadowColor = [UIColor blackColor].CGColor;
    searchAreaButton.layer.shadowOpacity = 0.4;
    searchAreaButton.layer.shadowRadius = 5;
    searchAreaButton.layer.shadowOffset = CGSizeMake(1, 1);
    searchAreaButton.layer.borderWidth = 1;
    searchAreaButton.layer.borderColor = [UIColor tiltBlue].CGColor;
    
    //10px above toolbar, center x, 175 width
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchAreaButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomToolbar attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchAreaButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchAreaButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:175]];
    
    
    if ([self setUpAndShowIntroViews]) {
        //Set the opacity to 0 if we are showing an intro view so we can animate it in
        self.navBar.alpha = 0;
        mainMapView.alpha = 0;
        bottomToolbar.alpha = 0;
        searchAreaButton.alpha = 0;
    }
    
    //If we have permission, start tracking the user
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startTrackingUser];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchInArea {
    //Remove all annotations first
    [mainMapView removeAnnotations:mainMapView.annotations];
    
    [[IWCDataController sharedController] searchForNearbyCoffee:mainMapView.centerCoordinate];
}

//Shows the intro views if the user hasn't opened the app and/or if we don't have authorization to use gps
- (BOOL)setUpAndShowIntroViews {
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
        
        //We did show intro views
        return YES;
    }
    
    //We didn't show any intro views
    return NO;

}

//Starts updating the location & tracks the users location on the map
- (void)startTrackingUser {
    [[[IWCDataController sharedController] locationManager] startUpdatingLocation];
    
    [mainMapView setUserTrackingMode:MKUserTrackingModeFollow];
}

#pragma mark EAIntroDelegate

- (void)introDidFinish:(EAIntroView *)introView {
    [[IWCDataController sharedController] setUserFirstTimeOpeningApp:NO];
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([[[IWCDataController sharedController] locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[[IWCDataController sharedController] locationManager] requestWhenInUseAuthorization];
    }
    
    //Animating the views in
    [UIView animateWithDuration:1.f animations:^{
        self.navBar.alpha = 1;
        mainMapView.alpha = 1;
        bottomToolbar.alpha = 1;
    }];
}

#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    
    //If the user taps on a detail, show in the detail view controller
    if ([annotation isKindOfClass:[IWCMapAnnotation class]]) {
        
        IWCMapAnnotation *currentAnnotation = (IWCMapAnnotation *)annotation;
        
        IWCShopDetailViewController *shopViewController = [[IWCShopDetailViewController alloc] initWithShop:currentAnnotation.currentShop];
        
        [self presentViewController:shopViewController animated:YES completion:nil];
    }
}

//Gets the view for each annotation (pin) on the map
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil, which is the default
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    
    // Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(0, 0, 23, 23);
    annotationView.rightCalloutAccessoryView = button;
    
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    if (mode == MKUserTrackingModeFollow) {
        [UIView animateWithDuration:.5 animations:^{
            searchAreaButton.alpha = 0;
        }];
        
        //We have annotation on the map, research
        if (mainMapView.annotations.count > 1) {
            [[IWCDataController sharedController] searchForNearbyCoffee:[[IWCDataController sharedController] savedLocation].coordinate];
        }
        
    } else if (mode == MKUserTrackingModeNone) {
        [UIView animateWithDuration:.5 animations:^{
            searchAreaButton.alpha = 1;
        }];
    }
}

#pragma mark StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark IWCLocationListenerDelegate

//Adding all the shops to the screen
- (void)addShopsToScreen:(NSArray<IWCShop *> *)shops {
    for (IWCShop *shop in shops) {
        CLLocationCoordinate2D shopPoint;
        shopPoint.latitude = [shop.lat floatValue];
        shopPoint.longitude = [shop.lon floatValue];
        
        IWCMapAnnotation *annotation = [[IWCMapAnnotation alloc] init];
        [annotation setCoordinate:shopPoint];
        [annotation setTitle:shop.name];
        [annotation setSubtitle:shop.addressArray[0]];
        [annotation setCurrentShop:shop];
        [mainMapView addAnnotation:annotation];
    }
}

- (void)userAuthorizedLocationUse {
    [self startTrackingUser];
}

- (void)showLoadingHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideLoadingHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
