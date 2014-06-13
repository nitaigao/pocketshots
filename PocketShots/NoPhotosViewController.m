#import "NoPhotosViewController.h"

@interface NoPhotosViewController ()

@end

@implementation NoPhotosViewController

@synthesize welcomeView, downArrow;

- (void)viewDidLoad {
  animating = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  welcomeView.center = CGPointMake(0, 1000);
}

- (void)animate {
  [UIView animateWithDuration: 1.0f
                   animations:^{
                     welcomeView.center = CGPointMake(welcomeView.center.x, [[UIScreen mainScreen] bounds].size.height - welcomeView.frame.size.height - 50);
                   } completion:^(BOOL finished) {
                     [self arrowBounce];
                   }];

}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  animating = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  animating = YES;
  [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
}

- (void)arrowBounce {
  if (!animating) {
    return;
  }
  
  CGFloat bounceTime = 0.5f;
  [UIView animateWithDuration:bounceTime animations:^{
    downArrow.center = CGPointMake(downArrow.center.x, downArrow.center.y + 10);
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:bounceTime animations:^{
      downArrow.center = CGPointMake(downArrow.center.x, downArrow.center.y - 10);
    } completion:^(BOOL finished) {
      [self arrowBounce];
    }];
  }];
}

@end
