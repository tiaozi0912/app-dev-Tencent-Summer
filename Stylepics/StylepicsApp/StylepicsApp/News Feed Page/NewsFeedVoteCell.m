//
//  NewsFeedVoteCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedVoteCell.h"

@implementation NewsFeedVoteCell
@synthesize userImage=_userImage;
@synthesize usernameAndActionLabel=_usernameAndActionLabel;
@synthesize itemImage = _itemImage;
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
