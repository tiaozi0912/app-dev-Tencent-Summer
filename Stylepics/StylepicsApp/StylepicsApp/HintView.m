//
//  HintView.m
//  MuseMe
//
//  Created by Yong Lin on 8/11/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "HintView.h"

@implementation HintView
@synthesize label = _label, icon = _icon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.label = [[UILabel alloc] init];        
        [self addSubview:self.label];
        self.icon = [UIImageView new];
        [self addSubview:self.icon];
        
        self.backgroundColor =[UIColor colorWithWhite:1 alpha:0.3];
        
        // border
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        
        // corner
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.label.frame = CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame) - 10);
    }
    return self;
}

-(void) setIcon:(UIImageView *)icon{
    _icon = icon;
}
-(void) setLabel:(UILabel *)label{
    _label = label;
    _label.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:14];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blackColor];
    

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
