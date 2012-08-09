//
//  AppUIView.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AppUIView.h"

@implementation AppUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundImage.tiff"]];
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
