//
//  SettingsTableViewController.h
//  MuseMe
//
//  Created by Yong Lin on 8/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"

@interface SettingsTableViewController : UITableViewController<RKObjectLoaderDelegate, UITextFieldDelegate, AmazonServiceRequestDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet HJManagedImageV *profilePhoto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end
