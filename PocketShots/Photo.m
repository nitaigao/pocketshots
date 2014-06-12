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
  
  NSString* suffixedDate = [NSString stringWithFormat:@"%@ %@%@", monthString, dayString, self.date.daySuffix];
  return suffixedDate;
}

- (NSAttributedString*) formattedDate {
  NSString* shortDate = self.shortDate;
  
  NSRegularExpression* regEx = [NSRegularExpression
                                regularExpressionWithPattern:@"^([A-Z])([A-Za-z]*) ([0-9]*)([a-z]*)"
                                options:0 error:nil];
  
  NSTextCheckingResult* result = [[regEx matchesInString:shortDate options:0 range:NSMakeRange(0, shortDate.length)] firstObject];
  NSRange monthFirstRange = [result rangeAtIndex:1];
  NSRange monthRemainderRange = [result rangeAtIndex:2];
  NSRange dayRange = [result rangeAtIndex:3];
  NSRange suffixRange = [result rangeAtIndex:4];
  
  NSMutableAttributedString *formattedDate = [[NSMutableAttributedString alloc] initWithString:shortDate];
  
  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:30.0]
                        range:dayRange];
  
  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:16.0]
                        range:suffixRange];
  
  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:24.0]
                        range:monthFirstRange];
  
  
  [formattedDate addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:21.0]
                        range:monthRemainderRange];

  return formattedDate;
}

@end
