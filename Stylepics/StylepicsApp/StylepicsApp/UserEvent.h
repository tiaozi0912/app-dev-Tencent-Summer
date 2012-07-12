//
//  UserEvent.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Poll.h"

@interface UserEvent : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Poll *poll; 
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) User *votee;
@property (nonatomic, strong) NSString *description;

@end
