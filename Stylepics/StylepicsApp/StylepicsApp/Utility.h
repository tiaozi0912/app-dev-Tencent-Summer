//
//  Utility.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import "StylepicsAppDelegate.h" 

@interface Utility : NSObject
{
    
}

+(void) showAlert:(NSString *) title message:(NSString *) msg; 
+(void) setObject:(id) obj forKey:(NSString*) key;
+(id) getObjectForKey:(NSString*) key;
+ (NSString*) formatCurrencyWithString: (NSString *) string;
+(NSString*) formatCurrencyWithNumber: (NSNumber *) number;
+(UILabel*)formatTitleWithString:(NSString *) titleText;
+(NSString*)formatTimeWithDate:(NSDate *) date;
+(NSURL*)URLforCategory:(PollCategory) category;
+(NSString*)stringFromCategory:(PollCategory) category;
+(PollCategory)categoryFromString:(NSString*) string;
@end
