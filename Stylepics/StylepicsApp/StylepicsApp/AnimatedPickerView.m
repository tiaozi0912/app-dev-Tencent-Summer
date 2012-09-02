//
//  AnimatedPickerView.m
//  MuseMe
//
//  Created by Yong Lin on 8/20/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AnimatedPickerView.h"

@implementation AnimatedPickerView
@synthesize isOn = _isOn;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)presentPickerView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -216);
    self.transform = transform;
    [UIView commitAnimations];
    self.isOn = YES;
}

-(void)dismissPickerView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 216);
    self.transform = transform;
    [UIView commitAnimations];
    self.isOn = NO;
}

@end
