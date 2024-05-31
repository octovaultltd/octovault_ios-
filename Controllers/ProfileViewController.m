//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"
#import "KSToastView.h"
#import "KLCPopup.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:0];
    item1.image = [[UIImage imageNamed:@"1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"111"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:1];
    item2.image = [[UIImage imageNamed:@"2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"222"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:2];
    item3.image = [[UIImage imageNamed:@"3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"333"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    self.subscriptionview.layer.cornerRadius = 16;
    self.subscriptionborder.layer.cornerRadius = 16;
    self.settingview.layer.cornerRadius = 16;
    self.settingborder.layer.cornerRadius = 16;
    self.supportview.layer.cornerRadius = 16;
    self.supportborder.layer.cornerRadius = 16;
    self.logout1.layer.cornerRadius = 25;
    self.logout2.layer.cornerRadius = 25;
    self.logout2border.layer.cornerRadius = 25;
    self.btnlogout.layer.cornerRadius = 25;
    
    self.btnlogout.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnlogout.layer.borderWidth = 1.5;
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *user = [keychain stringForKey:@"username"];
    if([user containsString:@"HR4411-"]){
        NSString *strimedUsername = [user stringByReplacingOccurrencesOfString:@"HR4411-" withString:@""];
        self.lbluserid.text = strimedUsername;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* userType = [defaults valueForKey:@"userType"];
    NSString* expireindays = [defaults valueForKey:@"expireInDays"];
    
    if([userType isEqualToString: @"1"] || [userType isEqualToString: @"2"]){
        self.subscriptionview.backgroundColor = [UIColor colorNamed:@"orangecolor"];
        self.subscriptionborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
        self.imgsubs.image = [UIImage imageNamed:@"icosubactive"];
        self.lblsubscription.textColor = [UIColor colorNamed:@"olivecolor"];
        self.lblsubsextra.textColor = [UIColor colorNamed:@"olive2color"];
        self.lblsubsextra.text = [NSString stringWithFormat: @"%@ days until expire.", expireindays];
        self.logout2.hidden = true;
        self.logout1.hidden = false;
    }else{
        self.subscriptionview.backgroundColor = [UIColor colorNamed:@"white10%"];
        self.subscriptionborder.backgroundColor = [UIColor colorNamed:@"blackcolor"];
        self.imgsubs.image = [UIImage imageNamed:@"icosubinactive"];
        self.lbluserid.textColor = [UIColor whiteColor];
        self.lblsubsextra.textColor = [UIColor colorNamed:@"redcolor"];
        self.lblsubsextra.text = @"You don’t have any active subscription.";
        self.logout2.hidden = true;
        self.logout1.hidden = false;
    }
    
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        self.logout1.hidden = true;
        self.logout2.hidden = true;
        self.logout2border.hidden = true;
        self.btnlogout.hidden = true;
        self.lblsubsextra.text = @"Free User";
        
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction)subscriptiontapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *usertype = [defaults valueForKey:@"userType"];
    NSString* userStatus = [defaults valueForKey:@"userStatus"];
    NSString* expireindays = [defaults valueForKey:@"expireInDays"];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *pricingViewController = [storyboard instantiateViewControllerWithIdentifier:@"PricingViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = pricingViewController;
    }else{
        if([usertype isEqualToString: @"1"] && [userStatus isEqualToString: @"1"]){
            [KSToastView ks_showToast: [NSString stringWithFormat: @"%@ days until expire.", expireindays] duration:3.0f];
        }else if ([usertype isEqualToString: @"2"] && [userStatus isEqualToString: @"1"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *subscriptionViewController = [storyboard instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = subscriptionViewController;
        }else if ([usertype isEqualToString: @"3"] && [userStatus isEqualToString: @"1"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *pricingViewController = [storyboard instantiateViewControllerWithIdentifier:@"PricingViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = pricingViewController;
        }else if (([usertype isEqualToString: @"1"] || [usertype isEqualToString: @"2"] || [usertype isEqualToString: @"3"]) && [userStatus isEqualToString: @"3"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *pricingViewController = [storyboard instantiateViewControllerWithIdentifier:@"PricingViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = pricingViewController;
        }
    }
}

-(IBAction)settingtapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = settingsViewController;
    });
}

-(IBAction)devicetapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
//        [self signInAlert];
        [KSToastView ks_showToast:@"Locked for Geust Login"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *deviceViewController = [storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = deviceViewController;
        });
    }
}

-(IBAction)refertapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
//        [self signInAlert];
        [KSToastView ks_showToast:@"Locked for Geust Login"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *refer1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"Refer1ViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = refer1ViewController;
        });
    }
}

-(IBAction)supporttapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *supportViewController = [storyboard instantiateViewControllerWithIdentifier:@"SupportViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = supportViewController;
    });
}

-(IBAction)aboutustapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *aboutusViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = aboutusViewController;
    });
}

-(IBAction)logouttapped:(id)sender{    
    [self showLogoutConfirmAlert];
}

-(void)showLogoutConfirmAlert{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 15.0;

    UILabel* labelTitle = [[UILabel alloc] init];
    labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.numberOfLines = 0;
    labelTitle.text = @"Are you sure you want to Logout?";

    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    cancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 15.0;
    [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.translatesAutoresizingMaskIntoConstraints = NO;
    okButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    okButton.backgroundColor = [UIColor colorNamed:@"E84E4E"];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[[okButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 15.0;
    [okButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:labelTitle];
    [contentView addSubview:okButton];
    [contentView addSubview:cancelButton];

    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, labelTitle, okButton, cancelButton);

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[labelTitle]-(20)-[okButton]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[labelTitle]-(20)-[cancelButton]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[labelTitle]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[okButton]-(20)-[cancelButton]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[labelTitle(==250)][okButton(==120)][cancelButton(==120)]"
                                             options:0
                                             metrics:nil
                                               views:views]];

    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];

    [popup show];
}

- (void)cancelPressed:(id)sender {
    [sender dismissPresentingPopup];
}

- (void)logout:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isLoggedIn"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutNotification" object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *feedbackViewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = feedbackViewController;
    });
}

//-(void)signInAlert{
//    UIView* contentView = [[UIView alloc] init];
//    contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    contentView.backgroundColor = [UIColor whiteColor];
//    contentView.layer.cornerRadius = 15.0;
//
//    UILabel* labelTitle = [[UILabel alloc] init];
//    labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor blackColor];
//    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.numberOfLines = 0;
//    labelTitle.text = @"Sign-up or Login to enable this feature.";
//
//    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
//    cancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
//    cancelButton.backgroundColor = [UIColor grayColor];
//    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [cancelButton setTitle:NSLocalizedString(@"CANCEL", @"") forState:UIControlStateNormal];
//    cancelButton.layer.cornerRadius = 15.0;
//    [cancelButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    okButton.translatesAutoresizingMaskIntoConstraints = NO;
//    okButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
//    okButton.backgroundColor = [UIColor colorNamed:@"E84E4E"];
//    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [okButton setTitleColor:[[okButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [okButton setTitle:@"ENABLE" forState:UIControlStateNormal];
//    okButton.layer.cornerRadius = 15.0;
//    [okButton addTarget:self action:@selector(enableCalled:) forControlEvents:UIControlEventTouchUpInside];
//
//    [contentView addSubview:labelTitle];
//    [contentView addSubview:okButton];
//    [contentView addSubview:cancelButton];
//
//    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, labelTitle, okButton, cancelButton);
//
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[labelTitle]-(20)-[okButton]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[labelTitle]-(20)-[cancelButton]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[labelTitle]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[okButton]-(20)-[cancelButton]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[labelTitle(==250)][okButton(==120)][cancelButton(==120)]"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
//
//    [popup show];
//}
//
//- (void)dismissButtonPressed:(id)sender {
//    [sender dismissPresentingPopup];
//}
//
//- (void)enableCalled:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *splitViewController = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
//        [AppDelegate sharedAppDelegate].window.rootViewController = splitViewController;
//    });
//}

@end
