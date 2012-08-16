//
//  Utility.m
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import "Utility.h"



@implementation Utility


+(void) showAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];

    [alert show];
}

+(void) setObject:(id) obj forKey:(NSString*) key{
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [session setObject:obj forKey:key];
    [session synchronize];
}

+(id) getObjectForKey:(NSString*) key{
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    return [session objectForKey:key];
}

+ (NSString*) formatCurrencyWithString: (NSString *) string
{
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    // reset style to no style for converting string to number.
    [currencyStyle setNumberStyle:NSNumberFormatterNoStyle];
    
    //create number from string
    NSNumber * balance = [currencyStyle numberFromString:string];
    
    //now set to currency format
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setMaximumFractionDigits:2];
    [currencyStyle setMinimumFractionDigits:2];
    // get formatted string
    NSString* formatted = [currencyStyle stringFromNumber:balance];
    
    currencyStyle = nil;
    
    //return formatted string
    return formatted;
}

+ (NSString*) formatCurrencyWithNumber: (NSNumber *) price
{
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    // set to currency format
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setMaximumFractionDigits:2];
    [currencyStyle setMinimumFractionDigits:2];
    // get formatted string
    NSString* formatted = [currencyStyle stringFromNumber:price];
    
    currencyStyle = nil;
    
    //return formatted string
    return formatted;
}

+(UILabel*)formatTitleWithString:(NSString *) titleText
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"Noteworthy-Light" size:25];
    title.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    title.textAlignment = UITextAlignmentCenter;
    title.textColor = [UIColor whiteColor]; // change this color
    title.text = titleText;
    [title sizeToFit];
    return title;
}

+(NSString*)formatTimeWithDate:(NSDate *) date
{
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

+(NSURL*)URLforCategory:(PollCategory) category;
{
    NSURL* url;
    switch (category) {
        case Accessory: url = [NSURL URLWithString:@""];
            break;
        case Apparel:
            break;
        case Automotive:
            break;
        case Food:
            break;
        case Electronics:
            break;
        case Others:
            break;
        default:
            break;
    }
    return url;
}
@end
