//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SignUpViewController.h"
#import <UICKeyChainStore.h>
#import <objc/runtime.h>
#import "HexColors.h"
#import "KLCPopup.h"
#import "AppDelegate.h"
#import "KSToastView.h"


@interface SignUpViewController (){
 
}

@end

@implementation SignUpViewController
@synthesize spinner;


- (IBAction)backButtonTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
        
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.emailTextfield, ivar);
    placeholderLabel.textColor = [UIColor colorWithHexString:@"6E6E6E"];

    UILabel *placeholderLabel2 = object_getIvar(self.passwordTextfield, ivar);
    placeholderLabel2.textColor = [UIColor colorWithHexString:@"6E6E6E"];

    UILabel *placeholderLabel3 = object_getIvar(self.confirmPasswordTextfield, ivar);
    placeholderLabel3.textColor = [UIColor colorWithHexString:@"6E6E6E"];
    
    
    self.emailTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    self.confirmPasswordTextfield.delegate = self;
    
    self.emailTextfield.returnKeyType = UIReturnKeyNext;
    self.passwordTextfield.returnKeyType = UIReturnKeyNext;
    self.confirmPasswordTextfield.returnKeyType = UIReturnKeyDone;
    
    self.lblstatus.hidden = true;
    
    [self logoCheck];
    
    [self.emailTextfield addTarget:self action:@selector(validateTextfield:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextfield addTarget:self action:@selector(validateTextfield:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmPasswordTextfield addTarget:self action:@selector(validateTextfield:) forControlEvents:UIControlEventEditingChanged];
}


-(void)validateTextfield:(UITextField*)textField {
    if (self.emailTextfield.isFirstResponder) {
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.confirmPasswordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }else if (self.passwordTextfield.isFirstResponder) {
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.confirmPasswordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }else if (self.confirmPasswordTextfield.isFirstResponder) {
        self.confirmPasswordView.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }else{
        self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
        self.confirmPasswordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextfield) {
        [textField resignFirstResponder];
        [self.passwordTextfield becomeFirstResponder];
    } else if (textField == self.passwordTextfield) {
        [textField resignFirstResponder];
        [self.confirmPasswordTextfield becomeFirstResponder];
    }else if (textField == self.confirmPasswordTextfield) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.usernameView.layer.cornerRadius = 10;
    self.usernameView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.usernameView.layer.borderWidth = 1.0;
    
    self.passwordView.layer.cornerRadius = 10;
    self.passwordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.passwordView.layer.borderWidth = 1.0;
    
    self.confirmPasswordView.layer.cornerRadius = 10;
    self.confirmPasswordView.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.confirmPasswordView.layer.borderWidth = 1.0;
    
    self.signUpBtn.layer.cornerRadius = 25;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



-(IBAction)secureButtonTapped:(id)sender{
    if (self.secureButton.selected) {
        self.secureButton.selected=NO;
        self.passwordTextfield.secureTextEntry = YES;
        [self.secureButton setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }else{
        self.secureButton.selected=YES;
        self.passwordTextfield.secureTextEntry = NO;
        [self.secureButton setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
}

-(IBAction)secureButton2Tapped:(id)sender{
    if (self.secureButton2.selected) {
        self.secureButton2.selected=NO;
        self.confirmPasswordTextfield.secureTextEntry = YES;
        [self.secureButton2 setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }else{
        _secureButton2.selected=YES;
        self.confirmPasswordTextfield.secureTextEntry = NO;
        [_secureButton2 setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
}

- (IBAction)signUpButtonTapped:(id)sender {
    self.lblstatus.hidden = true;
    if (self.emailTextfield.text.length == 0) {
        self.lblstatus.text = @"Email can't be empty";
        self.lblstatus.hidden = false;
        return;
    }

    if (![self validateEmailWithString:self.emailTextfield.text]) {
        self.lblstatus.text = @"Email address invalid";
        self.lblstatus.hidden = false;
        return;
    }
    
    if (self.passwordTextfield.text.length == 0) {
        self.lblstatus.text = @"Password can't be empty";
        self.lblstatus.hidden = false;
        return;
    }
    
    if (self.passwordTextfield.text.length < 6) {
        self.lblstatus.text = @"Password can't be smaller than 6 digit";
        self.lblstatus.hidden = false;
        return;
    }
    
    if (self.confirmPasswordTextfield.text.length == 0) {
        self.lblstatus.text = @"Need confirmation password.";
        self.lblstatus.hidden = false;
        return;
    }

    if (![self.passwordTextfield.text isEqualToString:self.confirmPasswordTextfield.text]) {
        self.lblstatus.text = @"Passwords does not match";
        self.lblstatus.hidden = false;
        return;
    }

    NSString* user = self.emailTextfield.text;
    NSString *username = [NSString stringWithFormat:@"HR4411-%@", user];
    NSString* password = self.passwordTextfield.text;
    
    [self startSpinner];

    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache" };

    
    NSLog(@"joy signup credientials: %@ %@", username, password);
    
//    NSString *signUpURL = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/octavaultvpn/sign-up-free";
    NSString *signUpURL = @"https://dragonia.squarefootuni.store/free_signup_reseller_commom_production.php?app_name=octavaultvpn";
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&password=%@", password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&otp_length=4" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&verification_type=2" dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:signUpURL]
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
            
            NSLog(@"joy response signup response: %@", json);
            
            if(jsonError) {
                // check the error description
                NSLog(@"json error : %@", [jsonError localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.lblstatus.text = @"JSON Parsing Error";
                    self.lblstatus.hidden = false;
                });
                
            } else {
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                NSString *status_code = [NSString stringWithFormat:@"%@",[json valueForKey:@"status_code"]];
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                
                
                
                NSLog(@"joy response signup message: %@", message);
                
                if ([responseCode isEqualToString:@"1"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                        [keychain setString:username forKey:@"username"];
                        [keychain setString:password forKey:@"password"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *signupverificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpVerificationViewController"];
                        [self presentViewController:signupverificationViewController animated:YES completion:nil];
                        
                        [KSToastView ks_showToast: message duration:4.0f];
                    });
                    
                }else if ([responseCode isEqualToString:@"2"] && [status_code isEqualToString:@"401"]){
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                        [keychain setString:username forKey:@"username"];
                        [keychain setString:password forKey:@"password"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *signupverificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpVerificationViewController"];
                        [self presentViewController:signupverificationViewController animated:YES completion:nil];
                        
                        [KSToastView ks_showToast: message duration:4.0f];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [KSToastView ks_showToast: message duration:4.0f];
                    });
                }
            }
        }
    }];
    [dataTask resume];
}

-(IBAction)termsTapped:(id)sender{
    
}

-(IBAction)privacyTapped:(id)sender{
    
}

- (BOOL)validateEmailWithString:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



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
