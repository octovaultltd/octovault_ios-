//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SubscriptionViewController.h"
#import "AppDelegate.h"

@interface SubscriptionViewController (){
    NSArray *title;
    NSArray *price;
    NSArray *packageID;
    NSArray *subTitle;
    NSArray *inAppData;
}

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.terminateview.hidden = true;
    self.terminateHC.constant = 0;
    self.renewView.hidden = true;
    self.renewalHC.constant = 0;
    
    self.subscriptionimage.layer.cornerRadius = 10;
    self.upgradeview.layer.cornerRadius = 10;
    self.upgradeborder.layer.cornerRadius = 10;
    self.terminateview.layer.cornerRadius = 10;
    self.terminateborder.layer.cornerRadius = 10;
    self.btnback.layer.cornerRadius = 25;
    self.backview.layer.cornerRadius = 25;
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
    
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)updateUI{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *planID = [defaults valueForKey:@"planId"];
    NSString* expireindays = [defaults valueForKey:@"expireInDays"];
    
    self.subscriptionExpiry.text = [NSString stringWithFormat: @"%@ days until expire.", expireindays];
    
    title = [defaults objectForKey:@"title"];
    price = [defaults objectForKey:@"price"];
    subTitle = [defaults objectForKey:@"subTitle"];
    
    NSLog(@"subscription details: %@ %@ %@ %@ %@", planID, expireindays, title, price,subTitle);
    
    if([planID isEqualToString:@"19716"]){
        self.subscriptionTitle.text = [NSString stringWithFormat:@"%@", title[0]];
        self.subscriptionPrice.text = [NSString stringWithFormat:@"%@", price[0]];
        self.subscriptionSubTitle.text = [NSString stringWithFormat: @"/monthly"];
    }else if ([planID isEqualToString:@"19720"]){
        self.subscriptionTitle.text = [NSString stringWithFormat:@"%@", title[1]];
        self.subscriptionPrice.text = [NSString stringWithFormat:@"%@", price[1]];
        self.subscriptionSubTitle.text = [NSString stringWithFormat: @"/monthly %@", subTitle[1]];
    }else if ([planID isEqualToString:@"19721"]){
        self.subscriptionTitle.text = [NSString stringWithFormat:@"%@", title[2]];
        self.subscriptionPrice.text = [NSString stringWithFormat:@"%@", price[2]];
        self.subscriptionSubTitle.text = [NSString stringWithFormat: @"/monthly %@", subTitle[2]];
    }else if ([planID isEqualToString:@"19722"]){
        self.subscriptionTitle.text = [NSString stringWithFormat:@"%@", title[3]];
        self.subscriptionPrice.text = [NSString stringWithFormat:@"%@", price[3]];
        self.subscriptionSubTitle.text = [NSString stringWithFormat: @"/monthly %@", subTitle[3]];
    }else if([planID isEqualToString:@"20742"]){
        self.subscriptionTitle.text = @"Sign Up Plan";
        self.subscriptionPrice.text = @"Free";
        self.subscriptionSubTitle.text = @"";
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction)backbtnTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    });
}

-(IBAction)upgradeBtnTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *pricingViewController = [storyboard instantiateViewControllerWithIdentifier:@"PricingViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = pricingViewController;
    });
}

@end
