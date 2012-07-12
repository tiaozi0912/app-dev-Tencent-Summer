//
//  PollTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poll.h"
#import "AudienceListView.h"
#import "PollItemCell.h"

@interface PollTableViewController : UITableViewController
@property (nonatomic, strong) Poll* poll;
@end
