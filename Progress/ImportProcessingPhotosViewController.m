#import "ImportProcessingPhotosViewController.h"

#import "PhotoAlbum.h"
#import "NSBundle+Documents.h"

@interface ImportProcessingPhotosViewController ()

@end

@implementation ImportProcessingPhotosViewController

@synthesize progressBar;

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    photosToProcess = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addPhotosToProcess:(NSArray*)photos {
  [photosToProcess removeAllObjects];
  [photosToProcess addObjectsFromArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)updateProgress:(NSNumber*)progress {
  [progressBar setProgress:progress.floatValue animated:YES];
}

- (void)importFinished:(NSObject*)object {
  [self performSegueWithIdentifier:@"import_finished" sender:self];
}

- (void)processPhotos:(NSArray*)photos {
  PhotoAlbum* photoAlbum = [PhotoAlbum albumWithDirectory:[NSBundle mainBundle].documentsPath];
  
  [photoAlbum importPhotos:photosToProcess progress:^(float progress) {
    NSLog(@"%f", progress);
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:YES];
  } complete:^{
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:1.0f] waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(importFinished:) withObject:nil waitUntilDone:YES];
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [self performSelectorInBackground:@selector(processPhotos:) withObject:photosToProcess];
}


@end
