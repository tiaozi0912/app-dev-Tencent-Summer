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
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    /*title.shadowColor = [Utility colorFromKuler:KULER_YELLOW alpha:1];
    title.shadowOffset = CGSizeMake(3, 3);*/
    title.textAlignment = UITextAlignmentCenter;
    title.textColor = [UIColor blackColor]; // change this color
    title.text = titleText;
    [title sizeToFit];
    return title;
}

+(NSString*)formatTimeWithDate:(NSDate *) date
{
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

+(NSURL*)URLForCategory:(PollCategory) category;
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

+(UIImage*)iconForCategory:(PollCategory) category
{
    NSString *imageName;
    switch (category) {
        case Accessory: imageName = @"Accessories.png";
            break;
        case Apparel: imageName = @"Apparel.png";
            break;
        case Automotive: imageName = @"Automotive.png";
            break;
        case Food: imageName = @"Food.png";
            break;
        case Electronics: imageName = @"Electronics.png";
            break;
        case Others: imageName = @"Others.png";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

+(NSString*)stringFromCategory:(PollCategory) category
{
    switch (category) {
        case Accessory: return @"Accessory";
        case Apparel:return @"Apparel";
        case Automotive:return @"Automotive";
        case Food:return @"Food";
        case Electronics:return @"Electronics";
        default:return @"Others";
    }
}

+(PollCategory)categoryFromString:(NSString*) string
{
    if ([string isEqualToString:@"Accessory"]){
        return Accessory;
    }else if ([string isEqualToString:@"Apparel"]){
        return Apparel;
    }else if ([string isEqualToString:@"Automotive"]){
        return Automotive;
    }else if ([string isEqualToString:@"Food"]){
        return Food;
    }else if ([string isEqualToString:@"Electronics"]){
        return Electronics;
    }else {
        return Others;
    }
}

+ (UIBarButtonItem *)createSquareBarButtonItemWithNormalStateImage:(NSString*)normalStateImage
                                          andHighlightedStateImage:(NSString*) highlightedStateImage
                                                            target:(id)tgt
                                                            action:(SEL)a
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:normalStateImage] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:highlightedStateImage] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    /*[[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];*/
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size = buttonImage.size;
    [button setFrame:buttonFrame];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    
    //[button setTitle:t forState:UIControlStateNormal];
    
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return buttonItem;
}

+(UIColor*)colorFromKuler:(int)kulerColor
                    alpha:(CGFloat)a
{
    switch (kulerColor) {
        case KULER_YELLOW:return [UIColor colorWithRed:246 green:247 blue:146 alpha:a];
        case KULER_BLACK:return [UIColor colorWithRed:51  green:55 blue:69 alpha:a];
        case KULER_CYAN:return [UIColor colorWithRed:119 green:196 blue:211 alpha:a];
        case KULER_WHITE:return [UIColor colorWithRed:218 green:237 blue:226 alpha:a];
        case KULER_RED:return [UIColor colorWithRed:234 green:46 blue:73 alpha:a];
        default:return [UIColor clearColor];
    }
}

+(UIToolbar*)keyboardAccessoryToolBarWithButton:(NSString*)title
                                         target:(id) t
                                         action:(SEL) a
{
    UIToolbar *keyboardAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    keyboardAccessoryView.barStyle = UIBarStyleBlackTranslucent;
    keyboardAccessoryView.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:t action:a];
    doneButton.title = title;
    [keyboardAccessoryView setItems:[NSArray arrayWithObjects: flexSpace, doneButton, nil] animated:NO];
    return keyboardAccessoryView;
}

+(NSString*)stringFromPollState:(int) state
{
    switch (state) {
        case EDITING:
            return @"EDITING";
        case VOTING:
            return @"VOTING";
        case FINISHED:
            return @"FINISHED";
        default:
            return @"UNKNOWN";
    }
}

+(NSString*)formatURLFromDateString:(NSString*) string
{
    NSMutableString *result = [string mutableCopy];
    [result replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, result.length)];
    return result;
}
@end
