//
//  NewsFeedNewPollCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedNewPollCell.h"

@implementation NewsFeedNewPollCell
@synthesize usernameAndActionLabel = _usernameAndActionLabel;
@synthesize userImage=_userImage;
//@synthesize iconImage=_iconImage;
@synthesize eventDescriptionLabel=_eventDescriptionLabel;
@synthesize timeStampLabel = _timeStampLabel, categoryIcon = _categoryIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
