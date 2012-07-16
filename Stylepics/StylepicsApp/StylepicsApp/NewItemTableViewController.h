//
//  NewItemTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/14/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface NewItemTableViewController : UITableViewController
<UIImagePickerControllerDelegate, 
UINavigationControllerDelegate>
{
    BOOL newMedia; 
}
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
@end
