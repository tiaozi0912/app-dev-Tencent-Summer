//
//  AppFormattedLabel.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/12/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AppFormattedLabel.h"

@implementation AppFormattedLabel
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Helvetica" size:15.0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont fontWithName:@"Helvetica" size:15];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
