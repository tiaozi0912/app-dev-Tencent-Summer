//
//  Utility.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import "MuseMeDelegate.h" 

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
+(NSURL*)URLForCategory:(PollCategory) category;
+(UIImage*)iconForCategory:(PollCategory) category;
+(NSString*)stringFromCategory:(PollCategory) category;
+(PollCategory)categoryFromString:(NSString*) string;
+(UIBarButtonItem *)createSquareBarButtonItemWithNormalStateImage:(NSString*)normalStateImage
                                         andHighlightedStateImage:(NSString*) highlightedStateImage
                                                           target:(id)tgt
                                                           action:(SEL)a;
+(UIColor*)colorFromKuler:(int)kulerColor
                   alpha:(CGFloat)alpha;
+(UIToolbar*)keyboardAccessoryToolBarWithButton:(NSString*)title
                                         target:(id) t
                                         action:(SEL) a;
+(NSString*)stringFromPollState:(int) state;
+(NSString*)formatURLFromDateString:(NSString*) string;
+(void)renderView:(UIView*)view
 withCornerRadius:(CGFloat)r
   andBorderWidth:(CGFloat)w;
@end
