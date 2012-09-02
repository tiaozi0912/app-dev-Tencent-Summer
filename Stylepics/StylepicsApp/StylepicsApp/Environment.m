//
//  Environment.m
//  MuseMe
//
//  Created by Yong Lin on 7/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Environment.h"

// Base URL
#if ENVIRONMENT == ENVIRONMENT_DEVELOPMENT
//NSString* const BaseURL = @"http://10.30.141.98:3000";
NSString* const BaseURL = @"http://10.30.141.169:3000";//10.30.141.169 yujun home 10.30.141.98 yong
#elif ENVIRONMENT == ENVIRONMENT_STAGING
NSString* const BaseURL = @"http://stamp-bugs.herokuapp.com";
#elif ENVIRONMENT == ENVIRONMENT_PRODUCTION
NSString* const BaseURL = @"http://shop-vote.herokuapp.com/";//@"http://gentle-hamlet-2953.herokuapp.com";
#endif
