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
@property (nonatomic, strong) NSNumber *eventID, *userID, *pollID, *itemID, *voteeID;

@end
