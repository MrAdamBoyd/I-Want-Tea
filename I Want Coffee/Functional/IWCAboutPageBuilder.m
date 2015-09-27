//
//  IWCAboutPageBuilder.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-26.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCAboutPageBuilder.h"
#define kIWCWebsiteLink @"http:adamjboyd.com"

@implementation IWCAboutPageBuilder

- (NSArray <UIView *> *)buildAboutPage:(SelectionHandler) handler {
    NSMutableArray<UIView *> *pageElements = [[NSMutableArray alloc] init];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"I Want Coffee" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *writtenByString = [[NSAttributedString alloc] initWithString:@"Written by Adam Boyd" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setNumberOfLines:0];
    [titleLabel setAttributedText:titleString];
    
    UILabel *writtenByLabel = [[UILabel alloc] init];
    [writtenByLabel setNumberOfLines:0];
    [writtenByLabel setAttributedText:writtenByString];
    
    //Version label
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSAttributedString *versionAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Version %@", versionString] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]}];
    UILabel *versionLabel = [[UILabel alloc] init];
    [versionLabel setNumberOfLines:0];
    [versionLabel setAttributedText:versionAttrString];
    
    
    //Open website and close popup buttons
    CNPPopupButton *openWebsiteButton = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [openWebsiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openWebsiteButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [openWebsiteButton setTitle:@"Go to Website" forState:UIControlStateNormal];
    [openWebsiteButton setBackgroundColor:[UIColor tiltBlue]];
    openWebsiteButton.layer.cornerRadius = 2.0;
    [openWebsiteButton setSelectionHandler:^(CNPPopupButton *button) {
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:kIWCWebsiteLink]];
    }];
    
    //Open website and close popup buttons
    CNPPopupButton *closePopupButton = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [closePopupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closePopupButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closePopupButton setTitle:@"Close" forState:UIControlStateNormal];
    [closePopupButton setBackgroundColor:[UIColor tiltBlue]];
    closePopupButton.layer.cornerRadius = 2.0;
    [closePopupButton setSelectionHandler:handler];
    
    [pageElements addObjectsFromArray:@[titleLabel, writtenByLabel, versionLabel, openWebsiteButton, closePopupButton]];
    
    return pageElements;
}

@end