#import "ViewController.h"

#import <MessageUI/MessageUI.h>

@interface ViewController () <MFMailComposeViewControllerDelegate>
@end

@implementation ViewController

#pragma mark UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  MFMailComposeViewController *composeViewController =
      [[MFMailComposeViewController alloc] init];
  [composeViewController setSubject:@"[TODO]"];
  [composeViewController setToRecipients:@[ @"[YOU@PROVIDER.COM]" ]];
  composeViewController.mailComposeDelegate = self;

  [self presentViewController:composeViewController
                     animated:YES
                   completion:NULL];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
