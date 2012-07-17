//
//  PollItemCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PollItemCell.h"

@implementation PollItemCell

@synthesize itemImage=_itemImage, item = _item,countOfCommentsLabel=_countOfCommentsLabel,descriptionOfItemLabel=_descriptionOfItemLabel,priceLabel=_priceLabel,commentIconImage=_commentIconImage;


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
