#import "TestJpg.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation TestJpg

- (instancetype)init
{
  self = [super init];
  if (self) {
    exif = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)writeToPath:(NSString*)outputPath {
  NSMutableDictionary* metadata = [NSMutableDictionary dictionary];
  
  CFMutableDictionaryRef mutable = CFDictionaryCreateMutableCopy(NULL, 0, (__bridge CFDictionaryRef) metadata);
  CFDictionarySetValue(mutable, kCGImagePropertyExifDictionary, (__bridge void *)exif);
  
  NSData* jpeg =  UIImageJPEGRepresentation([UIImage imageNamed:@"dummy.150x200"], 1.0f);
  
  CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
  CFStringRef UTI = CGImageSourceGetType(source);
  
  NSMutableData *destinationData = [NSMutableData data];
  CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)destinationData, UTI, 1, NULL);
  
  CGImageDestinationAddImageFromSource(destination, source, 0, (CFDictionaryRef)mutable);
  CGImageDestinationFinalize(destination);
  
  [destinationData writeToFile:outputPath atomically:YES];
}

- (void)setExifValue:(NSString*)value forKey:(const CFStringRef)exifKey {
  [exif setValue:value forKey:(__bridge NSString*)exifKey];
}

@end
