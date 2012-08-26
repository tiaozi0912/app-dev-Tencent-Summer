//
//  PollTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PollItemCell.h"
#import "Utility.h"
#import "SingleItemViewController.h"
#import "HintView.h"

@interface PollTableViewController : UITableViewController<RKObjectLoaderDelegate, UIAlertViewDelegate,UIActionSheetDelegate, UITextViewDelegate>
@property (nonatomic, strong) Poll *poll;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingWheel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *totalVotesCount;
@property (weak, nonatomic) IBOutlet UITextView *pollDescription;
@property (weak, nonatomic) IBOutlet MultipartLabel *ownerAndStateLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *categoryLabel;
@property (weak, nonatomic) IBOutlet HJManagedImageV *userPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconView;


@end
