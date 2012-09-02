//
//  comment.h
//  MuseMe
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface comment : NSObject
@property (nonatomic, strong) User *commenter; 
@property (nonatomic, strong) NSString *content;

@end
