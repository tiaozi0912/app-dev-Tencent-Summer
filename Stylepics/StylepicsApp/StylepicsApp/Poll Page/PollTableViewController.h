//
//  PollTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudienceListView.h"
#import "PollItemCell.h"
#import "Utility.h"
#import "SingleItemViewController.h"
#import "HintView.h"

@interface PollTableViewController : UITableViewController<RKObjectLoaderDelegate, UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) Poll *poll;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingWheel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItemButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *followerCount;

@end
