//
//  NewsFeedNewPollCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface NewsFeedNewPollCell : UITableViewCell
@property (nonatomic, weak) IBOutlet HJManagedImageV *userImage;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel *eventDescriptionLabel;

@end
