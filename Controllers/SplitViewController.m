//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SplitViewController.h"
#import "AppDelegate.h"
@interface SplitViewController ()

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self logoCheck];
}

-(void)viewWillAppear:(BOOL)animated{
    self.btnLogin.layer.cornerRadius = 25;
    self.btnLogin.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnLogin.layer.borderWidth = 1.5;
    
    self.btnSignup.layer.cornerRadius = 25;
}

-(IBAction)loginbtntapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = loginViewController;
    });
}

-(IBAction)signupbtntapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *signupViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = signupViewController;
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

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
