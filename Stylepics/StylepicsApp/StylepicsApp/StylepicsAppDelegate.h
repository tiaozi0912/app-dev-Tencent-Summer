//
//  StylepicsAppDelegate.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "HJObjManager.h"
#import "HJManagedImageV.h"
#import "Event.h"
#import "User.h"
#import "Poll.h"
#import "Item.h"
#import "PollRecord.h"
#import "Audience.h"
#import "AmazonClientManager.h"

#define IDOfPollToBeShown @"IDOfPollToBeShown"
#define CURRENTUSERID @"currentUserID"
#define NEWUSER @"newUser"
#define SINGLE_ACCESS_TOKEN_KEY @"singleAccessTokenKey"

#define ACTIVE @"ACTIVE"
#define PAST @"PAST"
#define FOLLOWED @"FOLLOWED"

HJObjManager *HJObjectManager;

@interface StylepicsAppDelegate : UIResponder 

@property (strong, nonatomic) UIWindow *window;


@end
