//
//  NewPollViewController.h
//  BasicApp
//
//  Created by Yong Lin on 7/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface NewPollViewController : UIViewController<UITextFieldDelegate, RKObjectLoaderDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)backgroundTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@end
