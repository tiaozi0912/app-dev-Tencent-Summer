//
//  NewsFeedNewCartCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedNewCartCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImage;
@property (nonatomic, strong) IBOutlet UILabel *eventDescriptionLabel;

@end
