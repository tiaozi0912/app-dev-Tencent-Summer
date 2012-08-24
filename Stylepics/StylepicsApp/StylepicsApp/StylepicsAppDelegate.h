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
#import "AnimatedPickerView.h"
#import "CenterButtonTabController.h"
#import "MultipartLabel.h"
#import <Quartzcore/Quartzcore.h>
//#import <FacebookSDK/FacebookSDK.h>

#define KULER_YELLOW 0
#define KULER_BLACK 1
#define KULER_CYAN  2
#define KULER_WHITE 3
#define KULER_RED   4


#define IDOfPollToBeShown @"IDOfPollToBeShown"
#define CURRENTUSERID @"currentUserID"
#define NEWUSER @"newUser"
#define SINGLE_ACCESS_TOKEN_KEY @"singleAccessTokenKey"

#define BACKGROUND_COLOR @"BG.png"
#define NAV_BAR_BACKGROUND_COLOR @"header_bg.png"
#define NAV_BAR_BACKGROUND_WITH_LOGO @"header_bg-logo"
#define TAB_BAR_BG @"tab_bar_bg"
#define FEEDS_ICON @"feeds-icon"
#define FEEDS_ICON_HL @"feeds-icon-hl"
#define PROFILE_ICON @"profile-icon"
#define PROFILE_ICON_HL @"profile-icon-hl"
#define CAMERA_ICON @"camera-icon.png"
#define CAMERA_ICON_HL @"camera-icon-hl.png"
#define UserLoginNotification @"logged in"
#define UserLogoutNotification @"logged out"
#define DEFAULT_USER_PROFILE_PHOTO @"default_profile_photo.jpeg"
#define NEW_POLL_BUTTON @"Newpoll"
#define NEW_POLL_BUTTON_HL @"Newpoll-hl"
#define SETTINGS_BUTTON @"Settings"
#define SETTINGS_BUTTON_HL @"Settings-hl"
#define DELETE_ITEM_BUTTON @"DeleteItem"
#define DELETE_ITEM_BUTTON_HL @"DeleteItem-hl"
#define CHECKBOX @"CheckBox"
#define CHECKBOX_HL @"CheckBox-hl"
#define CHECKINBOX @"CheckInBox"
#define CHECKINBOX_HL @"CheckInBox-hl"
#define BACK_BUTTON @"Back"
#define BACK_BUTTON_HL @"Back-hl"
#define ACTION_BUTTON @"Action"
#define ACTION_BUTTON_HL @"Action-hl"
#define ADD_ITEM_HINT @"AddItemHint"

typedef enum{
    SingleItemViewOptionNew,
    SingleItemViewOptionEdit,
    SingleItemViewOptionView
}SingleItemViewOption;

HJObjManager *HJObjectManager;

@interface StylepicsAppDelegate : UIResponder 

@property (strong, nonatomic) UIWindow *window;


@end
