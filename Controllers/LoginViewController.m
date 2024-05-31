//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NEVPNManager.h>
#import <UICKeyChainStore.h>
#import "ForgotPasswordViewController.h"
#import <FirebaseCrashlytics.h>
#import "Reachability.h"
#import "AFNetworking.h"
#import <sys/utsname.h>
#import <objc/runtime.h>
#import "HexColors.h"
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import <OneSignal/OneSignal.h>
#import "KSToastView.h"




@interface LoginViewController ()<ForgotPasswordViewControllerDelegate>{
    __block NETunnelProviderManager * vpnManager;
}
@end
@implementation LoginViewController{
    NSUserDefaults* defaults;
}
@synthesize spinner;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    
    self.tvStatus.hidden = true;
    
    [self logoCheck];
    
    [self.userNameTextfield addTarget:self action:@selector(validateTextfield:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextfield addTarget:self action:@selector(validateTextfield:) forControlEvents:UIControlEventEditingChanged];
}

-(void)validateTextfield:(UITextField*)textField {
    if (self.userNameTextfield.isFirstResponder) {
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }else if (self.passwordTextfield.isFirstResponder) {
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }else{
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *userName = [keychain stringForKey:@"username"];
    NSString *password = [keychain stringForKey:@"password"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userName == nil || userName.length == 0) {
        userName = [userDefaults valueForKey:@"username"];
        password = [userDefaults valueForKey:@"password"];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if([userName containsString:@"HR4411-"]){
            NSString *strimedUsername = [userName stringByReplacingOccurrencesOfString:@"HR4411-" withString:@""];
            self.userNameTextfield.text = strimedUsername;
            self.passwordTextfield.text = password;
        }
    });
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.userNameTextfield.text = nil;
            self.passwordTextfield.text = nil;
        });
    }
    
    self.userNameTextfield.returnKeyType = UIReturnKeyNext;
    self.passwordTextfield.returnKeyType = UIReturnKeyNext;
    
    self.loginButton.layer.cornerRadius = 25;
    
    self.usernameView.layer.cornerRadius = 10;
    self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.usernameView.layer.borderWidth = 1.0;
    
    self.passwordView.layer.cornerRadius = 10;
    self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.passwordView.layer.borderWidth = 1.0;
    
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.userNameTextfield, ivar);
    placeholderLabel.textColor = [UIColor colorWithHexString:@"6E6E6E"];

    UILabel *placeholderLabel2 = object_getIvar(self.passwordTextfield, ivar);
    placeholderLabel2.textColor = [UIColor colorWithHexString:@"6E6E6E"];
    
}

- (IBAction)SecureButtonTapped:(id)sender {
    if (_secureButton.selected) {
        _secureButton.selected=NO;
        self.passwordTextfield.secureTextEntry = YES;
        [_secureButton setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }else{
        _secureButton.selected=YES;
        self.passwordTextfield.secureTextEntry = NO;
        [_secureButton setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
}

-(void)dismiskeyboard{
    [self.userNameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
}

- (IBAction)loginButtonTapped:(id)sender {
    [self dismiskeyboard];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app reachable]) {
            [self callLoginAPI];
    }else {
        self.tvStatus.hidden = false;
        self.tvStatus.text = @"Please Check Your Internet Connection";
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)callLoginAPI{
    self.tvStatus.hidden = true;

    if (self.userNameTextfield.text.length == 0 || self.passwordTextfield.text.length == 0) {
        self.tvStatus.text = @"Missing Email or Password";
        self.tvStatus.hidden = false;
        return;
    }
    
    NSString* user = self.userNameTextfield.text;
    NSString *username = [NSString stringWithFormat:@"HR4411-%@", user];
    NSString* password = self.passwordTextfield.text;
    
    [self startSpinner];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString* deviceName = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
    deviceModel = [deviceModel stringByReplacingOccurrencesOfString:@"," withString:@""];

    NSString* pushUserID = @"";
    if([OneSignal getDeviceState].userId != nil){
        pushUserID = [OneSignal getDeviceState].userId;
    }
    
    NSDictionary *headers = @{ @"Content-Type": @"application/x-www-form-urlencoded",
                               @"User-Agent": @"PostmanRuntime/7.15.0",
                               @"Accept": @"*/*",
                               @"Cache-Control": @"no-cache",
                               @"accept-encoding": @"gzip, deflate",
                               @"Connection": @"keep-alive",
                               @"cache-control": @"no-cache"
    };
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"username=%@",username] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&pass=%@",password] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&rLevel=4"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&rId=411"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&inAppPurchase=1" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&app_id=103" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&vpnAppVersion=%@", appVersionString] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&brand=apple" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&model=%@", deviceModel] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&osName=iOS" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&osVersion=%@", [[UIDevice currentDevice] systemVersion]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&osPlatform=iOS" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&player_id=%@", pushUserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&device_type=2" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&deviceName=%@", deviceName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *uuid = [keychain stringForKey:@"UUID"];
    if (uuid.length == 0) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setString:uuid forKey:@"UUID"];
    }
    [postData appendData:[[NSString stringWithFormat:@"&udid=%@",uuid] dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSString *loginURL = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/login_v5";
    NSString *loginURL = @"https://dragonia.squarefootuni.store/laravelv5.php";
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });
        if (error) {
            NSLog(@"Login Error : %@", error);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [defaults objectForKey:@"data"];
            if (data.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [KSToastView ks_showToast:error.localizedDescription duration:3.0f];
                });
            }
        } else {
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSLog(@"Json Error : %@", jsonError);
            
            if(jsonError) {
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                [KSToastView ks_showToast:@"JSON parsing error" duration:3.0f];
            } else {
                NSLog(@"Json login data: %@", json);
                
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *emailVerification = [NSString stringWithFormat:@"%@",[json valueForKey:@"is_required_email_verified"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                [self->defaults setValue:message forKey:@"message"];
                [self->defaults synchronize];
                
                if ([responseCode isEqualToString:@"1"]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:data forKey:@"data"];
                    
                    NSString *expireInDays = [NSString stringWithFormat:@"%@",[json valueForKey:@"expire_in_days"]];
                    [defaults setValue:expireInDays forKey:@"expireInDays"];
                    
                    NSString *expiredAt = [NSString stringWithFormat:@"%@",[json valueForKey:@"expired_at"]];
                    [defaults setValue:expiredAt forKey:@"expiredAt"];
                    
                    NSString *hasInAppPurchase = [NSString stringWithFormat:@"%@",[json valueForKey:@"has_inapp_purchase"]];
                    [defaults setValue:hasInAppPurchase forKey:@"hasInAppPurchase"];
                                        
                    NSString *userStatus = [NSString stringWithFormat:@"%@",[json valueForKey:@"user_status"]];
                    [defaults setValue:userStatus forKey:@"userStatus"];
                    
                    NSString *validityDate = [NSString stringWithFormat:@"%@",[json valueForKey:@"validity_date"]];
                    [defaults setValue:validityDate forKey:@"validityDate"];
                
                    NSString *user_type = [NSString stringWithFormat:@"%@",[json valueForKey:@"user_type"]];
                    [defaults setValue:user_type forKey:@"userType"];
                
                    NSString *is_verified = [NSString stringWithFormat:@"%@",[json valueForKey:@"is_verified"]];
                    [defaults setValue:is_verified forKey:@"is_verified"];
                    
                    NSString *planId = [NSString stringWithFormat:@"%@",[json valueForKey:@"rate_plan_detail_id"]];
                    [defaults setValue:planId forKey:@"planId"];
                    
                    NSString *is_required_email_verified = [NSString stringWithFormat:@"%@",[json valueForKey:@"is_required_email_verified"]];
                    [defaults setValue:is_required_email_verified forKey:@"is_required_email_verified"];
                                        
                    NSArray *skuids = @[@"OneMonth", @"ThreeMonth", @"SixMonth", @"OneYear"];
                    [defaults setValue:skuids forKey:@"Skuids"];

                    [defaults setBool:YES forKey:@"isLoggedIn"];
                    [defaults setBool:YES forKey:@"realUserLogin"];
                    
                    [defaults synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                        [keychain setString:username forKey:@"username"];
                        [keychain setString:password forKey:@"password"];
                        [defaults setValue:username forKey:@"username"];
                        [defaults setValue:password forKey:@"password"];
                        [defaults synchronize];
                        [self getPricing];
                        [self loginSuccessful];
                    });
                }else if([responseCode isEqualToString:@"2"] && [emailVerification isEqualToString:@"1"]){
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                            [keychain setString:username forKey:@"username"];
                            [keychain setString:password forKey:@"password"];
                            [defaults setValue:username forKey:@"username"];
                            [defaults setValue:password forKey:@"password"];
                            [defaults synchronize];
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            UIViewController *signupverificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpVerificationViewController"];
                            [self presentViewController:signupverificationViewController animated:YES completion:nil];
                        });
                        [KSToastView ks_showToast: message duration:4.0f];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                    [KSToastView ks_showToast: message duration:4.0f];
                    self.tvStatus.hidden = false;
                    self.tvStatus.text = message;
                });
                }
                [self->defaults synchronize];
            }
        }
    }];
    [dataTask resume];
}

-(void)getPricing{
    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Content-Type": @"application/json",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache"
    };
    
    NSString *getPrice = @"https://vpn.redcardvpn.com/platinumproductlistapi.php";
    NSString *url =[getPrice stringByAppendingString:[NSString stringWithFormat:@"?reseller4_id=411"]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
        });
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if(jsonError) {
                NSLog(@"json error : %@", [jsonError localizedDescription]);
            } else {
                NSLog(@"Price data: %@", json);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                    if ([responseCode isEqualToString:@"1"]){
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSDictionary* data = [json objectForKey:@"data"];
                        NSArray* inAppData = [data valueForKey:@"iapp_ios_packages"];
                        
                        NSString *price = [inAppData valueForKey:@"price"];
                        NSString *title = [inAppData valueForKey:@"title"];
                        NSString *packageID = [inAppData valueForKey:@"in_app_package_id"];
                        NSString *highlightedText = [inAppData valueForKey:@"highlighted_text"];
                        NSString *subTitle = [inAppData valueForKey:@"sub_title"];
                        
                        [defaults setValue:price forKey:@"price"];
                        [defaults setValue:title forKey:@"title"];
                        [defaults setValue:packageID forKey:@"packageID"];
                        [defaults setValue:highlightedText forKey:@"highlightedText"];
                        [defaults setValue:subTitle forKey:@"subTitle"];
                        NSLog(@"Pricing details: %@ %@ %@ %@ %@", price, title,packageID,highlightedText, subTitle);
                        
                        [defaults synchronize];
                    }
                });
            }
        }
    }];
    [dataTask resume];
}

-(void)loginSuccessful{

    
    [defaults setObject:nil forKey:@"StartDate"];
    [defaults setBool:YES forKey:@"isLoggedIn"];
    [defaults synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
    });
}




-(NSString *) base64DecodedString:(NSString *)string {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return [self EncryptOrDecrypt:decodedString];
}

-(NSString *) EncryptOrDecrypt:(NSString *)string {
    NSString *key=@"Ts(Trjslas";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    char *dataPtr = (char *) [data bytes];
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *keyPtr = keyData;
    int keyIndex = 0;
    for (int x = 0; x < [data length]; x++)
    {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        if (++keyIndex == [key length])
            keyIndex = 0;
            keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextfield) {
        [textField resignFirstResponder];
        [self.passwordTextfield becomeFirstResponder];
    } else if (textField == self.passwordTextfield) {
        [textField resignFirstResponder];
        [self.userNameTextfield becomeFirstResponder];
    }
    return YES;
}


- (IBAction)forgotPasswordButtonTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordViewController *forgotPasswordViewController = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    forgotPasswordViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    forgotPasswordViewController.delegate = self;
    [self presentViewController:forgotPasswordViewController animated:YES completion:nil];
}

- (IBAction)signUpdButtonTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *signupViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self presentViewController:signupViewController animated:YES completion:nil];
}


-(void)emailSentSuccess:(BOOL)success{
    if (success) {
        
    }
}

-(IBAction) GetSupport:(id)sender{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *rootNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"SupportNavigationController"];
//    [self presentViewController:rootNavigationController animated:YES completion:nil];
}



//-------Start & Stop Spinner------//
-(void)startSpinner{
    [spinner setHidden:NO];
    spinner.lineWidth = 3;
    spinner.colorArray = [NSArray arrayWithObjects:[UIColor colorNamed:@"orangecolor"], nil];
    [spinner startAnimation];
    [self.view setUserInteractionEnabled:NO];
}

-(void)stopSpinner{
    [spinner setHidden:YES];
    [spinner stopAnimation];
    [self.view setUserInteractionEnabled:YES];
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
