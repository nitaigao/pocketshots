#import "Exif.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "NSDate+DateFromString.h"

@implementation Exif

- (instancetype)initWithFile:(NSString*)aFilePath {
  self = [super init];
  if (self) {
    filePath = aFilePath;
  }
  return self;
}

- (NSDate*) digitizedDate {
  NSURL* photoURL = [NSURL fileURLWithPath:filePath];
  CFStringRef fullPathEscaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[photoURL absoluteString], NULL, NULL, kCFStringEncodingUTF8);
  CFURLRef urlRef = CFURLCreateWithString(NULL, fullPathEscaped, NULL);
  CGImageSourceRef sourceRef = CGImageSourceCreateWithURL(urlRef, NULL);
  
  NSDate *digitizedDate = [NSDate date];
  
  CFDictionaryRef metadata = CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL);
  if (NULL != metadata) {

    CFDictionaryRef exifData = CFDictionaryGetValue(metadata, kCGImagePropertyExifDictionary);
    if (NULL != exifData) {
      
      CFStringRef digitizedDateRaw = CFDictionaryGetValue(exifData, kCGImagePropertyExifDateTimeDigitized);
      NSString* digitizedDateString = (__bridge NSString*)digitizedDateRaw;

      if (digitizedDateString) {
        digitizedDate = [NSDate dateFromString:digitizedDateString withFormat:@"yyyy:MM:dd HH:mm:ss"];
      }
    }
  }
  
  return digitizedDate;
}

@end
