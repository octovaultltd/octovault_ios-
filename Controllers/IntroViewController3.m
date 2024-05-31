//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "IntroViewController3.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
#import <OneSignal/OneSignal.h>
#import <UICKeyChainStore.h>
#import "MBProgressHUD.h"



@interface IntroViewController3 ()

@end

@implementation IntroViewController3{
    NSUserDefaults* defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logoCheck];
}

-(IBAction)nextBtnTapped:(id)sender{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"endIntro"];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        [self callLoginAPI];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *splitViewController = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = splitViewController;
        });
    }
}

-(void)callLoginAPI{
    NSString* user = @"GUEST-LOGIN";
    NSString *username = [NSString stringWithFormat:@"HR4411-%@", user];
    NSString* password = @"123456";
        
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
                });
            }
        }else{
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSLog(@"Json Error : %@", jsonError);
            
            if(jsonError) {
                NSLog(@"json error : %@", [jsonError localizedDescription]);
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
                    [defaults setBool:NO forKey:@"realUserLogin"];
                    
                    [defaults synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                        [keychain setString:username forKey:@"username"];
                        [keychain setString:password forKey:@"password"];
                        [defaults setValue:username forKey:@"username"];
                        [defaults setValue:password forKey:@"password"];
                        [defaults synchronize];
                        [self getPricing];
                        [self guestLoginSuccessful];
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

-(void)guestLoginSuccessful{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = tabBarController;
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
