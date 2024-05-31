//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "PasswordResetViewController.h"
#import <UICKeyChainStore.h>
#import <objc/runtime.h>
#import "HexColors.h"
#import "KLCPopup.h"
#import "AppDelegate.h"
#import "KSToastView.h"



@interface PasswordResetViewController ()

@end

@implementation PasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self logoCheck];
    
    self.lblstatus.hidden = true;
    self.password1.layer.cornerRadius = 10;
    self.password1border.layer.cornerRadius = 10;
    self.password2.layer.cornerRadius = 10;
    self.password2border.layer.cornerRadius = 10;
    self.btnsave.layer.cornerRadius = 25;
    
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.tfpassword1, ivar);
    placeholderLabel.textColor = [UIColor colorNamed:@"white30%"];

    UILabel *placeholderLabel2 = object_getIvar(self.tfpassword2, ivar);
    placeholderLabel2.textColor = [UIColor colorNamed:@"white30%"];

    
    self.tfpassword1.delegate = self;
    self.tfpassword2.delegate = self;
    
    self.tfpassword1.returnKeyType = UIReturnKeyNext;
    self.tfpassword2.returnKeyType = UIReturnKeyDone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.tfpassword1) {
        [textField resignFirstResponder];
        [self.tfpassword2 becomeFirstResponder];
    } else if (textField == self.tfpassword2) {
        [textField resignFirstResponder];
    }
    return YES;
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

-(IBAction)secureButton1Tapped:(id)sender{
    if (_show1.selected) {
        _show1.selected=NO;
        self.tfpassword1.secureTextEntry = YES;
        [_show1 setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }
    else{
        _show1.selected=YES;
        self.tfpassword1.secureTextEntry = NO;
        [_show1 setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
}

-(IBAction)secureButton2Tapped:(id)sender{
    if (_show2.selected) {
        _show2.selected=NO;
        self.tfpassword2.secureTextEntry = YES;
        [_show2 setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }
    else{
        _show2.selected=YES;
        self.tfpassword2.secureTextEntry = NO;
        [_show2 setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
}

-(IBAction)savebtnTapped:(id)sender{
    self.lblstatus.hidden = YES;
    
    if (self.tfpassword1.text.length < 6) {
        [self updateStatus:NSLocalizedString(@"Password can't be smaller than 6 digit", @"")];
        return;
    }

    if (![self.tfpassword2.text isEqualToString:self.tfpassword1.text]) {
        [self updateStatus:NSLocalizedString(@"Password does not match", @"")];
        return;
    }
    
    NSString* password = self.tfpassword1.text;
    NSString* confirm_password = self.tfpassword2.text;
    
    [self startSpinner];
    
    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache" };

//    NSString *url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/reset-password";
    NSString *url = @"https://dragonia.squarefootuni.store/reset_new_password.php";
    

    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *user = [keychain stringForKey:@"useremail"];
    NSString *useremail = [NSString stringWithFormat:@"HR4411-%@", user];
    NSString *token = [keychain stringForKey:@"token"];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", useremail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&password=%@", password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&password_confirmation=%@", confirm_password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];


    NSLog(@"joy print signup verification body: %@ %@ %@ %@", useremail, password, confirm_password, token);
    
    
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
                
                if ([responseCode isEqualToString:@"1"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                        
                        [keychain setString:user forKey:@"username"];
                        [keychain setString:password forKey:@"password"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                        [AppDelegate sharedAppDelegate].window.rootViewController = loginViewController;
                        
                        [KSToastView ks_showToast: message duration:4.0f];
                        
                    });
                    
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
//                        [self updateStatus:message];

                        [KSToastView ks_showToast: message duration:4.0f];
                    });
                    
                }
            }
        }
    }];
    [dataTask resume];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

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

-(void) updateStatus:(NSString *) message{
    self.lblstatus.text = message;
    self.lblstatus.hidden = NO;
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
