//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SplashViewController.h"
#import <NetworkExtension/NEVPNManager.h>
#import <NetworkExtension/NEVPNProtocolIKEv2.h>
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NETunnelProviderProtocol.h>
#import <NetworkExtension/NEVPNConnection.h>
#import "UIViewController+LGSideMenuController.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
#import <OneSignal/OneSignal.h>
#import <UICKeyChainStore.h>
#import "MBProgressHUD.h"



@interface SplashViewController ()

@end

@implementation SplashViewController{
    NSUserDefaults* defaults;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
     return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self goToNextViewController];
}

-(void) goToNextViewController{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLoggedIn = [defaults boolForKey:@"isLoggedIn"];
    BOOL intro = [defaults boolForKey:@"endIntro"];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    
    if(isLoggedIn){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = tabBarController;
        });
    }else{
        if(intro){
            if(!realUser){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                    [AppDelegate sharedAppDelegate].window.rootViewController = tabBarController;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *splitViewController = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
                    [AppDelegate sharedAppDelegate].window.rootViewController = splitViewController;
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController1"];
                [AppDelegate sharedAppDelegate].window.rootViewController = vc;
            });
        }
    }
}


@end
