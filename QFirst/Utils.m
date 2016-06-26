//
//  Utils.m
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ConstantValues.h"
#import "Reachability.h"

@implementation Utils

+ (BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (CGRect)screenBounds {
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        screenRect = CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    } else {
        screenRect = screen.bounds;
    }
    
    return screenRect;
}

+ (NSString*) removeWhiteSpace:(NSString *)str{
    if([Utils IsEmpty:str]){
        return @"";
    }
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (BOOL) IsEmpty:(id)thing {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0)
    || [thing isEqual: [NSNull null]];
}

+ (BOOL)isValidEmail:(NSString *) emailStr{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

+ (BOOL)isNumber:(NSString *)string{
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];
    return [numberPredicate evaluateWithObject:string];
}

+ (BOOL)isSingaporeMobileNo:(NSString *)mobileNumber{
    NSString *phoneRegex = @"^(((0|((\\+)?65([- ])?))|((\\((\\+)?65\\)([- ])?)))?[8-9]\\d{7})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNumber];
}

+ (BOOL)isSingaporeContactNo:(NSString *)contactNumber{
    NSString *phoneRegex = @"^(((0|((\\+)?65([- ])?))|((\\((\\+)?65\\)([- ])?)))?[6-9]\\d{7})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:contactNumber];
}

+ (NSString*) accessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [defaults objectForKey:@"access_token"];
    return accessToken;
}

+ (NSString*) mobile{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * mobile = [Utils IsEmpty:[defaults objectForKey:@"mobile"]] ? @"" : [defaults objectForKey:@"mobile"];
    return mobile;
}

+ (NSString*) ic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * ic = [Utils IsEmpty:[defaults objectForKey:@"ic"]] ? @"" : [defaults objectForKey:@"ic"];
    return ic;
}

+ (NSString*) email{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * email = [Utils IsEmpty:[defaults objectForKey:@"email"]] ? @"" : [defaults objectForKey:@"email"];
    return email;
}

+ (NSString*) name{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [Utils IsEmpty:[defaults objectForKey:@"name"]] ? @"" : [defaults objectForKey:@"name"];
    return name;
}

+ (NSString*) reserMobile{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * mobile = [Utils IsEmpty:[defaults objectForKey:@"reserv_mobile"]] ? @"" : [defaults objectForKey:@"reserv_mobile"];
    return mobile;
}

+ (NSString*) reserIc{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * ic = [Utils IsEmpty:[defaults objectForKey:@"reserv_ic"]] ? @"" : [defaults objectForKey:@"reserv_ic"];
    return ic;
}

+ (NSString*) reserEmail{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * email = [Utils IsEmpty:[defaults objectForKey:@"reserv_email"]] ? @"" : [defaults objectForKey:@"reserv_email"];
    return email;
}

+ (NSString*) reserName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [Utils IsEmpty:[defaults objectForKey:@"reserv_name"]] ? @"" : [defaults objectForKey:@"reserv_name"];
    return name;
}

+ (NSString *) getDateStringByDate: (NSDate*) date{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    return [dateFormater stringFromDate:date];
}

+ (NSDate *) getDateByDateString: (NSString*) dateString{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormater dateFromString:dateString];
    return date;
}

+ (NSString *) getDateTimeStringByDate: (NSDate*) date{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [dateFormater stringFromDate:date];
}

+ (NSDate *) getLocalDateFrom:(NSDate *) date{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    return destinationDate;
}

+(NSString *) getTimeString: (NSDate*) date{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"HH:mm"];
    return [dateFormater stringFromDate:date];
}

+(NSString *) getReadableDateString:(NSDate*) date{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEE, MMM d - HH:mm"];
    return [format stringFromDate:date];
}

+(bool) isSingaporeIC:(NSString *)ic{
    NSString *phoneRegex = @"^[STFG]\\d{7}[A-Z]$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:ic];
}

+(NSDate*) getStartDate: (NSDate *) date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
}


@end
