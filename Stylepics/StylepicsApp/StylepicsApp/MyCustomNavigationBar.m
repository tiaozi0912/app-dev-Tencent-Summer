//
//  MyCustomNavigationBar.m
//  StylepicsApp
//
//  Created by Yujun Wu on 7/18/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MyCustomNavigationBar.h"

@implementation MyCustomNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"Custom-Nav-Bar-BG"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                      
}


@end
