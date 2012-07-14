//
//  NewsFeedVoteCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedVoteCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *userImage;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel *eventDescriptionLabel;
@end
