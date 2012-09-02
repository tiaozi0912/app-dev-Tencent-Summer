//
//  MuseMeDelegate.h
//  MuseMe
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
#import "AppFormattedBoldLabel.h"
#import "SmallFormattedLabel.h"
#import "AnimatedPickerView.h"
#import "CenterButtonTabController.h"
#import "MultipartLabel.h"
#import "UILabel+UILabel_Auto.h"
#import <Quartzcore/Quartzcore.h>
//#import <FacebookSDK/FacebookSDK.h>

#define KULER_YELLOW 0
#define KULER_BLACK 1
#define KULER_CYAN  2
#define KULER_WHITE 3
#define KULER_RED   4


#define IDOfPollToBeShown @"IDOfPollToBeShown"
#define CURRENTUSERID @"currentUserID"
#define IS_OLD_USER @"isOldUser"
#define SINGLE_ACCESS_TOKEN_KEY @"singleAccessTokenKey"

#define BACKGROUND_COLOR @"BG.png"
#define NAV_BAR_BACKGROUND_COLOR @"header_bg.png"
#define NAV_BAR_BACKGROUND_WITH_LOGO @"header_with_logo"
#define LOGO @"Logo"
#define LOGO_IN_LANDING_PAGE @"LogoInLandingPage"
#define LOGO_IN_LANDING_PAGE_GLOW @"LogoInLandingPageGlowing"
#define TAB_BAR_BG @"tab_bar_bg"
#define FEEDS_ICON @"feeds-icon"
#define FEEDS_ICON_HL @"feeds-icon-hl"
#define PROFILE_ICON @"profile-icon"
#define PROFILE_ICON_HL @"profile-icon-hl"
#define CAMERA_ICON @"camera-icon.png"
#define CAMERA_ICON_HL @"camera-icon-hl.png"
#define UserLoginNotification @"logged in"
#define UserLogoutNotification @"logged out"
#define DEFAULT_USER_PROFILE_PHOTO_SMALL @"default-profile-photo-small"
#define DEFAULT_USER_PROFILE_PHOTO_LARGE @"default-profile-photo-large"
#define NEW_POLL_BUTTON @"Newpoll"
#define NEW_POLL_BUTTON_HL @"Newpoll-hl"
#define SETTINGS_BUTTON @"Settings"
#define DELETE_ITEM_BUTTON @"Delete"
#define DELETE_ITEM_BUTTON_HL @"Delete-hl"
#define CHECKBOX @"CheckBox"
#define CHECKBOX_HL @"CheckBox-hl"
#define CHECKINBOX @"CheckInBox"
#define CHECKINBOX_HL @"CheckInBox-hl"
#define NAV_BAR_BUTTON_BG @"Nav-btn-bg"
#define NAV_BAR_BUTTON_BG_HL @"Nav-btn-bg-hl"
#define ACTION_BUTTON @"Action"
#define ACTION_BUTTON_HL @"Action-hl"
#define ADD_ITEM_HINT @"AddItemHint"
#define DONE_BUTTON  @"done"
#define DONE_BUTTON_HL @"done-hl"
#define CANCEL_BUTTON  @"cancel"
#define CANCEL_BUTTON_HL @"cancel-hl"
#define NEXT_BUTTON @"next-icon"
#define BACK_BUTTON @"back-icon"
#define PIC_CONTAINER_BG @"PictureContainer"
#define PROFILE_TAB_CONTROL_BUTTON @"tab"
#define PROFILE_TAB_CONTROL_BUTTON_HL @"tab-hl"
#define EMPTY_POLL_HINT @"add-new-items"
#define TAP_TO_ADD_INFO @"tap-to-add"
#define TAP_FOR_MORE_INFO @"tap-for-more-info"

#define MAX_CHARACTER_NUMBER_FOR_ITEM_DESCRIPTION 33
#define MAX_CHARACTER_NUMBER_FOR_POLL_DESCRIPTION 90

#define SMALL_CORNER_RADIUS 2
#define SMALL_BORDER_WIDTH 2

#define MEDIUM_CORNER_RADIUS 5
#define MEDIUM_BORDER_WIDTH 5

#define LARGE_CORNER_RADIUS 7
#define LARGE_BORDER_WIDTH 7
typedef enum{
    SingleItemViewOptionNew,
    SingleItemViewOptionEdit,
    SingleItemViewOptionView
}SingleItemViewOption;

HJObjManager *HJObjectManager;

@interface MuseMeDelegate : UIResponder 

@property (strong, nonatomic) UIWindow *window;


@end
