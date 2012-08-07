//
//  StylepicsAppDelegate.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsAppDelegate.h"


@implementation StylepicsAppDelegate

@synthesize window = _window;
//@synthesize databaseName, databasePath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // Initialize the RestKit Object Manager
	[RKObjectManager managerWithBaseURLString:BaseURL];
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    // Class:User
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    //userMapping.primaryKeyAttribute = @"userID";
    userMapping.setDefaultValueForMissingAttributes = YES; // clear out any missing attributes (token on logout)
    [userMapping mapKeyPathsToAttributes:
     @"user_id", @"userID",
     @"user_name", @"username",
     @"password", @"password",
     @"email", @"email",
     @"password_confirmation", @"passwordConfirmation",
     @"profile_photo_url", @"profilePhotoURL",
     @"single_access_token", @"singleAccessToken",
     nil];
    
    // Class:PollListItem
    RKObjectMapping* pollListItemMapping = [RKObjectMapping mappingForClass:[PollListItem class]];
    [pollListItemMapping setPreferredDateFormatter:dateFormatter];
    [pollListItemMapping mapKeyPathsToAttributes:
     @"poll_id", @"pollID",
     @"user_id", @"userID",
     @"total_votes", @"totalVotes",
     @"type", @"type",
     @"title", @"title",
     @"state", @"state",
     @"start_time", @"startTime",
     @"end_time", @"endTime",
     nil];
    [pollListItemMapping mapRelationship:@"owner" withMapping:userMapping];

    // Class:Audience
    RKObjectMapping* audienceMapping = [RKObjectMapping mappingForClass:[Audience class]];
    //userMapping.primaryKeyAttribute = @"userID";
    audienceMapping.setDefaultValueForMissingAttributes = YES; // clear out any missing attributes (token on logout)
    [audienceMapping mapKeyPathsToAttributes:
     @"audience_id", @"audienceID",
     @"user_id", @"userID",
     @"has_voted", @"hasVoted",
     @"user_name", @"username",
     @"profile_Photo_url", @"profilePhotoURL",
     @"poll_id", @"pollID",
     nil];
    
    // Class:Comment
    //.........
    
    // Class:Item
    RKObjectMapping* itemMapping = [RKObjectMapping mappingForClass:[Poll class]];
    [itemMapping mapKeyPathsToAttributes:
     @"item_id", @"itemID",
     @"description", @"description"
     @"price", @"price"
     @"number_of_votes", @"numberOfVotes",
     @"photo_url", @"photoURL",
     @"poll_id", @"pollID",
     nil];
    //[itemMapping mapRelationship:@"comments" withMapping:commentMapping];

    
    // Class:Poll
    RKObjectMapping* pollMapping = [RKObjectMapping mappingForClass:[Poll class]];
    [pollMapping setPreferredDateFormatter:dateFormatter];
    [pollMapping mapKeyPathsToAttributes:
     @"poll_id", @"pollID",
     @"user_id", @"ownerID",
     @"total_votes", @"totalVotes",
     @"max_votes_for_single_item", @"maxVotesForSingleItem",
     @"title", @"title",
     @"state", @"state",
     @"start_time", @"startTime",
     @"end_time", @"endTime",
     nil];
    [pollMapping mapRelationship:@"owner" withMapping:userMapping];
    [pollMapping mapRelationship:@"items" withMapping:itemMapping];
    [pollMapping mapRelationship:@"audience" withMapping:audienceMapping];
    

    
    // Class:Event
    RKObjectMapping* eventMapping = [RKObjectMapping mappingForClass:[Event class]];
    [eventMapping mapKeyPathsToAttributes:
     @"event_id", @"eventID",
     @"type", @"type",
     nil];
    [eventMapping mapRelationship:@"user" withMapping:userMapping];
    [eventMapping mapRelationship:@"poll" withMapping:pollMapping];
    [eventMapping mapRelationship:@"item" withMapping:itemMapping];
    

    [[RKObjectManager sharedManager].mappingProvider registerMapping:userMapping withRootKeyPath:@"user"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:pollListItemMapping withRootKeyPath:@"poll_list"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:itemMapping withRootKeyPath:@"item"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:pollMapping withRootKeyPath:@"poll"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:eventMapping withRootKeyPath:@"event"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:audienceMapping withRootKeyPath:@"audience"];

    
    [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/users/:userID"];
	[[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/signup" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[PollListItem class] toResourcePath:@"/users/:userID/poll_list/:pollID"];
	[[RKObjectManager sharedManager].router routeClass:[PollListItem class] toResourcePath:@"/users/:userID/poll_list" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Poll class] toResourcePath:@"/polls/:pollID"];
    [[RKObjectManager sharedManager].router routeClass:[Poll class] toResourcePath:@"/polls" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Item class] toResourcePath:@"/polls/:pollID/items/:itemID"];
    [[RKObjectManager sharedManager].router routeClass:[Item class] toResourcePath:@"/polls/:pollID/items" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Event class] toResourcePath:@"/events/:eventID"];
    [[RKObjectManager sharedManager].router routeClass:[Event class] toResourcePath:@"/events" forMethod:RKRequestMethodPOST];
    
    [[RKObjectManager sharedManager].router routeClass:[Audience class] toResourcePath:@"/polls/:pollID/audience/:audienceID"];
    [[RKObjectManager sharedManager].router routeClass:[Audience class] toResourcePath:@"/polls/:pollID/audience" forMethod:RKRequestMethodPOST];
    

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
	
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
    
    return YES;
}


/*-(void) createAndCheckDatabase
{
    BOOL success; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) return; 
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}*/

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
