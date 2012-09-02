//
//  AmazonClientManager.m
//  MuseMe
//
//  Created by Yong Lin on 8/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AmazonClientManager.h"
static AmazonS3Client *s3  = nil;

@implementation AmazonClientManager

+(void)initializeS3
{
    s3  = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
}

+(AmazonS3Client *)s3
{
    return s3;
}


+(void)clearCredentials
{
    s3 = nil;
}

@end
