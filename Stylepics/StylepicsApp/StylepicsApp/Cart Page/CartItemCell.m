//
//  CartItemCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "CartItemCell.h"

@implementation CartItemCell
@synthesize itemImage=_itemImage;
@synthesize countOfCommentsLabel=_countOfCommentsLabel;
@synthesize descriptionOfItemLabel=_descriptionOfItemLabel;
@synthesize priceLabel=_priceLabel;
@synthesize commentIconImage=_commentIconImage;

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
