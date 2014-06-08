#import "NoPhotosViewController.h"

@interface NoPhotosViewController ()

@end

@implementation NoPhotosViewController

@synthesize index;

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    self.index = 0;
  }
  return self;
}

- (void)viewDidAppear:(BOOL)animated {
  [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)purge {
  
}

@end
