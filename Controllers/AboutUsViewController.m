//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController{
    NSUserDefaults* defaults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainview.layer.cornerRadius = 10;
    self.mainborder.layer.cornerRadius = 10;
    self.termview.layer.cornerRadius = 10;
    self.termborder.layer.cornerRadius = 10;
    self.backview.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    
    [self termcheckCheck];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)backbtnTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle {
     return UIStatusBarStyleLightContent;
}

- (IBAction)termToogleTapped:(id)sender {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:@"flag"];
    if (flag) {
        [defaults setBool:NO forKey:@"flag"];
    } else {
        [defaults setBool:YES forKey:@"flag"];
    }
    [defaults synchronize];
    [self termcheckCheck];
}

-(void)termcheckCheck{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:@"flag"];
    if (flag) {
        self.termimage.image = [UIImage imageNamed:@"icorowmax"];
        self.termHeight.constant = 0;
        self.termDetailsView.hidden = true;
    } else {
        self.termimage.image = [UIImage imageNamed:@"icorowmin"];
        self.termHeight.constant = 150;
        self.termDetailsView.hidden = false;
    }
}

- (IBAction)privacyPolicyButtonTapped:(id)sender {
//    NSString *url = @"google.com";
//    [self openWebView:@"Privacy Policy" andURL:url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/privacy_policy.html"]];
}

- (IBAction)disclaimerButtonTapped:(id)sender {
//    NSString *url = @"google.com";
//    [self openWebView:@"Disclaimer" andURL:url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/disclaimer.html"]];
}

- (IBAction)termsofServiceButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/term_of_service.html"]];
}

- (IBAction)refundPolicyButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/refund_policy.html"]];

}


- (IBAction)openInstagram:(id)sender{
    NSLog(@"Instagram Clicked");
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://instagram.com/octovault?igshid=YmMyMTA2M2Y="]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://instagram.com/octovault?igshid=YmMyMTA2M2Y="]];
    }
}

- (IBAction)openFacebook:(id)sender{
    NSLog(@"Facebook Clicked");
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/ScyberVPNHub"]];
    }else {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/ScyberVPNHub"]];
    }
}

- (IBAction)openTwitter:(id)sender{
    NSLog(@"Twitter Clicked");
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/octo_vault"]];
    }else {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/octo_vault"]];
    }
}

-(void)openWebView:(NSString*)title andURL:(NSString*)url{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *webNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    WebViewController *webViewController = (WebViewController*)webNavigationController.viewControllers.firstObject;
    webViewController.title = title;
    webViewController.url = url;
    [self presentViewController:webNavigationController animated:YES completion:nil];
}

@end
