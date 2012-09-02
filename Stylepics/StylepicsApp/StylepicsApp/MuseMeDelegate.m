//
//  MuseMeDelegate.m
//  MuseMe
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MuseMeDelegate.h"


@implementation MuseMeDelegate

@synthesize window = _window;

/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // Initialize the RestKit Object Manager
	[RKObjectManager managerWithBaseURLString:BaseURL];
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    // Class:User
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapKeyPathsToAttributes:
     @"id", @"userID",
     @"user_name", @"username",
     @"password", @"password",
     @"email", @"email",
     @"password_confirmation", @"passwordConfirmation",
     @"profile_photo_url", @"profilePhotoURL",
     @"single_access_token", @"singleAccessToken",
     nil];
    
    [[RKObjectManager sharedManager].mappingProvider registerMapping:userMapping withRootKeyPath:@"user"];
    
    
    // Class:PollRecord
    RKObjectMapping* pollRecordMapping = [RKObjectMapping mappingForClass:[PollRecord class]];
    [pollRecordMapping setPreferredDateFormatter:dateFormatter];
    [pollRecordMapping mapKeyPathsToAttributes:
     @"poll_id", @"pollID",
     @"user_id", @"userID",
     @"total_votes", @"totalVotes",
     @"poll_record_type", @"pollRecordType",
     @"title", @"title",
     @"state", @"state",
     @"start_time", @"startTime",
     @"end_time", @"endTime",
     @"open_time", @"openTime",
     @"items_count", @"itemsCount",
     nil];
    [pollRecordMapping mapRelationship:@"owner" withMapping:userMapping];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:pollRecordMapping withRootKeyPath:@"poll_record"];
    
    // Class:Audience
    RKObjectMapping* audienceMapping = [RKObjectMapping mappingForClass:[Audience class]];
    //userMapping.primaryKeyAttribute = @"userID";
    audienceMapping.setDefaultValueForMissingAttributes = YES; // clear out any missing attributes (token on logout)
    [audienceMapping mapKeyPathsToAttributes:
     @"id", @"audienceID",
     @"user_id", @"userID",
     @"has_voted", @"hasVoted",
     @"is_following", @"isFollowing",
     @"user_name", @"username",
     @"profile_Photo_url", @"profilePhotoURL",
     @"poll_id", @"pollID",
     nil];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:audienceMapping withRootKeyPath:@"audience"];
    
    // Class:Comment
    //.........
    
    // Class:Item
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[Item class]];
    [itemMapping mapKeyPathsToAttributes:
     @"id", @"itemID",
     @"description", @"description",
     @"price", @"price",
     @"number_of_votes", @"numberOfVotes",
     @"photo_url", @"photoURL",
     @"poll_id", @"pollID",
     @"brand", @"brand",
     @"created_at", @"addedTime",
     nil];
    //[itemMapping mapRelationship:@"comments" withMapping:commentMapping];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:itemMapping withRootKeyPath:@"item"];
    
    // Class:Poll
    RKObjectMapping* pollMapping = [RKObjectMapping mappingForClass:[Poll class]];
    [pollMapping setPreferredDateFormatter:dateFormatter];
    [pollMapping mapKeyPathsToAttributes:
     @"id", @"pollID",
     @"user_id", @"ownerID",
     @"total_votes", @"totalVotes",
     @"title", @"title",
     @"state", @"state",
     @"start_time", @"startTime",
     @"end_time", @"endTime",
     @"category", @"category",
     @"open_time", @"openTime",
     nil];
    [pollMapping mapRelationship:@"user" withMapping:userMapping];
    [pollMapping mapRelationship:@"items" withMapping:itemMapping];
    [pollMapping mapRelationship:@"audiences" withMapping:audienceMapping];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:pollMapping withRootKeyPath:@"poll"];

    
    // Class:Event
    RKObjectMapping* eventMapping = [RKObjectMapping mappingForClass:[Event class]];
    [eventMapping mapKeyPathsToAttributes:
     @"id", @"eventID",
    // @"event_type", @"eventType",
     @"user_id", @"userID",
     @"poll_id", @"pollID",
    // @"item_id", @"itemID",
     @"created_at", @"timeStamp",
     nil];
    [eventMapping mapRelationship:@"user" withMapping:userMapping];
    //[eventMapping mapKeyPath:@"poll_owner" toRelationship:@"pollOwner" withMapping:userMapping];
    [eventMapping mapRelationship:@"poll" withMapping:pollMapping];
    [eventMapping mapRelationship:@"items" withMapping:itemMapping];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:eventMapping withRootKeyPath:@"event"];
    


    
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/users/:userID"];
	[[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/signup" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[PollRecord class] toResourcePath:@"/poll_records/:pollID"];
	[[RKObjectManager sharedManager].router routeClass:[PollRecord class] toResourcePath:@"/poll_records" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Poll class] toResourcePath:@"/polls/:pollID"];
    [[RKObjectManager sharedManager].router routeClass:[Poll class] toResourcePath:@"/polls" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Item class] toResourcePath:@"/items/:itemID"];
    [[RKObjectManager sharedManager].router routeClass:[Item class] toResourcePath:@"/items" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Event class] toResourcePath:@"/events/:eventID"];
    [[RKObjectManager sharedManager].router routeClass:[Event class] toResourcePath:@"/events" forMethod:RKRequestMethodPOST];
    
    
    [[RKObjectManager sharedManager].router routeClass:[Audience class] toResourcePath:@"/audiences/:audienceID"];
    [[RKObjectManager sharedManager].router routeClass:[Audience class] toResourcePath:@"/audiences" forMethod:RKRequestMethodPOST];
    

    // Override point for customization after application launch.
    
    
    // Create the object manager
  
    HJObjectManager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:1];
	
	//if you are using for full screen images, you'll need a smaller memory cache than the defaults,
	//otherwise the cached images will get you out of memory quickly
	//objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:1];
	
	// Create a file cache for the object manager to use
	// A real app might do this durring startup, allowing the object manager and cache to be shared by several screens
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	HJObjectManager.fileCache = fileCache;
    [HJObjectManager.fileCache emptyCache];
	
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [RKClient setSharedClient:nil];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
