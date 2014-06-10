#import "NSFileManager+Filename.h"

@implementation NSFileManager(Filename)

+ (NSString*)uniqueFileName {
  CFUUIDRef uuid = CFUUIDCreate(NULL);
  CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
  CFRelease(uuid);
  NSString *uniqueFileName = [NSString stringWithFormat:@"%@", (__bridge NSString*)uuidString];
  CFRelease(uuidString);
  
  return uniqueFileName;
}

@end
