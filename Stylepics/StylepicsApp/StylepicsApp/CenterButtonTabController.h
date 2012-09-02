//
//  CenterButtonTabController.h
//  MuseMe
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"
//#import "AddToPollController.h"

@interface CenterButtonTabController : UITabBarController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) UIButton* cameraButton;
@end
