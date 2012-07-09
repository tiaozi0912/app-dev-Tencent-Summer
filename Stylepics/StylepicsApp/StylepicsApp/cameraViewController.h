//
//  cameraViewController.h
//  BasicApp
//
//  Created by Yong Lin on 7/2/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface cameraViewController : UIViewController
<UIImagePickerControllerDelegate, 
UINavigationControllerDelegate>
{
    UIImageView *imageView;
    BOOL newMedia;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
@end