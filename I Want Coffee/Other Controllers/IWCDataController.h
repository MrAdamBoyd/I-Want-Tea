//
//  IWCDataController.h
//  I Want Coffee
//
//  Created by Adam on 2015-09-24.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentUser.h"

@interface IWCDataController : NSObject {
    CurrentUser *currentUser;
}

@property (nonatomic, retain) CurrentUser *currentUser;

+ (id)sharedController;

- (BOOL)getUserFirstTimeOpeningApp;
- (void)setUserFirstTimeOpeningApp:(BOOL) firstTime;

@end
