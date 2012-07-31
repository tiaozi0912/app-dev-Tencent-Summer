//
//  NewItemViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/15/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NewItemViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
        BOOL newMedia; 
}
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
@end
