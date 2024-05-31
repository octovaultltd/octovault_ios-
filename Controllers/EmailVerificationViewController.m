//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "EmailVerificationViewController.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"

@interface EmailVerificationViewController ()

@end

@implementation EmailVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.digit1.delegate = self;
    self.digit2.delegate = self;
    self.digit3.delegate = self;
    self.digit4.delegate = self;
    
//    self.btnresend.hidden = true;
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
    
    self.btnverify.layer.cornerRadius = 25;
    self.cancelview.layer.cornerRadius = 25;
    self.btncancel.layer.cornerRadius = 25;
    
    self.btncancel.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btncancel.layer.borderWidth = 1.5;
    
    self.btnresend.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnresend.layer.borderWidth = 1.0;
    self.btnresend.layer.cornerRadius = 8;
    
    [self logoCheck];
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

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction)cancelbtnTapped:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *forgotpasswordViewController = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = forgotpasswordViewController;
    });
}

-(IBAction)verifybtnTapped:(id)sender{
    self.btnresend.hidden = true;
    self.lblstatus.hidden = true;
    
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

//    NSString *url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/octavaultvpn/token-verification";
    NSString *url = @"https://dragonia.squarefootuni.store/token_verification_common.php?app_name=octavaultvpn";

    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *user = [keychain stringForKey:@"useremail"];
    NSString *useremail = [NSString stringWithFormat:@"HR4411-%@", user];
    NSString *token = otpText;
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", useremail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&token=%@", otpText] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&is_destroy_token=2"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&token_type=2"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
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
                [self updateStatus:NSLocalizedString(@"Could not connect to server", @"")];
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            if(jsonError) {
                // check the error description
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self updateStatus:NSLocalizedString(@"JSON Parsing Error", @"")];
                });

            } else {
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];

                NSLog(@"joy response signup verification: %@", json);
                
                if ([responseCode isEqualToString:@"1"]) {

                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        [keychain setString:token forKey:@"token"];

                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *passwordresetViewController = [storyboard instantiateViewControllerWithIdentifier:@"PasswordResetViewController"];
                        [AppDelegate sharedAppDelegate].window.rootViewController = passwordresetViewController;
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        self.digit1.text = nil;
                        self.digit2.text = nil;
                        self.digit3.text = nil;
                        self.digit4.text = nil;
                        [self updateStatus:message];
                        self.btnresend.hidden = false;
                    });

                }
            }
        }
    }];
    [dataTask resume];
}

-(IBAction)resendbtnTapped:(id)sender{
    self.btnresend.hidden = true;
    self.lblstatus.hidden = true;
    [self startSpinner];

    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache" };

//    NSString *url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/octavaultvpn/resend-verification-token";
    NSString *url =@"https://dragonia.squarefootuni.store/resend_verification_reseller_commom_production.php?app_name=octavaultvpn";

    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *user = [keychain stringForKey:@"useremail"];
    NSString *useremail = [NSString stringWithFormat:@"HR4411-%@", user];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", useremail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&verification_type=2"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
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
                [self updateStatus:NSLocalizedString(@"Could not connect to server", @"")];
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            if(jsonError) {
                // check the error description
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self updateStatus:NSLocalizedString(@"JSON Parsing Error", @"")];
                });

            } else {
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];

                
                [self updateStatus:message];
            }
        }
    }];
    [dataTask resume];

}


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

-(void) updateStatus:(NSString *) message{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.lblstatus.text = message;
        self.lblstatus.hidden = NO;
    });
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
