#import "ShareViewController.h"

#import <MessageUI/MessageUI.h>

@interface ShareViewController () <MFMailComposeViewControllerDelegate>
@end

@implementation ShareViewController

#pragma mark UIViewController

- (id)init {
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(didReceiveKeyboardWillShowNotification:)
               name:UIKeyboardWillShowNotification
             object:nil];
  }

  return self;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
  // Avoid showing the post dialog.
  self.view.hidden = YES;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
  self.view.hidden = NO;
}

#pragma mark SLComposeServiceViewController

- (BOOL)isContentValid {
  return YES;
}

- (void)didSelectPost {
  // Not needed. Delete.
}

- (NSArray *)configurationItems {
  MFMailComposeViewController *composeViewController =
      [[MFMailComposeViewController alloc] init];

  if (!self.extensionContext.inputItems.count) {
    NSLog(@"Bail. Need at least one input item.");
    return @[];
  }

  NSItemProvider *itemProvider =
      ((NSExtensionItem *)self.extensionContext.inputItems[0]).attachments[0];

  if (![itemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {
    NSLog(@"Bail. Only interested in URLs.");
    return @[];
  }

  [itemProvider
      loadItemForTypeIdentifier:@"public.url"
                        options:nil
              completionHandler:^(NSURL *url, NSError *error) {
                NSString *URLString = url.absoluteString;

                [composeViewController setSubject:@"[TODO]"];
                [composeViewController setMessageBody:URLString isHTML:NO];

                [composeViewController
                    setToRecipients:@[ @"[YOU@PROVIDER.COM]" ]];

                composeViewController.mailComposeDelegate = self;

                [self presentViewController:composeViewController
                                   animated:YES
                                 completion:^(){
                                 }];
              }];

  return @[];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  [self dismissViewControllerAnimated:YES
                           completion:^(void) {
                             [super didSelectPost];
                           }];
}

#pragma mark Private

- (void)didReceiveKeyboardWillShowNotification:(NSNotification *)note {
  // Dismiss the keyboard before it has had a chance to show up.
  [self.view endEditing:true];
}

@end
