#import <UIKit/UIKit.h>

@interface TimelineViewController : UIPageViewController<UIPageViewControllerDataSource> {
  NSMutableArray* controllers;
}

@end
