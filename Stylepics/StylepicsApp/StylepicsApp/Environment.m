//
//  Environment.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Environment.h"

// Base URL
#if ENVIRONMENT == ENVIRONMENT_DEVELOPMENT
NSString* const BaseURL = @"http://localhost:3000";
#elif ENVIRONMENT == ENVIRONMENT_STAGING
// TODO: Need a staging environment...
#elif ENVIRONMENT == ENVIRONMENT_PRODUCTION
NSString* const BaseURL = @"http://gentle-hamlet-2953.herokuapp.com";
#endif
