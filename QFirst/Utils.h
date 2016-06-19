//
//  Utils.h
//  FirstQ
//
//  Created by ChangmingNiu on 2/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (BOOL)connected;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (CGRect)screenBounds;

+ (BOOL) IsEmpty:(id)thing;

+ (NSString*) accessToken;

+ (NSString*) mobile;

+ (BOOL)isValidEmail:(NSString *) emailStr;

+ (BOOL)isNumber:(NSString *)string;

+ (BOOL)isSingaporeMobileNo:(NSString *)mobileNumber;

+(bool) isSingaporeIC:(NSString *)ic;

+ (NSString *) getDateStringByDate: (NSDate*) date;

+ (NSString *) getDateTimeStringByDate: (NSDate*) date;

+ (NSDate *) getDateByDateString: (NSString*) dateString;

+(NSDate*) getLocalDateFrom:(NSDate*) UTCDate;

+(NSString *) getTimeString: (NSDate*) date;

+(NSString *) getReadableDateString:(NSDate*) date;

+(NSDate*) getStartDate: (NSDate *) date;

@end
