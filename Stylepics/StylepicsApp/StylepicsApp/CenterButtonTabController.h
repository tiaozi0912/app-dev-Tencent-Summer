//
//  CenterButtonTabController.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"

@interface CenterButtonTabController : UITabBarController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIButton* button;
@end
