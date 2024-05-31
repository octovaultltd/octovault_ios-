//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "IntroViewController1.h"
#import "AppDelegate.h"

@interface IntroViewController1 (){
    NSUserDefaults *defaults;
}
@end

@implementation IntroViewController1


- (void)viewDidLoad {
    [super viewDidLoad];
    [self logoCheck];
}

-(IBAction)btnnexttapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *introViewController2 = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController2"];
        [AppDelegate sharedAppDelegate].window.rootViewController = introViewController2;
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

@end
