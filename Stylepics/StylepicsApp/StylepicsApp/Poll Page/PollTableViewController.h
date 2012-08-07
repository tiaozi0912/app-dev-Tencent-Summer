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

@interface PollTableViewController : UITableViewController<RKObjectLoaderDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) Poll *poll;
@property (nonatomic, weak) IBOutlet UIAlertView *alertView;
@end
