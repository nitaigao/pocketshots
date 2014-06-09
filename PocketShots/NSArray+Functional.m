#import "NSArray+Functional.h"

@implementation NSArray(Functional)

- (void)each:(void (^)(id element, NSInteger index, NSInteger total))iterator {
  NSInteger index = 0;
  for (id element in self) {
    iterator(element, index++, self.count);
  }
}

- (void)each:(void (^)(id element, NSInteger index, NSInteger total))iterator complete:(void(^)())complete {
  NSInteger index = 0;
  for (id element in self) {
    iterator(element, index++, self.count);
    
    if (index == self.count) {
      complete();
    }
  }
}


@end
