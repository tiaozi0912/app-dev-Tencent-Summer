//
//  ManagePollsTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingPollCell.h"
#import "OpenedPollCell.h"
#import "EndedPollCell.h"
#import "VotedPollCell.h"
#import "Utility.h"
#import "NewPollViewController.h"

@interface ManagePollsTableViewController : UITableViewController<RKObjectLoaderDelegate, NewPollViewControllerDelegate>

@property (weak, nonatomic) IBOutlet HJManagedImageV *userPhoto;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *usernameLabel;
@end
