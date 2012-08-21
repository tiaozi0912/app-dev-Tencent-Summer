//
//  SingleItemViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/15/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Item.h"
#import "Utility.h"

@interface SingleItemViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RKObjectLoaderDelegate,AmazonServiceRequestDelegate,UIActionSheetDelegate>
{
    BOOL newMedia; 
}
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (nonatomic) SingleItemViewOption singleItemViewOption;
@property (strong, nonatomic) Item *item;

@end
