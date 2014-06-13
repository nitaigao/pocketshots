#import <Foundation/Foundation.h>

@interface NSDate(DateFromString)

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;
+ (NSDate *)dateFromExifString:(NSString *)dateString;

@end