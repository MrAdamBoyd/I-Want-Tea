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

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Showing the intro views
    [self setUpAndShowIntroViews];
    
    [[IWCDataController sharedController] setIwcDelegate:self];
    
    self.titleLabel.text = @"I Want Coffee";
    
    //Map View
    mapView = [[MKMapView alloc] init];
    [self.view addSubview:mapView];
    [mapView setTranslatesAutoresizingMaskIntoConstraints:false];
    mapView.delegate = self;
    
    //0px from nav bar bottom, 0px from left, right, 0px from bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //Set the opacity to 0 if we are showing an intro view so we can animate it in
    if ([[IWCDataController sharedController] getUserFirstTimeOpeningApp] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.navBar.alpha = 0;
        self.mapView.alpha = 0;
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
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    //Animating the views in
    [UIView animateWithDuration:1.f animations:^{
        self.navBar.alpha = 1;
        self.mapView.alpha = 1;
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
        
        NSLog(@"Clicked shop");
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
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
        [mapView addAnnotation:annotation];
    }
}

@end
