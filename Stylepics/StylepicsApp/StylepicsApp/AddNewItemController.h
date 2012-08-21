//
//  AddNewItemController.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"

@interface AddNewItemController : UIViewController<UITextFieldDelegate,RKObjectLoaderDelegate,AmazonServiceRequestDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet AnimatedPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *pickPollTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *pickPollButton;

@property (nonatomic, strong) UIImage *capturedItemImage;
@end
