//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Web View Loaded");
    
    self.labelTitle.text = self.title;
    NSURL *urlData = [NSURL URLWithString:self.url];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:urlData]];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
     return UIStatusBarStyleLightContent;
}

- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"Web View Loading Start");
    [self startSpinner];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"Web View Loading Finished");
    [self stopSpinner];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        NSURL *url = navigationAction.request.URL;
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:url]) {
                    [app openURL:url options:nil completionHandler: nil];
                }
      }
    decisionHandler(WKNavigationActionPolicyAllow);

}
//-------Start & Stop Spinner------//
-(void)startSpinner{
    [spinner setHidden:NO];
    spinner.lineWidth = 3;
    spinner.colorArray = [NSArray arrayWithObjects:[UIColor colorNamed:@"ColorRed"], nil];
    [spinner startAnimation];
}

-(void)stopSpinner{
    [spinner setHidden:YES];
    [spinner stopAnimation];
}

@end
