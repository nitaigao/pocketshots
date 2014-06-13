#import "NSDate+DateFromString.h"

@implementation NSDate(DateFromString)

+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)dateFormat {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  
  NSDate *date = [dateFormatter dateFromString:dateString];
  return date;
}

+ (NSDate *)dateFromExifString:(NSString *)dateString {
  
  // Exif Date Format: yyyy:MM:dd HH:mm:ss
  NSString *yearString = [dateString substringWithRange:NSMakeRange(0, 4)];
  NSString *monthString = [dateString substringWithRange:NSMakeRange(5, 2)];
  NSString *dayString = [dateString substringWithRange:NSMakeRange(8, 2)];
  
  NSString *hourString = [dateString substringWithRange:NSMakeRange(11, 2)];
  NSString *minString = [dateString substringWithRange:NSMakeRange(14, 2)];
  NSString *secString = [dateString substringWithRange:NSMakeRange(17, 2)];
  
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setYear:[yearString intValue]];
  [comps setMonth:[monthString intValue]];
  [comps setDay:[dayString intValue]];
  [comps setHour:[hourString intValue]];
  [comps setMinute:[minString intValue]];
  [comps setSecond:[secString intValue]];
  
  NSDate *theDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
  return theDate;
}

@end
