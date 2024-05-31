//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "WebViewController.h"
#import "KSToastView.h"
#import <UICKeyChainStore.h>
@import Firebase;
#import <OneSignal/OneSignal.h>
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NETunnelProviderProtocol.h>
#import <NetworkExtension/NEVPNConnection.h>
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "IAPManager.h"
#import <Appirater/Appirater.h>
#import "AFNetworking.h"
#import <sys/utsname.h>
#import "Reachability.h"

@interface AppDelegate () <OSPermissionObserver,OSSubscriptionObserver>
{
    NSUserDefaults* defaults;
    NSTimer* noticeTimer;
}
@property (nonatomic, readwrite) FIRFirestore *db;
@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    defaults = [NSUserDefaults standardUserDefaults];
    
    id notifWillShowInForegroundHandler = ^(OSNotification *notification, OSNotificationDisplayResponse completion){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"Received Notification - %@", notification.notificationId);
        if ([notification.notificationId isEqualToString:@"silent_notif"]) {
            completion(nil);
        } else {
            NSDictionary* notificationData = notification.additionalData;
            if([notificationData objectForKey:@"pageControl"] != nil){
                NSString* pageName = [notificationData valueForKey:@"pageControl"];
                if([pageName containsString:@"http://"] || [pageName containsString:@"https://"]){
                    [defaults setValue:pageName forKey:@"LoginURL"];
                    [defaults synchronize];
                }else{
                    if([pageName isEqualToString:@"Refresh"]){
                        NSString* username = [defaults valueForKey:@"username"];
                        NSString* pass = [defaults valueForKey:@"password"];
                        if(username != nil && pass != nil){
                            if([username length] > 0 && [pass length] > 0){
                                [self callLoginAPI];
                            }
                        }
                        
                    }
                }
            }
            completion(notification);
        }
    };
    // (Optional) - Create block that will fire when a notification is tapped on.
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* notificationData = result.notification.additionalData;
        if([notificationData objectForKey:@"pageControl"] != nil){
            NSString* pageName = [notificationData valueForKey:@"pageControl"];
            if([pageName length] > 0){
                if([pageName containsString:@"http://"] || [pageName containsString:@"https://"]){
                    [defaults setValue:pageName forKey:@"LoginURL"];
                    [defaults synchronize];
                }else{
                    if([pageName isEqualToString:@"Refresh"]){
                        NSString* username = [defaults valueForKey:@"username"];
                        NSString* pass = [defaults valueForKey:@"password"];
                        if(username != nil && pass != nil){
                            if([username length] > 0 && [pass length] > 0){
                                [self callLoginAPI];
                            }
                        }
                    }
                }
            }
        }
    };
    
    [OneSignal initWithLaunchOptions:launchOptions];
    [OneSignal setAppId:@"ea79ec8c-e277-4992-bf30-fc4229e3b6a7"];
    [OneSignal disablePush:NO];
    [OneSignal setNotificationOpenedHandler:notificationOpenedBlock];
    [OneSignal setNotificationWillShowInForegroundHandler:notifWillShowInForegroundHandler];
    [OneSignal addPermissionObserver:self];
    [OneSignal addSubscriptionObserver:self];
    
    [IAPManager checkIfLocalReceiptsNotValided:^(IAPResultCode code, id info) {
        NSLog(@"%@",info);
        
        for(NSDictionary *item in info){
            
            [IAPManager validateReceiptWithRemoteServerInBackground:item[@"receiptData"] withCompletion:^(IAPResultCode code, id info) {
                if (code == IAPResultCodeSuccess){
                    [IAPManager completePurchaseWithProduct:item[@"productId"] userId:item[@"userId"] completionBlock:^(IAPResultCode code, id info) {
                        NSLog(@"product purchased successfully");
                    }];
                }else if(code == IAPResultCodeInvalid){
                    NSLog(@"Production verification CodeInvalid");
                    [IAPManager completePurchaseWithProduct:item[@"productId"] userId:item[@"userId"] completionBlock:^(IAPResultCode code, id info) {
                        NSLog(@"Product purchased successfully");
                    }];
                }else{
                    NSLog(@"Production verification failed");
                }
            }];
        }
    }];
    
    IQKeyboardManager.sharedManager.enable = YES;
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    if (launchOptions != nil)
    {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
            });
            
            
        }
    }
    
    [self callLoginAPI];
    [self listenDocument];
    
    return YES;
}


//com.spinytel.octovault.
- (void)listenDocument {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *skuids = @"OneMonth,ThreeMonth,SixMonth,OneYear";
    [defaults setValue:skuids forKey:@"skuids"];
    
    
    NSLog(@"skuids: %@",skuids);
    [self loadInAppProducts:skuids];
}

-(void) loadInAppProducts:(NSString *) productIDs{
    NSMutableArray *productIDArray = [[NSMutableArray alloc] init];
    NSArray *skuidsArray = [productIDs componentsSeparatedByString:@","];

    for (NSString *productID in skuidsArray) {
        NSString *product = [NSString stringWithFormat:@"com.spinytel.octovault.%@",productID];
        [productIDArray addObject:product];
    }
    [IAPManager.shared loadInAppProducts:productIDArray];
}


-(void)callLoginAPI{
    NSString* username = [defaults valueForKey:@"username"];
    NSString* pass = [defaults valueForKey:@"password"];
    if([username length] == 0 || [pass length] == 0){
        return;
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *uuid = [keychain stringForKey:@"UUID"];
    if (uuid.length == 0) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setString:uuid forKey:@"UUID"];
    }
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    NSString* deviceName = [NSString stringWithCString:systemInfo.nodename
                                              encoding:NSUTF8StringEncoding];
    
    deviceModel = [deviceModel stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSString* pushUserID = @"";
    if([OneSignal getDeviceState].userId != nil){
        pushUserID = [OneSignal getDeviceState].userId;
    }
    
    NSDictionary *params = @{@"username": [defaults valueForKey:@"username"],
                             @"pass": [defaults valueForKey:@"password"],
                             @"udid": uuid,
                             @"countryCode":countryCode,
                             @"vpnAppVersion":appVersionString,
                             @"brand":@"apple",
                             @"model":deviceModel,
                             @"osName":@"iOS",
                             @"osVersion":[[UIDevice currentDevice] systemVersion],
                             @"osPlatform":@"iOS",
                             @"isRooted":@"0",
                             @"bundle2":@"1",
                             @"player_id":pushUserID,
                             @"device_type":@"2",
                             @"deviceName":deviceName,
                             @"app_id":@"103"
    };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    NSString *loginURL = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/login_v5";
    NSString *loginURL = @"https://dragonia.squarefootuni.store/laravelv5.php";
    
    [manager POST:loginURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject != nil){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            double backgroundTime = [[NSDate date] timeIntervalSince1970];
            [defaults setDouble:backgroundTime forKey:@"backgroundTime"];
            [defaults synchronize];
            
            NSString *loginData = [self base64DecodedStringForLoginResponse:responseObject];
            NSData *loginResponseData = [loginData dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:loginResponseData options:0 error:&jsonError];
            
            if(jsonError) {
                // check the error description
                NSLog(@"json error : %@", [jsonError localizedDescription]);
            } else {
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                
                if ([responseCode isEqualToString:@"1"]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:loginResponseData forKey:@"data"];
                    
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
                    
                    NSString *is_required_email_verified = [NSString stringWithFormat:@"%@",[json valueForKey:@"is_required_email_verified"]];
                    [defaults setValue:is_required_email_verified forKey:@"is_required_email_verified"];
                    
                    [defaults synchronize];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(NSString *) base64DecodedString:(NSString *)string {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return [self EncryptOrDecrypt:decodedString];
}

-(NSString *) EncryptOrDecrypt:(NSString *)string {
    NSString *key = @"Ts(Trjslas";
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
            keyIndex = 0; keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *) base64DecodedStringForLoginResponse:(NSString *)string {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return [self EncryptOrDecryptForLoginResponse:decodedString];
}

-(NSString *) EncryptOrDecryptForLoginResponse:(NSString *)string {
    NSString *key=@"Jufk8(fds";
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
            keyIndex = 0; keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *sre = [NSString stringWithFormat:@"%@",exception];
    [userDefault setObject:sre forKey:@"crashed"];
    [userDefault synchronize];
}

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (BOOL)isVPNConnected {
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"]allKeys];
    for (NSString *key in keys) {
        if ([key rangeOfString:@"tap"].location != NSNotFound ||
            [key rangeOfString:@"tun"].location != NSNotFound ||
            [key rangeOfString:@"ipsec"].location != NSNotFound ||
            [key rangeOfString:@"ppp"].location != NSNotFound){
            return YES;
        }
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"enter  background");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"connect"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)onOSPermissionChanged:(OSPermissionStateChanges *)stateChanges {
    
}

- (void)onOSSubscriptionChanged:(OSSubscriptionStateChanges *)stateChanges {
    
}

//notification
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    NSDictionary *custom = [notification.request.content.userInfo valueForKey:@"custom"];
    NSDictionary *temp = [custom valueForKey:@"a"];
    NSString *loginURL = [temp valueForKey:@"url_v2"];
    if (loginURL.length > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:loginURL forKey:@"LoginURL"];
        [defaults synchronize];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert);
}




@end
