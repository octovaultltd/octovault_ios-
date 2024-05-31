//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "Refer1ViewController.h"
#import "AppDelegate.h"

@interface Refer1ViewController ()

@end

@implementation Refer1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btngetstarted.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    self.backview.layer.cornerRadius = 25;
    self.tableview.layer.cornerRadius = 10;
    self.tableborder.layer.cornerRadius = 10;
    
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction)backbtnTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    });}

-(IBAction)getstartedbtnTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *refer2ViewController = [storyboard instantiateViewControllerWithIdentifier:@"Refer2ViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = refer2ViewController;
    });
}

@end
