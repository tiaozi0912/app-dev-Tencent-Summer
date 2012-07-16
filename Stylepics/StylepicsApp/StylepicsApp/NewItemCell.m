//
//  NewItemCell.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/14/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewItemCell.h"

@implementation NewItemCell
@synthesize  itemImage, description, price, tap;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self. tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];// Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
