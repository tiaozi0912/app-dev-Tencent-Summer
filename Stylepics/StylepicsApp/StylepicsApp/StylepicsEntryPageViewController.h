//
//  StylepicsEntryPageViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylepicsDatabase.h"
#import "StylepicsAppDelegate.h" 

@interface StylepicsEntryPageViewController : UIViewController<UITextFieldDelegate,RKObjectLoaderDelegate>


@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end
