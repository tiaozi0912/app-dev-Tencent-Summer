//
//  FeedsCell.m
//  MuseMe
//
//  Created by Yong Lin on 8/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "FeedsCell.h"

@implementation FeedsCell
@synthesize categoryLabel;
@synthesize userImage=_userImage;
@synthesize eventDescriptionLabel=_eventDescriptionLabel;
@synthesize thumbnail0, thumbnail1, thumbnail2, thumbnail3, thumbnail4;
@synthesize timeStampLabel = _timeStampLabel, categoryIcon = _categoryIcon;
@synthesize usernameAndActionLabel;
@synthesize totalVotes;
@synthesize picContainerImageView;
@synthesize picContainer;
@synthesize seperator;

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
