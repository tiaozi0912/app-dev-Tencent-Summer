//
//  NewsFeedTableViewController.h
//  MuseMe
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MuseMeDelegate.h"
#import "FeedsCell.h"
#import "NewPollViewController.h"


@interface NewsFeedTableViewController : UITableViewController<RKObjectLoaderDelegate, NewPollViewControllerDelegate>

@end
