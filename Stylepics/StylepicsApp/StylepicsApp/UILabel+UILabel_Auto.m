//
//  UILabel+UILabel_Auto.m
//  MuseMe
//
//  Created by Yong Lin on 8/31/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "UILabel+UILabel_Auto.h"

@implementation UILabel (UILabel_Auto)

- (void)adjustHeight {
    
    if (self.text == nil) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 0);
        return;
    }
    
    CGSize aSize = self.bounds.size;
    CGSize tmpSize = CGRectInfinite.size;
    tmpSize.width = aSize.width;
    
    tmpSize = [self.text sizeWithFont:self.font constrainedToSize:tmpSize];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, aSize.width, tmpSize.height);
}

@end
