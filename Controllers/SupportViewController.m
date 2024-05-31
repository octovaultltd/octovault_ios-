//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SupportViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "KSToastView.h"
#import <UICKeyChainStore.h>
#import "WebViewController.h"
#import "KLCPopup.h"


@interface SupportViewController ()

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.supportview.layer.cornerRadius = 10;
    self.supportborder.layer.cornerRadius = 10;
    self.backview.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
}

-(IBAction)backbtnTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    });
}

-(IBAction)liveChatbtnTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
//        [self signInAlert];
        [KSToastView ks_showToast:@"Locked for Geust Login"];
    }else{
        UIAlertController *supportSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString* numberText = @"octovault";
        NSArray *numberList = [numberText componentsSeparatedByString:@","];
        if (numberList.count == 1){
            [self openWhatsApp:numberText];
        }else{
            [supportSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            for (NSString* number in numberList) {
                [supportSheet addAction:[UIAlertAction actionWithTitle: number style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self openWhatsApp:number];
                }]];
            }
        }
    }
}

-(void)openWhatsApp:(NSString*)number{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *userName = [NSString stringWithFormat:@"%@", [keychain stringForKey:@"username"]];
    NSLog(@"username : %@", userName);
    
    NSString *test = @"OctoVault VPN username: ";
    NSString *encodedString = [test stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.whatsapp.com/send?phone=%@&text=%@%@",number, encodedString, userName]];
    NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://t.me/%@",number]];

    NSLog(@"appurl %@", appURL);

    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:appURL options:nil completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:appURL];
        }
    }else{
        [KSToastView ks_showToast:@"Telegram Not Available" delay:3.0];
//        [[UIApplication sharedApplication] openURL:@"https://apps.apple.com/tm/app/telegram-messenger/id686449807"];
    }
}
-(IBAction)emailbtnTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
//        [self signInAlert];
        [KSToastView ks_showToast:@"Locked for Geust Login"];
    }else{
        UIAlertController *supportSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString* numberText = @"support@octovault.org";
        NSArray *numberList = [numberText componentsSeparatedByString:@","];
        
        [supportSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        for (NSString* number in numberList) {
            [supportSheet addAction:[UIAlertAction actionWithTitle: number style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self openMail:number];
            }]];
        }
        
        [self presentViewController:supportSheet animated:YES completion:nil];
    }
}

-(void)openMail:(NSString*)number{
    NSString* message = [NSString stringWithFormat:@""];

    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;

        [mailCont setSubject:@"Email from OctoVault VPN customer"];
        [mailCont setToRecipients:[NSArray arrayWithObject:number]];
        [mailCont setMessageBody:message isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }else{
        NSLog(@"No Email Configuared");
        [KSToastView ks_showToast:@"No Email Configuared" delay:3.0];
    }
}

-(IBAction)faqbtnTapped:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/faq.html"]];
}

-(void)openWebView:(NSString*)title andURL:(NSString*)url{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *webNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    WebViewController *webViewController = (WebViewController*)webNavigationController.viewControllers.firstObject;
    webViewController.title = title;
    webViewController.url = url;
    [self presentViewController:webNavigationController animated:YES completion:nil];
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
