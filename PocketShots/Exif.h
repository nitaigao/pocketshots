#import <Foundation/Foundation.h>

@interface Exif : NSObject {
  NSString* filePath;
}

- (instancetype)initWithFile:(NSString*)filePath;

@property (nonatomic, readonly) NSDate* digitizedDate;

@end
