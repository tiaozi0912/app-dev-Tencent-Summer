//
//  AddToPollController.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/26/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"

@interface AddToPollController : UIViewController<UITextFieldDelegate,RKObjectLoaderDelegate,AmazonServiceRequestDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pickPollButton;
@property (weak, nonatomic) IBOutlet AnimatedPickerView *pickerView;
@property (nonatomic, strong) UIImage *capturedItemImage;
@property (weak, nonatomic) IBOutlet UITextField *pickPollTitleTextField;
@property (strong, nonatomic) Item *item;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@end
