//
//  PollTableViewController.h
//  MuseMe
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PollItemCell.h"
#import "Utility.h"
#import "SingleItemViewController.h"
#import "HintView.h"

@interface PollTableViewController : UITableViewController<RKObjectLoaderDelegate, UIAlertViewDelegate,UIActionSheetDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) Poll *poll;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingWheel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *totalVotesCount;
@property (weak, nonatomic) IBOutlet UITextView *pollDescription;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *categoryLabel;
//@property (weak, nonatomic) IBOutlet HJManagedImageV *userPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconView;
//@property (weak, nonatomic) IBOutlet UILabel *username;
//@property (weak, nonatomic) IBOutlet UILabel *stateIndicationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *openPollHint;



@end
