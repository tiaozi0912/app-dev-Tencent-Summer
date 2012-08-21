//
//  NewPollViewController.h
//  BasicApp
//
//  Created by Yong Lin on 7/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@protocol NewPollViewControllerDelegate <NSObject>

-(void) newPollViewController:(id)sender
            didCreateANewPoll:(NSNumber*) pollID;

@end

@interface NewPollViewController : UIViewController<UITextFieldDelegate, RKObjectLoaderDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pollNameTextField;
- (IBAction)backgroundTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) id<NewPollViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet AnimatedPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@end
