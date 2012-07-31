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
    
    // Class:User
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    //userMapping.primaryKeyAttribute = @"userID";
    userMapping.setDefaultValueForMissingAttributes = YES; // clear out any missing attributes (token on logout)
    [userMapping mapKeyPathsToAttributes:
     @"id", @"userID",
     @"user_name", @"username",
     @"password", @"password",
     //@"profilePhoto", @"profilePhoto",
     //@"profilePhotoURL", @"profilePhotoURL",
     nil];
    
    // Class:UserEvent
    RKObjectMapping* userEventMapping = [RKObjectMapping mappingForClass:[UserEvent class]];
    [userEventMapping mapAttributes:
     @"eventID", @"type", @"userID", @"pollID", @"itemID", @"voteeID",
     nil];

    
    [[RKObjectManager sharedManager].mappingProvider registerMapping:userMapping withRootKeyPath:@"user"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:userEventMapping withRootKeyPath:@"event"];
    //Class:Poll
    
    /*self.databaseName = @"stylepics.db";    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    NSLog(@"%@", self.databasePath);
    [self createAndCheckDatabase];
    StylepicsDatabase *database = [[StylepicsDatabase alloc] init];
    [database initialize];*/
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

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved JSON: %@", [response bodyAsString]);
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
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
