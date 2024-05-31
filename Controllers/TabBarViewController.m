//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "TabBarViewController.h"
#import "HexColors.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;

//    [self.tabBar setBarTintColor:[UIColor colorWithHexString:@"222222"]];
//    self.tabBar.tintColor = [UIColor colorWithHexString:@"orangecolor"];
//    self.tabBar.unselectedItemTintColor = [UIColor blueColor];
//
//    self.tabBarItem.badgeColor = [UIColor colorNamed:@"redcolor"];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
//    [[UITabBar appearance] setAlpha:0.25];
    
}



-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



@end
