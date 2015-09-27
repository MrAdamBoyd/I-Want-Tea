//
//  ViewController.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EAIntroView.h"
#import "IWCDataController.h"
#import "IWCMapAnnotation.h"
#import "IWCShopDetailViewController.h"
#import "IWCViewController.h"
#import "MBProgressHUD.h"

@interface ViewController : IWCViewController <EAIntroDelegate, IWCLocationListenerDelegate, MKMapViewDelegate>

@property (nonatomic, retain) MKMapView *mainMapView;
@property (nonatomic, retain) UIToolbar *bottomToolbar;
@property (nonatomic, retain) UIButton *searchAreaButton;

@end

