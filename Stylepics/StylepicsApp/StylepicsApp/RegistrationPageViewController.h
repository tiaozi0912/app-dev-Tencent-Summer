//
//  RegistrationPageViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylepicsDatabase.h"

@interface RegistrationPageViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;

@end
