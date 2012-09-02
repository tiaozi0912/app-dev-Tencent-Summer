//
//  AmazonClientManager.h
//  MuseMe
//
//  Created by Yong Lin on 8/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>

#define ACCESS_KEY_ID                   @"AKIAJBFJOIWFJZD6AYPA"
#define SECRET_KEY                      @"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"

#define IMAGE_HOST_BASE_URL             @"https://s3.amazonaws.com"
#define APP_UI_IMAGES_BUCKET_NAME       @"app-ui-images-akiajbfjoiwfjzd6aypa"

#if ENVIRONMENT == ENVIRONMENT_DEVELOPMENT
#define USER_PROFILE_PHOTOS_BUCKET_NAME @"testing-user-profile-photos-akiajbfjoiwfjzd6aypa"
#elif ENVIRONMENT == ENVIRONMENT_STAGING
#define USER_PROFILE_PHOTOS_BUCKET_NAME @"staging-user-profile-photos-akiajbfjoiwfjzd6aypa"
#elif ENVIRONMENT == ENVIRONMENT_PRODUCTION
#define USER_PROFILE_PHOTOS_BUCKET_NAME @"user-profile-photos-akiajbfjoiwfjzd6aypa"
#endif


#if ENVIRONMENT == ENVIRONMENT_DEVELOPMENT
#define ITEM_PHOTOS_BUCKET_NAME         @"testing-item-photos-akiajbfjoiwfjzd6aypa"
#elif ENVIRONMENT == ENVIRONMENT_STAGING
#define ITEM_PHOTOS_BUCKET_NAME         @"staging-item-photos-akiajbfjoiwfjzd6aypa"
#elif ENVIRONMENT == ENVIRONMENT_PRODUCTION
#define ITEM_PHOTOS_BUCKET_NAME         @"item-photos-akiajbfjoiwfjzd6aypa"
#endif

@interface AmazonClientManager : NSObject

+(void)initializeS3;
+(AmazonS3Client *)s3;
+(void)clearCredentials;

@end
