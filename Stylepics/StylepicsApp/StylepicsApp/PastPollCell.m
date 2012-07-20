//
//  PastPollCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PastPollCell.h"

@implementation PastPollCell
@synthesize nameLabel, votesLabel, dateLabel;

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
