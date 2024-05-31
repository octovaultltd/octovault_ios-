//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "FeedbackViewController.h"
#import "AppDelegate.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btndone.layer.cornerRadius = 25;
    self.btnrate.layer.cornerRadius = 25;
    self.backview.layer.cornerRadius =25;
    self.btndone.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btndone.layer.borderWidth = 1.5;
    
    [self logoCheck];
}

-(IBAction)donebtntapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = loginViewController;
    });
}

-(void)logoCheck{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:@"flag"];
    if (flag) {
        self.logo.image = [UIImage imageNamed:@"logobig"];
    } else {
        self.logo.image = [UIImage imageNamed:@"logo"];
    }
}

-(IBAction)logoTapped:(id)sender{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    BOOL flag = [defaults boolForKey:@"flag"];
    if (flag) {
        [defaults setBool:NO forKey:@"flag"];
    } else {
        [defaults setBool:YES forKey:@"flag"];
    }
    
    [self logoCheck];
}

-(IBAction)ratebtntapped:(id)sender{
    NSLog(@"joy rate btn tapped");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/ng/app/octovaultvpn/id6445982276"]];
}

@end
