//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SignUpVerificationViewController.h"
#import <UICKeyChainStore.h>
#import "KLCPopup.h"
#import "AppDelegate.h"
#import "KSToastView.h"


@interface SignUpVerificationViewController ()

@end

@implementation SignUpVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.digit1.delegate = self;
    self.digit2.delegate = self;
    self.digit3.delegate = self;
    self.digit4.delegate = self;
    
    self.lblstatus.hidden = true;
    
    self.view1border.layer.cornerRadius = 10;
    self.view1border.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.view1border.layer.borderWidth = 1.0;
    
    self.view2border.layer.cornerRadius = 10;
    self.view2border.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.view2border.layer.borderWidth = 1.0;
    
    self.view3border.layer.cornerRadius = 10;
    self.view3border.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.view3border.layer.borderWidth = 1.0;
    
    self.view4border.layer.cornerRadius = 10;
    self.view4border.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.view4border.layer.borderWidth = 1.0;
    
    self.viewback.layer.cornerRadius = 25;
    self.btnverify.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
    
    self.btnresend.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnresend.layer.borderWidth = 1.0;
    self.btnresend.layer.cornerRadius = 8;
        
    [self logoCheck];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = [textField.text length] + [string length] - range.length;

    if (newLength <= 1) {
        if(self.digit1 == textField){
            [self.digit1 setText:newString];
            if (newLength == 1) {
                [self.digit2 becomeFirstResponder];
            }
        }
        if(self.digit2 == textField){
            [self.digit2 setText:newString];
            if (newLength == 1) {
                [self.digit3 becomeFirstResponder];
            }else{
                [self.digit1 becomeFirstResponder];
            }
        }
        if(self.digit3 == textField){
            [self.digit3 setText:newString];
            if (newLength == 1) {
                [self.digit4 becomeFirstResponder];
            }else{
                [self.digit2 becomeFirstResponder];
            }
        }
        if(self.digit4 == textField){
            [self.digit4 setText:newString];
            if (newLength == 1) {
                [self.digit1 becomeFirstResponder];
            }else{
                [self.digit3 becomeFirstResponder];
            }
        }
    }else {
        if(self.digit1 == textField){
            [self.digit2 becomeFirstResponder];
        }
        if(self.digit2 == textField){
            [self.digit3 becomeFirstResponder];
        }
        if(self.digit3 == textField){
            [self.digit4 becomeFirstResponder];
        }
        if(self.digit4 == textField){
            [self.digit1 becomeFirstResponder];
        }
    }
    return NO;
}

-(IBAction)backbtnTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(IBAction)verifybtnTapped:(id)sender{
    self.lblstatus.hidden = true;
//    self.btnresend.hidden = true;

    NSString *otpText = [NSString stringWithFormat:@"%@%@%@%@",self.digit1.text, self.digit2.text, self.digit3.text, self.digit4.text];

    if (otpText.length != 4) {
       self.lblstatus.text = @"OTP must be 4 digits";
        self.lblstatus.hidden = false;

        return;
    }

    [self startSpinner];

    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache" };

//    NSString *tokenURL = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/octavaultvpn/token-verification";
    NSString *tokenURL = @"https://dragonia.squarefootuni.store/token_verification_common.php?app_name=octavaultvpn";
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *username = [keychain stringForKey:@"username"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&token=%@", otpText] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&is_destroy_token=1"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&token_type=1"] dataUsingEncoding:NSUTF8StringEncoding]];

    NSLog(@"joy print signup verification body: %@", username);
    NSLog(@"joy print signup verification body: %@", otpText);
    NSLog(@"joy print signup verification body: %@", body);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });
        if (error) {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.lblstatus.text = @"Could not connect to server";
                self.lblstatus.hidden = false;
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            if(jsonError) {
                // check the error description
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.lblstatus.text = @"JSON Parsing Error";
                    self.lblstatus.hidden = false;
                });

            } else {
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];

                NSLog(@"joy response signup verification: %@", json);
                
                if ([responseCode isEqualToString:@"1"]) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                        [self presentViewController:loginViewController animated:YES completion:nil];

                        [KSToastView ks_showToast: message duration:4.0f];
                    });

                }else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        self.digit1.text = nil;
                        self.digit2.text = nil;
                        self.digit3.text = nil;
                        self.digit4.text = nil;
//                        self.btnresend.hidden = false;
                        [KSToastView ks_showToast: message duration:4.0f];
                    });

                }
            }
        }
    }];
    [dataTask resume];

}



-(IBAction)resendbtnTapped:(id)sender{
//    self.btnresend.hidden = true;
    self.lblstatus.hidden = true;
    [self startSpinner];

    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache" };

//    NSString *resendURL = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/octavaultvpn/resend-verification-token";
    NSString *resendURL = @"https://dragonia.squarefootuni.store/resend_verification_reseller_commom_production.php?app_name=octavaultvpn";

    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *userName = [keychain stringForKey:@"username"];
    
    
    NSLog(@"resend signup: %@", userName);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", userName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&verification_type=2"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resendURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self stopSpinner];
        });
        if (error) {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.lblstatus.text = @"Could not connect to server";
                self.lblstatus.hidden = false;
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            if(jsonError) {
                // check the error description
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.lblstatus.hidden = @"JSON Parsing Error";
                    self.lblstatus.hidden = false;
                });

            } else {
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];

                [KSToastView ks_showToast: message duration:4.0f];
            }
        }
    }];
    [dataTask resume];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
