//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "PricingViewController.h"
#import "AppDelegate.h"
#import "IAPManager.h"
#import <StoreKit/StoreKit.h>
#import "SKProduct+priceAsString.h"
#import <UICKeyChainStore.h>
#import "KSToastView.h"
#import "HexColors.h"
#import <sys/utsname.h>
#import "KLCPopup.h"



@interface PricingViewController (){
    NSArray *allProducts;
    NSArray *productList;
    NSArray *title;
    NSArray *price;
    NSArray *packageID;
    NSArray *highlightedText;
    BOOL isOneMonth;
    BOOL isThreeMonth;
    BOOL isSixMonth;
    BOOL isOneYear;
}
@end

@implementation PricingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.package.hidden = YES;
    self.item1view.hidden = true;
    self.item2view.hidden = true;
    self.item3view.hidden = true;
    self.item4view.hidden = true;
    
    [self getPriceing];
    
    isOneMonth = YES;
    isThreeMonth = NO;
    isSixMonth = NO;
    isOneYear = NO;
    [self updatePricing];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction)restoreTapped:(id)sender{
    [[IAPManager shared] restorePurchases];
}

-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.item1view.layer.cornerRadius = 10;
        self.item2view.layer.cornerRadius = 10;
        self.item3view.layer.cornerRadius = 10;
        self.item4view.layer.cornerRadius = 10;
        self.backview.layer.cornerRadius = 25;
        self.btnback.layer.cornerRadius = 25;
        self.btngetpremium.layer.cornerRadius = 25;
        self.btnrestore.layer.cornerRadius = 25;
        
        self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
        self.btnback.layer.borderWidth = 1.5;
        self.item1view.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.item1view.layer.borderWidth = 1.0;
        self.item2view.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.item2view.layer.borderWidth = 1.0;
        self.item3view.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.item3view.layer.borderWidth = 1.0;
        self.item4view.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.item4view.layer.borderWidth = 1.0;
    });
}

-(void)getPriceing{
    [self startSpinner];
    
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
            [self stopSpinner];
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
                        [defaults setValue:price forKey:@"price"];
                        [defaults setValue:title forKey:@"title"];
                        [defaults setValue:packageID forKey:@"packageID"];
                        [defaults setValue:highlightedText forKey:@"highlightedText"];
                        
                        [defaults synchronize];
                    }
                    [self updateui];
                });
            }
        }
    }];
    [dataTask resume];
}

-(void)updatePricing{
    self.package.hidden = NO;
    self.item1view.hidden = false;
    self.item2view.hidden = false;
    self.item3view.hidden = false;
    self.item4view.hidden = false;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    allProducts = [IAPManager getAvailableProducts];
    
    title = [defaults objectForKey:@"title"];
    price = [defaults objectForKey:@"price"];
    highlightedText = [defaults objectForKey:@"highlightedText"];
    
    SKProduct* priceOne = allProducts[0];
    self.title1.text = title[0];
    self.highlightedText1.text = @"";
    self.monthly1.text = @"";
    self.price1.text = priceOne.priceAsString;
    
    SKProduct* priceTwo = allProducts[1];
    self.title2.text = title[1];
    self.highlightedText2.text = @"";
    self.monthly2.text = @"";
    self.price2.text = priceTwo.priceAsString;

    SKProduct* priceThree = allProducts[2];
    self.title3.text = title[2];
    self.highlightedText3.text = @"";
    self.monthly3.text = @"";
    self.price3.text = priceThree.priceAsString;
    
    SKProduct* priceFour = allProducts[3];
    self.title4.text = title[3];
    self.highlightedText4.text = @"";
    self.monthly4.text = @"";
    self.price4.text = priceFour.priceAsString;
}

-(void)purchaseProduct:(SKProduct*)product{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *userName = [keychain stringForKey:@"username"];
    
    [IAPManager purchaseWithProduct:product userId:userName completionBlock:^(IAPResultCode code, id info) {
        if (code == IAPResultCodeValidingWithServer){
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *conEmail = @"";
            [self verifyPurchasewithProduct:product username:userName withEmail:conEmail];
            [KSToastView ks_showToast: @"Success" duration:3.0f];
        }else{
            NSLog(@"Payment Procedure failed %@",info);
            dispatch_async(dispatch_get_main_queue(), ^{
                [KSToastView ks_showToast:@"Transaction Failed" duration:3.0f];
            });
        }
    }];
}

-(void) verifyPurchasewithProduct:(SKProduct*)product username:(NSString *)userName withEmail:(NSString *)Email{
    [IAPManager validateReceiptWithRemoteServerwithEmail:Email withCompletion:^(IAPResultCode code, id info) {
        if (code == IAPResultCodeSuccess){
            [IAPManager completePurchaseWithProduct:product.productIdentifier userId:userName completionBlock:^(IAPResultCode code, id info) {
                NSLog(@"product purchased successfully");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KSToastView ks_showToast:@"Product purchased successfully" duration:3.0f];
                    [self loginApiCalled];
                });
            }];
        }else if(code == IAPResultCodeInvalid){
            [IAPManager completePurchaseWithProduct:product.productIdentifier userId:userName completionBlock:^(IAPResultCode code, id info) {
                NSLog(@"production verification CodeInvalid");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KSToastView ks_showToast:@"Duplicate or Invalid Receipt" duration:3.0f];
                });
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [KSToastView ks_showToast:NSLocalizedString(@"Receipt Verification Failed", @"") duration:3.0f];
            });
        }
    }];
}

-(void)loginApiCalled{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *username = [keychain stringForKey:@"username"];;
    NSString* password = [keychain stringForKey:@"password"];
    
    [self startSpinner];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString* deviceName = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
    deviceModel = [deviceModel stringByReplacingOccurrencesOfString:@"," withString:@""];

    
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
    [postData appendData:[[NSString stringWithFormat:@"&rLevel="] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&rId="] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&inAppPurchase=1" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData appendData:[[NSString stringWithFormat:@"&vpnAppVersion=%@", appVersionString] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&brand=apple" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&model=%@", deviceModel] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&osName=iOS" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&osVersion=%@", [[UIDevice currentDevice] systemVersion]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&osPlatform=iOS" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&device_type=2" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&deviceName=%@", deviceName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *uuid = [keychain stringForKey:@"UUID"];
    if (uuid.length == 0) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setString:uuid forKey:@"UUID"];
    }
    [postData appendData:[[NSString stringWithFormat:@"&udid=%@",uuid] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
                [defaults setValue:message forKey:@"message"];
                [defaults synchronize];
                
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
                    
                    NSArray *bundles = [json valueForKey:@"ip_bundle"];
                    NSString *vpnServerId = [NSString stringWithFormat:@"%@",[bundles valueForKey:@"vpn_server_id"]];
                    
                    NSArray *skuids = @[@"OneMonth", @"ThreeMonth", @"SixMonth", @"OneYear"];
                    [defaults setValue:skuids forKey:@"Skuids"];

                    [defaults setBool:YES forKey:@"isLoggedIn"];
                    
                    [defaults synchronize];
                }
            }
        }
    }];
    [dataTask resume];
}

-(IBAction)backbtnTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *usertype = [defaults valueForKey:@"userType"];
    NSString* userStatus = [defaults valueForKey:@"userStatus"];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    }else{
        if([usertype isEqualToString:@"2"] && [userStatus isEqualToString: @"1"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *subscriptionViewController = [storyboard instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
            [AppDelegate sharedAppDelegate].window.rootViewController = subscriptionViewController;
        }else{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            app.window.rootViewController = tabBarController;
            [tabBarController setSelectedIndex:2];
        }
    }
}

-(IBAction)oneMonthTapped:(id)sender{
    NSLog(@"one month tapped");
    isOneMonth = YES;
    isThreeMonth = NO;
    isSixMonth = NO;
    isOneYear = NO;
    
    [self updateui];
}

-(IBAction)threeMonthTapped:(id)sender{
    NSLog(@"three months tapped");
    
    isOneMonth = NO;
    isThreeMonth = YES;
    isSixMonth = NO;
    isOneYear = NO;
    
    [self updateui];
}

-(IBAction)sixMonthTapped:(id)sender{
    NSLog(@"six months tapped");
    
    isOneMonth = NO;
    isThreeMonth = NO;
    isSixMonth = YES;
    isOneYear = NO;
    
    [self updateui];
}

-(IBAction)oneYearTapped:(id)sender{
    NSLog(@"one year tapped");
    
    isOneMonth = NO;
    isThreeMonth = NO;
    isSixMonth = NO;
    isOneYear = YES;
    
    [self updateui];
}

-(void)updateui{
    if(isOneMonth){
        self.item1view.backgroundColor = [UIColor colorNamed:@"orangecolor"];
        self.item2view.backgroundColor = [UIColor clearColor];
        self.item3view.backgroundColor = [UIColor clearColor];
        self.item4view.backgroundColor = [UIColor clearColor];
        self.title1.textColor = [UIColor colorNamed:@"orangeblack"];
        self.price1.textColor = [UIColor colorNamed:@"orangeblack"];
        self.sign1.textColor = [UIColor colorNamed:@"orangeblack"];
        self.monthly1.textColor = [UIColor colorNamed:@"orangeblack"];
        self.title2.textColor = [UIColor whiteColor];
        self.price2.textColor = [UIColor whiteColor];
        self.sign2.textColor = [UIColor whiteColor];
        self.monthly2.textColor = [UIColor whiteColor];
        self.title3.textColor = [UIColor whiteColor];
        self.price3.textColor = [UIColor whiteColor];
        self.sign3.textColor = [UIColor whiteColor];
        self.monthly3.textColor = [UIColor whiteColor];
        self.title4.textColor = [UIColor whiteColor];
        self.price4.textColor = [UIColor whiteColor];
        self.sign4.textColor = [UIColor whiteColor];
        self.monthly4.textColor = [UIColor whiteColor];
    }else if(isThreeMonth){
        self.item1view.backgroundColor = [UIColor clearColor];
        self.item2view.backgroundColor = [UIColor colorNamed:@"orangecolor"];
        self.item3view.backgroundColor = [UIColor clearColor];
        self.item4view.backgroundColor = [UIColor clearColor];
        self.title1.textColor = [UIColor whiteColor];
        self.price1.textColor = [UIColor whiteColor];
        self.sign1.textColor = [UIColor whiteColor];
        self.monthly1.textColor = [UIColor whiteColor];
        self.title2.textColor = [UIColor colorNamed:@"orangeblack"];
        self.price2.textColor = [UIColor colorNamed:@"orangeblack"];
        self.sign2.textColor = [UIColor colorNamed:@"orangeblack"];
        self.monthly2.textColor = [UIColor colorNamed:@"orangeblack"];
        self.title3.textColor = [UIColor whiteColor];
        self.price3.textColor = [UIColor whiteColor];
        self.sign3.textColor = [UIColor whiteColor];
        self.monthly3.textColor = [UIColor whiteColor];
        self.title4.textColor = [UIColor whiteColor];
        self.price4.textColor = [UIColor whiteColor];
        self.sign4.textColor = [UIColor whiteColor];
        self.monthly4.textColor = [UIColor whiteColor];
    }else if (isSixMonth){
        self.item1view.backgroundColor = [UIColor clearColor];
        self.item2view.backgroundColor = [UIColor clearColor];
        self.item3view.backgroundColor = [UIColor colorNamed:@"orangecolor"];
        self.item4view.backgroundColor = [UIColor clearColor];
        self.title1.textColor = [UIColor whiteColor];
        self.price1.textColor = [UIColor whiteColor];
        self.sign1.textColor = [UIColor whiteColor];
        self.monthly1.textColor = [UIColor whiteColor];
        self.title2.textColor = [UIColor whiteColor];
        self.price2.textColor = [UIColor whiteColor];
        self.sign2.textColor = [UIColor whiteColor];
        self.monthly2.textColor = [UIColor whiteColor];
        self.title3.textColor = [UIColor colorNamed:@"orangeblack"];
        self.price3.textColor = [UIColor colorNamed:@"orangeblack"];
        self.sign3.textColor = [UIColor colorNamed:@"orangeblack"];
        self.monthly3.textColor = [UIColor colorNamed:@"orangeblack"];
        self.title4.textColor = [UIColor whiteColor];
        self.price4.textColor = [UIColor whiteColor];
        self.sign4.textColor = [UIColor whiteColor];
        self.monthly4.textColor = [UIColor whiteColor];
    }else if (isOneYear){
        self.item1view.backgroundColor = [UIColor clearColor];
        self.item2view.backgroundColor = [UIColor clearColor];
        self.item3view.backgroundColor = [UIColor clearColor];
        self.item4view.backgroundColor = [UIColor colorNamed:@"orangecolor"];
        self.title1.textColor = [UIColor whiteColor];
        self.price1.textColor = [UIColor whiteColor];
        self.sign1.textColor = [UIColor whiteColor];
        self.monthly1.textColor = [UIColor whiteColor];
        self.title2.textColor = [UIColor whiteColor];
        self.price2.textColor = [UIColor whiteColor];
        self.sign2.textColor = [UIColor whiteColor];
        self.monthly2.textColor = [UIColor whiteColor];
        self.title3.textColor = [UIColor whiteColor];
        self.price3.textColor = [UIColor whiteColor];
        self.sign3.textColor = [UIColor whiteColor];
        self.monthly3.textColor = [UIColor whiteColor];
        self.title4.textColor = [UIColor colorNamed:@"orangeblack"];
        self.price4.textColor = [UIColor colorNamed:@"orangeblack"];
        self.sign4.textColor = [UIColor colorNamed:@"orangeblack"];
        self.monthly4.textColor = [UIColor colorNamed:@"orangeblack"];
    }
}

-(IBAction)getpremiumbtnTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        [self signInAlert];
    }else{
        if(isOneMonth){
            [self purchaseProduct:allProducts[0]];
        }else if (isThreeMonth){
            [self purchaseProduct:allProducts[1]];
        }else if (isSixMonth){
            [self purchaseProduct:allProducts[2]];
        }else if (isOneYear){
            [self purchaseProduct:allProducts[3]];
        }
    }
}

-(void)signInAlert{
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
    labelTitle.text = @"Sign-up or Login to purchase subscription.";

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

    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.translatesAutoresizingMaskIntoConstraints = NO;
    okButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    okButton.backgroundColor = [UIColor colorNamed:@"E84E4E"];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[[okButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [okButton setTitle:@"ENABLE" forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 15.0;
    [okButton addTarget:self action:@selector(enableCalled:) forControlEvents:UIControlEventTouchUpInside];

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

- (void)dismissButtonPressed:(id)sender {
    [sender dismissPresentingPopup];
}

- (void)enableCalled:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *splitViewController = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = splitViewController;
    });
}

-(IBAction)termsbtnTapped:(id)sender{
    NSLog(@"joy terms tapped");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/term_of_service.html"]];
}

-(IBAction)policybtnTapped:(id)sender{
    NSLog(@"joy policy tapped");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://octovault.teesta.xyz/privacy_policy.html"]];
}


//-------Start & Stop Spinner------//
-(void)startSpinner{
    [_loaderview setHidden:NO];
    _loaderview.lineWidth = 3;
    _loaderview.colorArray = [NSArray arrayWithObjects:[UIColor colorNamed:@"orangecolor"], nil];
    [_loaderview startAnimation];
    [self.view setUserInteractionEnabled:NO];
}
-(void)stopSpinner{
    [_loaderview setHidden:YES];
    [_loaderview stopAnimation];
    [self.view setUserInteractionEnabled:YES];
}

@end
