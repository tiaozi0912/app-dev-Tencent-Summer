//
//  AddNewItemController.h
//  MuseMe
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"

@interface AddNewItemController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
//@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
//@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (nonatomic, strong) UIImage *capturedItemImage;
@property (weak, nonatomic) IBOutlet UIImageView *tapHintView;
@end
