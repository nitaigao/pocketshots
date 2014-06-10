#import "NSDate+DateFromString.h"

@implementation NSDate(DateFromString)

+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)dateFormat {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  
  NSDate *date = [dateFormatter dateFromString:dateString];
  return date;
}

@end
