#import <Foundation/Foundation.h>

@interface NSArray(Functional)

- (void)each:(void (^)(id, NSInteger, NSInteger))iterator;
- (void)each:(void (^)(id, NSInteger, NSInteger))iterator complete:(void(^)())complete;

@end