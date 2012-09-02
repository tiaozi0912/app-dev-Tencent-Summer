//
//  MultipartLabel.h
//  MuseMe
//
//  Created by Yong Lin on 8/21/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface MultipartLabel : UIView {
}

@property (nonatomic,retain) UIView *containerView;
@property (nonatomic,retain) NSMutableArray *labels;
@property (nonatomic) UIViewContentMode contentMode;

- (void)updateNumberOfLabels:(int)numLabels;
- (void)setText:(NSString *)text forLabel:(int)labelNum;
- (void)setText:(NSString *)text andFont:(UIFont*)font forLabel:(int)labelNum;
- (void)setText:(NSString *)text andColor:(UIColor*)color forLabel:(int)labelNum;
- (void)setText:(NSString *)text andFont:(UIFont*)font andColor:(UIColor*)color forLabel:(int)labelNum;

@end