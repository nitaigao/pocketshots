#import "Photo.h"

@implementation Photo

@synthesize date, path;

- (NSString*) shortDate {
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd/MM/yyyy"];
  NSString *dateString = [dateFormatter stringFromDate:self.date];
  return dateString;
}

@end
