//
//  NewsFeedTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedNewCartCell.h"

@interface NewsFeedTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray* events;

@end
