//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "Refer2ViewController.h"
#import "AppDelegate.h"
#import <UICKeyChainStore.h>
#import "KSToastView.h"
#import "AFNetworking.h"



@interface Refer2ViewController ()

@end

@implementation Refer2ViewController{
    NSUserDefaults* defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getReferInfo];
    
    self.backview.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    self.balanceview.layer.cornerRadius = 10;
    self.balanceborder.layer.cornerRadius = 10;
    self.withdrawview.layer.cornerRadius = 10;
    self.btnwithdraw.layer.cornerRadius = 10;
    self.referview.layer.cornerRadius = 10;
    self.referborder.layer.cornerRadius = 10;
    self.redeemview.layer.cornerRadius = 10;
    self.redeemborder.layer.cornerRadius = 10;
    self.applyview.layer.cornerRadius = 10;
    self.applyborder.layer.cornerRadius = 10;
    
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)updateUI{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *referCode = [defaults valueForKey:@"ReferCode"];
    NSString *availableBalance = [defaults valueForKey:@"AvailableBalance"];
    
    NSLog(@"refer: %@ %@", referCode, availableBalance);
    
    bool elligible = [defaults boolForKey:@"Eligibility"];
    
    self.referlabel.text = [NSString stringWithFormat:@"%@", referCode];
    self.balancelabel.text = [NSString stringWithFormat:@"$ %@", availableBalance];
    
    
    NSLog(@"bool : %s", elligible ? "true" : "false");
    
    if(elligible){
        self.referxview.hidden = NO;
    }else{
        self.referxview.hidden = YES;
    }
}

-(void)getReferInfo{
    [self startSpinner];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];

    NSString *username = [keychain stringForKey:@"username"];
    NSString* password = [keychain stringForKey:@"password"];
    
    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Content-Type": @"application/json",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache"
    };
    
//    NSString *getRefer = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/get-referral-info-reseller";
    NSString *getRefer = @"http://dragonia.squarefootuni.store/refer_info_reseller.php";
    
    
    NSString *url =[getRefer stringByAppendingString:[NSString stringWithFormat:@"?username=%@%@%@%@",username, @"&pass=",password, @"&idReseller4=411"]];
    
    NSLog(@"referurl: %@", url);
    
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
                
                NSLog(@"data: %@", json);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    
                    NSString *usedCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"used_referral_code"]];
                    
                    NSDictionary *referralData = [json valueForKey:@"referral_data"];
                    NSString *referCode = [referralData valueForKey:@"referral_code"];
                    NSString *availableBalance = [referralData valueForKey:@"available_balance"];
                    NSString *matureBalance = [referralData valueForKey:@"mature_balance"];
                    NSString *pendingWithdraw = [referralData valueForKey:@"pending_withdraw_request"];
                    NSString *minimumWithdrawlAmount = [referralData valueForKey:@"minimum_withdrawal_amount"];
                    bool eligibility = [[referralData valueForKey:@"eliligbleForUseReferCode"] boolValue];

                    NSLog(@"bool : %s", eligibility ? "true" : "false");
                    
                    [defaults setValue:referCode forKey:@"ReferCode"];
                    [defaults setValue:availableBalance forKey:@"AvailableBalance"];
                    [defaults setValue:matureBalance forKey:@"MatureBalance"];
                    [defaults setValue:minimumWithdrawlAmount forKey:@"MinWithdraw"];
                    [defaults setBool:eligibility forKey:@"Eligibility"];

                    NSLog(@"bool : %s", eligibility ? "true" : "false");
                    
                    [defaults synchronize];
                    

                    
                    [self updateUI];
                });
                
            }
        }
    }];
    [dataTask resume];

}

-(IBAction)applyTapped:(id)sender{
    if (self.redeemcode.text.length == 0) {
        [KSToastView ks_showToast:NSLocalizedString(@"Empty Invite Code", @"") duration:2.0f];
        return;
    }
    [self startSpinner];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *uuid = [keychain stringForKey:@"UUID"];
    if (uuid.length == 0) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setString:uuid forKey:@"UUID"];
    }

//    NSString *url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/use-referral-reseller";
    NSString *url = @"https://dragonia.squarefootuni.store/use_referral_reseller.php";

    NSDictionary *params = @{@"username": [keychain stringForKey:@"username"], @"referral_code": self.redeemcode.text, @"idReseller4": @"411", @"udid": uuid};

    NSLog(@"apply tapped %@", params);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });

        if(responseObject != nil){

            NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *responseData = [data dataUsingEncoding:NSUTF8StringEncoding];

            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];

            if(jsonError) {
                NSLog(@"json error : %@", [jsonError localizedDescription]);
//                [self showRedeemAlert:@"JSON parsing error" success:NO];
            } else {
                NSLog(@"Use Refer Data : %@", json);
                NSString* responseCode = [NSString stringWithFormat:@"%@", [json valueForKey:@"response_code"]];
                NSString* responseMsg = [NSString stringWithFormat:@"%@", [json valueForKey:@"message"]];
                if([responseCode isEqualToString:@"1"]){
                    [KSToastView ks_showToast:responseMsg duration:3.0f];
                    [self getReferInfo];
                    
                    [self updateUI];
                }else{
                    [KSToastView ks_showToast:responseMsg duration:3.0f];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [KSToastView ks_showToast: @"Could not connect to server" duration:3.0f];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });
    }];
}

-(IBAction)copyTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [defaults valueForKey:@"ReferCode"];
    [KSToastView ks_showToast: @"Referral code copied to clipboard" duration:3.0f];
}

-(IBAction)backbtnTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *refer1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"Refer1ViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = refer1ViewController;
    });
}

-(IBAction)shareTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [NSString stringWithFormat:@"\nRefer Code: %@\nDownload Link:\nhttps://octovaultvpn.net/download/", [defaults valueForKey:@"ReferCode"]];
    
    NSArray *activityItems = @[code];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    activityViewControntroller.popoverPresentationController.sourceView = self.view;
    activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

-(IBAction)widthrawTapped:(id)sender{
    [KSToastView ks_showToast: @"Not available." duration:3.0f];
}


//-------Start & Stop Spinner------//
-(void)startSpinner{
    [_spinner setHidden:NO];
    _spinner.lineWidth = 3;
    _spinner.colorArray = [NSArray arrayWithObjects:[UIColor colorNamed:@"orangecolor"], nil];
    [_spinner startAnimation];
    [self.view setUserInteractionEnabled:NO];
}

-(void)stopSpinner{
    [_spinner setHidden:YES];
    [_spinner stopAnimation];
    [self.view setUserInteractionEnabled:YES];
}

@end
