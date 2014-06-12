#import "Photo.h"

@interface NSDate(DaySuffix)
- (NSString *)daySuffix;
@end

@implementation NSDate(DaySuffix)

- (NSString *)daySuffix {
  NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSDayCalendarUnit fromDate:self] day];
  if (day >= 11 && day <= 13) {
    return @"th";
  } else if (day % 10 == 1) {
    return @"st";
  } else if (day % 10 == 2) {
    return @"nd";
  } else if (day % 10 == 3) {
    return @"rd";
  } else {
    return @"th";
  }
}


@end

@implementation Photo

@synthesize date, path;

- (NSString*) shortDate {
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"d"];
  NSString *dayString = [dateFormatter stringFromDate:self.date];
  
  [dateFormatter setDateFormat:@"MMMM"];
  NSString *monthString = [dateFormatter stringFromDate:self.date];
  
  NSString* suffixedDate = [NSString stringWithFormat:@"%@%@ %@", dayString, self.date.daySuffix, monthString];
  return suffixedDate;
}

@end
