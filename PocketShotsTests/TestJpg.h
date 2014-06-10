#import <Foundation/Foundation.h>

@interface TestJpg : NSObject {
  NSMutableDictionary* exif;
}

- (void)writeToPath:(NSString*)outputPath;

- (void)setExifValue:(NSString*)value forKey:(const CFStringRef)exifKey;

@end
