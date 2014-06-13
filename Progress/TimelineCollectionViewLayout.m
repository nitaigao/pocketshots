#import "TimelineCollectionViewLayout.h"

@implementation TimelineCollectionViewLayout

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
  return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
  
//  CGFloat y = cell.center.y;
//  cell.center = CGPointMake(cell.center.x, cell.center.y + 500);
//  [UIView animateWithDuration:0.75 animations:^{
//    cell.center = CGPointMake(cell.center.x, y);
//  }];

}


@end
