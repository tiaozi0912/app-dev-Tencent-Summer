//  MultipartLabel.m
//  MultipartLabel
//
//  Created by Jason Miller on 10/7/09.
//  Updated by Laurynas Butkus, 2011
//  Copyright 2009 Jason Miller. All rights reserved.
//

#import "MultipartLabel.h"

@interface MultipartLabel (Private)
- (void)updateLayout;
@end

@implementation MultipartLabel

@synthesize containerView;
@synthesize labels;
@synthesize contentMode;

-(void)updateNumberOfLabels:(int)numLabels
{
    [containerView removeFromSuperview];
    self.containerView = nil;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.containerView];
    self.labels = [NSMutableArray array];
    
    while (numLabels-- > 0) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = self.backgroundColor;
        [self.containerView addSubview:label];
        [self.labels addObject:label];
        label = nil;
    }
    
    [self updateLayout];
}

-(void)setText:(NSString *)text forLabel:(int)labelNum
{
    if( [self.labels count] > labelNum && labelNum >= 0 )
    {
        UILabel * thisLabel = [self.labels objectAtIndex:labelNum];
        thisLabel.text = text;
    }
    
    [self updateLayout];
}

-(void)setText:(NSString *)text andFont:(UIFont*)font forLabel:(int)labelNum
{
    if( [self.labels count] > labelNum && labelNum >= 0 )
    {
        UILabel * thisLabel = [self.labels objectAtIndex:labelNum];
        thisLabel.text = text;
        thisLabel.font = font;
    }
    
    [self updateLayout];
}

-(void)setText:(NSString *)text andColor:(UIColor*)color forLabel:(int)labelNum
{
    if( [self.labels count] > labelNum && labelNum >= 0 )
    {
        UILabel * thisLabel = [self.labels objectAtIndex:labelNum];
        thisLabel.text = text;
        thisLabel.textColor = color;
    }
    
    [self updateLayout];
}

- (void)setText:(NSString *)text andFont:(UIFont*)font andColor:(UIColor*)color forLabel:(int)labelNum
{
    if( [self.labels count] > labelNum && labelNum >= 0 )
    {
        UILabel * thisLabel = [self.labels objectAtIndex:labelNum];
        thisLabel.text = text;
        thisLabel.font = font;
        thisLabel.textColor = color;
    }
    
    [self updateLayout];
}

- (void)updateLayout {
    
    int thisX;
    int thisY;
    int totalWidth = 0;
    int offsetX = 0;
    
    int sizes[[self.labels count]][2];
    int i = 0;
    
    for (UILabel * thisLabel in self.labels) {
        CGSize size = [thisLabel.text sizeWithFont:thisLabel.font constrainedToSize:CGSizeMake(9999, 9999)
                                     lineBreakMode:thisLabel.lineBreakMode];
        
        sizes[i][0] = size.width;
        sizes[i][1] = size.height;
        totalWidth+= size.width;
        
        i++;
    }
    
    i = 0;
    
    for (UILabel * thisLabel in self.labels) {
        // X
        switch (self.contentMode) {
            case UIViewContentModeRight:
            case UIViewContentModeBottomRight:
            case UIViewContentModeTopRight:
                thisX = self.frame.size.width - totalWidth + offsetX;
                break;
                
            case UIViewContentModeCenter:
                thisX = (self.frame.size.width - totalWidth) / 2 + offsetX;
                break;
                
            default:
                thisX = offsetX;
                break;
        }
        
        // Y
        switch (self.contentMode) {
            case UIViewContentModeBottom:
            case UIViewContentModeBottomLeft:
            case UIViewContentModeBottomRight:
                thisY = self.frame.size.height - sizes[i][1];
                break;
                
            case UIViewContentModeCenter:
                thisY = (self.frame.size.height - sizes[i][1]) / 2;
                break;
                
            default:
                thisY = 0;
                break;
        }
        
        thisLabel.frame = CGRectMake( thisX, thisY, sizes[i][0], sizes[i][1] );
        
        offsetX += sizes[i][0];
        
        i++;
    }
}

- (void)dealloc {
    labels = nil;
    
    containerView = nil;
    
}

@end