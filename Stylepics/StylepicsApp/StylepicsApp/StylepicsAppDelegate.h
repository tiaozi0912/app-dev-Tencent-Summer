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
#import "AppFormattedLabel.h"
#import "SmallFormattedLabel.h"
#import "CenterButtonTabController.h"
#import "MultipartLabel.h"
//#import <FacebookSDK/FacebookSDK.h>


#define IDOfPollToBeShown @"IDOfPollToBeShown"
#define CURRENTUSERID @"currentUserID"
#define NEWUSER @"newUser"
#define SINGLE_ACCESS_TOKEN_KEY @"singleAccessTokenKey"

#define ACTIVE @"ACTIVE"
#define PAST @"PAST"
#define FOLLOWED @"FOLLOWED"

#define BACKGROUND_COLOR @"BG.png"
#define NAV_BAR_BACKGROUND_COLOR @"header_bg.png"
#define TAB_BAR_BG @"tab_bar_bg"
#define FEEDS_ICON @"feeds-icon"
#define FEEDS_ICON_HL @"feeds-icon-hl"
#define PROFILE_ICON @"profile-icon"
#define PROFILE_ICON_HL @"profile-icon-hl"
#define UserLoginNotification @"logged in"
#define UserLogoutNotification @"logged out"
typedef enum{
    SingleItemViewOptionNew,
    SingleItemViewOptionEdit,
    SingleItemViewOptionView
}SingleItemViewOption;


HJObjManager *HJObjectManager;

@interface StylepicsAppDelegate : UIResponder 

@property (strong, nonatomic) UIWindow *window;


@end
