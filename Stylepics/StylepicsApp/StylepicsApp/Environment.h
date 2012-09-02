//
//  Environment.h
//  MuseMe
//
//  Created by Yong Lin on 7/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

/**
 * The Base URL constant. This Base URL is used to initialize RestKit via RKClient
 * or RKObjectManager (which in turn initializes an instance of RKClient). The Base
 * URL is used to build full URL's by appending a resource path onto the end.
 *
 * By abstracting your Base URL into an externally defined constant and utilizing
 * conditional compilation, you can very quickly switch between server environments
 * and produce builds targetted at different backend systems.
 */
extern NSString* const BaseURL;

/**
 * Server Environments for conditional compilation
 */
#define ENVIRONMENT_DEVELOPMENT 0
#define ENVIRONMENT_STAGING 1
#define ENVIRONMENT_PRODUCTION 2

// Use Production by default
#ifndef ENVIRONMENT
#define ENVIRONMENT ENVIRONMENT_STAGING
#endif