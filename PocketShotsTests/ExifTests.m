#import <XCTest/XCTest.h>

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "NSBundle+Documents.h"
#import "NSFileManager+Filename.h"

#import "UIImage+Dummy.h"

#import "Exif.h"
#import "TestJpg.h"

@interface ExifTests : XCTestCase

@end

@implementation ExifTests

+ (NSString*)testPhotoPath {
  return [NSString stringWithFormat:@"%@/test.JPG", [NSBundle mainBundle].documentsPath];
}

- (void)setUp {
  [super setUp];
  
  TestJpg* testJpg = [[TestJpg alloc] init];
  
  NSDate* date = [NSDate dateWithTimeIntervalSince1970:10];
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyy:MM:dd HH:mm:ss"];
  NSString* dateString = [dateFormatter stringFromDate:date];
  [testJpg setExifValue:dateString forKey:kCGImagePropertyExifDateTimeDigitized];
  
  NSString* photoPath = [ExifTests testPhotoPath];
  [testJpg writeToPath:photoPath];
}

- (void)tearDown {
  [super tearDown];
  [[NSFileManager defaultManager] removeItemAtPath:[ExifTests testPhotoPath] error:nil];
}

- (void)testExifDigitizedDate {
  NSDate* date = [NSDate dateWithTimeIntervalSince1970:10];
  Exif* exif = [[Exif alloc] initWithFile:[ExifTests testPhotoPath]];
  NSComparisonResult comparisonResult = [exif.digitizedDate compare:date];
  XCTAssertTrue(comparisonResult == NSOrderedSame, @"Digitized date doesnt match test value");
}

@end
