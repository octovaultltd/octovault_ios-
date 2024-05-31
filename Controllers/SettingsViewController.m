//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import "SettingsViewController.h"
#import <OneSignal/OneSignal.h>
#import <NetworkExtension/NETunnelProviderManager.h>
#import "KLCPopup.h"
#import <UICKeyChainStore.h>
#import "Reachability.h"
#import "AFNetworking.h"
#import "KSToastView.h"
#import "JHNetworkSpeed.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    __block NETunnelProviderManager * vpnManager;
    NSUserDefaults* defaults;
}
@synthesize spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.notificationview.layer.cornerRadius = 10;
    self.notificationborder.layer.cornerRadius = 10;
    self.deletview.layer.cornerRadius = 10;
    self.deleteborder.layer.cornerRadius = 10;
    self.backview.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
    
    self.noty.hidden = true;
    self.notyHC.constant = 0;
    
    [self checkKillSwitchStatus];
    [self checkNotificationStatus];
}

-(void) checkKillSwitchStatus{
    if([defaults boolForKey:@"KillSwitchEnabled"]){
        self.killswitchimage.image = [UIImage imageNamed:@"icoslide2"];
    }else{
        self.killswitchimage.image = [UIImage imageNamed:@"icoslide"];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void) checkNotificationStatus{
    if ([OneSignal getDeviceState].isSubscribed) {
        self.notificationimage.image = [UIImage imageNamed:@"icoslide2"];
    }else{
        self.notificationimage.image = [UIImage imageNamed:@"icoslide"];
    }
}


- (IBAction)doneButtonTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    });
}

-(IBAction)notificationValueChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
//        [self signInAlert];
        [KSToastView ks_showToast:@"Locked for Geust Login"];
    }else{
        if (self.btnnotificationSwitch.enabled) {
            [self turnOnPushNotification];
        }else{
            [self turnOffPushNotification];
        }
    }
}

- (IBAction)killSwitchValueChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
//        [self signInAlert];
        [KSToastView ks_showToast:@"Locked for Geust Login"];
    }else{
        if([defaults boolForKey:@"KillSwitchEnabled"]){
            [defaults setBool:NO forKey:@"KillSwitchEnabled"];
            if([[defaults valueForKey:@"VPNType"] isEqualToString:@"Personal"]){
                __block NEVPNManager *vpnManagerPersonal;
                vpnManagerPersonal = [NEVPNManager sharedManager];
                [vpnManagerPersonal loadFromPreferencesWithCompletionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Settings Check Personal VPN Status : %@", error.localizedDescription);
                    }else{
                        if (vpnManagerPersonal.enabled) {
                            NEVPNConnection *cnn = [vpnManagerPersonal connection];
                            if (cnn.status == NEVPNStatusConnected) {
                                NEOnDemandRuleConnect* rule = [[NEOnDemandRuleConnect alloc] init];
                                rule.interfaceTypeMatch = NEOnDemandRuleInterfaceTypeAny;
                                NSArray* onDemandRules = [[NSArray alloc] initWithObjects:rule, nil];
                                [vpnManagerPersonal setOnDemandRules:onDemandRules];
                                [vpnManagerPersonal setOnDemandEnabled:YES];
                                [vpnManagerPersonal saveToPreferencesWithCompletionHandler:^(NSError *error){
                                    if (error != nil) {
                                        NSLog(@"Save to Preferences Error: %@", error);
                                    }else{
                                        NSLog(@"Save successfully");
                                    }
                                }];
                            }
                        }
                    }
                }];
            }else{
                __block NETunnelProviderManager * vpnManager;
                [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray* newManagers, NSError *error){
                    if(error != nil){
                        NSLog(@"Settings Check Enterprise VPN Status : %@", error.localizedDescription);
                    }else{
                        if([newManagers count] > 0){
                            vpnManager = newManagers[0];
                            if (vpnManager.enabled) {
                                NEVPNConnection *cnn = [vpnManager connection];
                                if (cnn.status == NEVPNStatusConnected){
                                    NEOnDemandRuleConnect* rule = [[NEOnDemandRuleConnect alloc] init];
                                    rule.interfaceTypeMatch = NEOnDemandRuleInterfaceTypeAny;
                                    NSArray* onDemandRules = [[NSArray alloc] initWithObjects:rule, nil];
                                    [vpnManager setOnDemandRules:onDemandRules];
                                    [vpnManager setOnDemandEnabled:YES];
                                    [vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error){
                                        if (error != nil) {
                                            NSLog(@"Save to Preferences Error: %@", error);
                                        }else{
                                            NSLog(@"Save successfully");
                                        }
                                    }];
                                }
                            }
                        }
                    }
                }];
            }
            [self checkKillSwitchStatus];
        }else{
            [defaults setBool:YES forKey:@"KillSwitchEnabled"];
            [self checkKillSwitchStatus];
        }
        [defaults synchronize];
    }
}

-(void) turnOffPushNotification{
    [OneSignal disablePush:YES];
}

-(void) turnOnPushNotification{
    [OneSignal disablePush:NO];
}

-(IBAction)deleteAccount:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        [KSToastView ks_showToast:@"Locked for Geust Login"];
//        [self signInAlert];
    }else{
        [self showDeleteConfirmAlert];
    }
}

-(void)showDeleteConfirmAlert{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 15.0;

    // Create Title Label
    UILabel* labelTitle = [[UILabel alloc] init];
    labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.numberOfLines = 0;
    labelTitle.text = @"Are you sure you want to permanently delete your account?";

    // Create Cancel Button
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    cancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [cancelButton setTitle:NSLocalizedString(@"CANCEL", @"") forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 15.0;
    [cancelButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // Create Ok Button
    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.translatesAutoresizingMaskIntoConstraints = NO;
    okButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    okButton.backgroundColor = [UIColor colorNamed:@"E84E4E"];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[[okButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [okButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 15.0;
    [okButton addTarget:self action:@selector(deleteCalled:) forControlEvents:UIControlEventTouchUpInside];

    // Add Views
    [contentView addSubview:labelTitle];
    [contentView addSubview:okButton];
    [contentView addSubview:cancelButton];

    // Add Constraints
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

- (void)dismissButtonPressed:(id)sender {
    [sender dismissPresentingPopup];
}

- (void)deleteCalled:(id)sender {
    [sender dismissPresentingPopup];
    
    if(![self reachable]){
        [KSToastView ks_showToast:NSLocalizedString(@"Please Check Your Internet Connection", @"") duration:3.0f];
        return;
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
//    NSString* url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/remove-user";
    NSString *url = @"https://dragonia.squarefootuni.store/remove_user.php";
    
    NSString *username = [keychain stringForKey:@"username"];
    NSString *password = [keychain stringForKey:@"password"];
    NSString *uuid = [keychain stringForKey:@"UUID"];
    
    
    // Call Delete API
    NSDictionary *params = @{@"username": username,
                             @"pass": password,
                             @"udid": uuid
    };
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [self startSpinner];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });
        
        if(responseObject != nil){
            
            double backgroundTime = [[NSDate date] timeIntervalSince1970];
            [self->defaults setDouble:backgroundTime forKey:@"backgroundTime"];
            [self->defaults synchronize];
            
            NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *responseData = [data dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            
            NSLog(@"delete data: %@", json);
            
            if(jsonError) {
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                [KSToastView ks_showToast:NSLocalizedString(@"JSON parsing error", @"") duration:3.0f];
            } else {
                NSLog(@"Delete Data : %@", json);
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                
                if([responseCode isEqualToString:@"1"]) {
                    [KSToastView ks_showToast:message duration:3.0f];
                    [self gotoSplit];
                }else{
                    [KSToastView ks_showToast:message duration:3.0f];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });
        [KSToastView ks_showToast:[error localizedDescription] duration:3.0f];
    }];
}

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

-(void)gotoSplit{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isLoggedIn"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutNotification" object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = vc;
    });
    
}

//-------Start & Stop Spinner------//
-(void)startSpinner
{
    [spinner setHidden:NO];
    spinner.lineWidth = 3;
    spinner.colorArray = [NSArray arrayWithObjects:[UIColor whiteColor], nil];
    [spinner startAnimation];
    [self.view setUserInteractionEnabled:NO];
}
-(void)stopSpinner
{
    [spinner setHidden:YES];
    [spinner stopAnimation];
    [self.view setUserInteractionEnabled:YES];
}

//-(void)signInAlert{
//    UIView* contentView = [[UIView alloc] init];
//    contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    contentView.backgroundColor = [UIColor whiteColor];
//    contentView.layer.cornerRadius = 15.0;
//
//    // Create Title Label
//    UILabel* labelTitle = [[UILabel alloc] init];
//    labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor blackColor];
//    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.numberOfLines = 0;
//    labelTitle.text = @"Sign-up or Login to enable this feature.";
//
//    // Create Cancel Button
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
//    // Create Ok Button
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
//    // Add Views
//    [contentView addSubview:labelTitle];
//    [contentView addSubview:okButton];
//    [contentView addSubview:cancelButton];
//
//    // Add Constraints
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
//- (void)enableCalled:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *splitViewController = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
//        [AppDelegate sharedAppDelegate].window.rootViewController = splitViewController;
//    });
//}


@end
