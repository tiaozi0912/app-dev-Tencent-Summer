//
//  StylepicsEntryPageViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StylepicsEntryPageViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
