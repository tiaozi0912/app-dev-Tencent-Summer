//
//  NewsFeedNewItemCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedNewItemCell.h"

@implementation NewsFeedNewItemCell
@synthesize userImage=_userImage;
//@synthesize userNameLabel=_userNameLabel;
//@synthesize iconImage=_iconImage;
@synthesize eventDescriptionLabel=_eventDescriptionLabel;
@synthesize itemImage=_itemnImage;
@synthesize timeStampLabel = _timeStampLabel, categoryIcon = _categoryIcon;
@synthesize usernameAndActionLabel;

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
