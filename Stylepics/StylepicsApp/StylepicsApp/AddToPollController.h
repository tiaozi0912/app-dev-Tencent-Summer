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
@property (nonatomic, strong) UIImage *capturedItemImage;
@property (strong, nonatomic) Item *item;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *pickPollTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *chooseCategoryLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UIView *categoryPickerParentView;
@end
