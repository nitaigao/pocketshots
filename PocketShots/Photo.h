#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* path;

@property (nonatomic, readonly) NSString* shortDate;

@end
