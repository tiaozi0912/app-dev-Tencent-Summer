//
//  Audience.h
//  MuseMe
//
//  Created by Yong Lin on 8/2/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "User.h"

@interface Audience : User

@property (nonatomic, strong) NSNumber *audienceID, *pollID, *hasVoted, *isFollowing;

@end
