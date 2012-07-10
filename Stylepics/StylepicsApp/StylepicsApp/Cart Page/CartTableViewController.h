//
//  CartTableViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cart.h"
#import "AudienceListView.h"
#import "CartItemCell.h"

@interface CartTableViewController : UITableViewController
@property (nonatomic, strong) Cart* cart;
@end
