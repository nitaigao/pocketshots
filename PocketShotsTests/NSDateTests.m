#import <XCTest/XCTest.h>

@interface NSDateTests : XCTestCase

@end

@implementation NSDateTests

- (void)testTwoDatesSortCorrectly {
  
  NSMutableArray* randomDates = [NSMutableArray array];
  for (NSInteger i = 0; i < 100; i++) {
    NSInteger randomNumber = arc4random() % 1600;
    NSDate* randomDate = [NSDate dateWithTimeIntervalSince1970:randomNumber * randomNumber];
    [randomDates addObject:randomDate];
  }
  
  NSArray* sortedDates = [randomDates sortedArrayUsingComparator:^NSComparisonResult(NSDate* a, NSDate* b) {
    return [a compare:b];
  }];
  
  [sortedDates enumerateObjectsUsingBlock:^(NSDate* date, NSUInteger idx, BOOL *stop) {
    if (idx > 0) {
      NSInteger previousIndex = idx - 1;
      NSDate* previousDate = [sortedDates objectAtIndex:previousIndex];
      NSComparisonResult comparisonResult = [date compare:previousDate];
      NSLog(@"%ld %ld, %@ %@", idx, idx - 1, previousDate, date);
      XCTAssertTrue(comparisonResult == NSOrderedDescending || comparisonResult == NSOrderedSame, @"Dates arent sorted!");
    }
  }];
}

@end
