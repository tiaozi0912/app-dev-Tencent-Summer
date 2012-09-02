//
//  AppFormattedLabel.m
//  MuseMe
//
//  Created by Yong Lin on 8/12/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AppFormattedLabel.h"
#import "Utility.h"

@implementation AppFormattedLabel
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.textColor = [Utility colorFromKuler:KULER_BLACK alpha:1];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.textColor = [Utility colorFromKuler:KULER_BLACK alpha:1];
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
