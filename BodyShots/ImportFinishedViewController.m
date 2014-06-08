#import "ImportFinishedViewController.h"

@interface ImportFinishedViewController ()

@end

@implementation ImportFinishedViewController

- (IBAction)finished:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationItem setHidesBackButton:YES animated:YES];
}

@end
