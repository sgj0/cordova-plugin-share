#import "MMShare.h"
#import <Cordova/CDV.h>

@implementation MMShare

- (void)share:(CDVInvokedUrlCommand*)command
{
    NSString* text = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
    NSString* title = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];

    if (text == nil || [text length] == 0) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"Empty text cannot be shared."];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityViewController* activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:@[text]
                                              applicationActivities:nil];

        if (title != nil && [title length] > 0) {
            [activityViewController setValue:title forKey:@"subject"];
        }

        if (activityViewController.popoverPresentationController != nil) {
            UIView* sourceView = self.webView;
            activityViewController.popoverPresentationController.sourceView = sourceView;
            activityViewController.popoverPresentationController.sourceRect =
                CGRectMake(CGRectGetMidX(sourceView.bounds), CGRectGetMidY(sourceView.bounds), 0, 0);
            activityViewController.popoverPresentationController.permittedArrowDirections = 0;
        }

        [self.viewController presentViewController:activityViewController animated:YES completion:^{
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    });
}

@end