//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "ForgotPasswordViewController.h"
#import <objc/runtime.h>
#import "HexColors.h"
#import "KLCPopup.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"
#import "KSToastView.h"


@interface ForgotPasswordViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ForgotPasswordViewController
@synthesize spinner;



- (void)viewDidLoad {
    [super viewDidLoad];

    [self logoCheck];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.emailTextfield, ivar);
    placeholderLabel.textColor = [UIColor colorWithHexString:@"6E6E6E"];
    
    self.btnreset.layer.cornerRadius = 25;
    self.btnback.layer.cornerRadius = 25;
    self.backview.layer.cornerRadius = 25;
    self.emailview.layer.cornerRadius = 10;
    self.emailborder.layer.cornerRadius = 10;
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
    self.emailview.layer.cornerRadius = 10;
    self.emailview.layer.borderColor = [UIColor colorNamed:@"white10%"].CGColor;
    self.emailview.layer.borderWidth = 1.0;
    
    
    [self hideStatusView];
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

- (IBAction)backbtnTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [AppDelegate sharedAppDelegate].window.rootViewController = loginViewController;
    });
}

-(IBAction)resetbtntapped:(id)sender{
    [self verify];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[ForgotPasswordViewController class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{

    self.emailTextfield.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)verify{
    if (self.emailTextfield.text.length == 0) {
        [self updateStatus:NSLocalizedString(@"Email can't be empty", @"")];
        return;
    }
    
    if (![self validateEmailWithString:self.emailTextfield.text]) {
        [self updateStatus:NSLocalizedString(@"Email address invalid", @"")];
        return;
    }
    
    [self hideStatusView];
    [self startSpinner];
    
    NSDictionary *headers = @{
        @"Accept": @"*/*",
        @"Cache-Control": @"no-cache",
        @"accept-encoding": @"gzip, deflate",
        @"Connection": @"keep-alive",
        @"cache-control": @"no-cache" };

//    NSString *url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/octavaultvpn/forgot-password";
    NSString *url = @"https://dragonia.squarefootuni.store/forget_password_reseller_commom.php?app_name=octavaultvpn";
     
    NSString *user = self.emailTextfield.text;
    NSString *useremail = [NSString stringWithFormat:@"HR4411-%@", user];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"username=%@", useremail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&otp_length=4"] dataUsingEncoding:NSUTF8StringEncoding]];
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
                
                if ([responseCode isEqualToString:@"1"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
                        
                        [keychain setString:user forKey:@"useremail"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *emailverificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"EmailVerificationViewController"];
                        [AppDelegate sharedAppDelegate].window.rootViewController = emailverificationViewController;
                        
                        [KSToastView ks_showToast: message duration:4.0f];
                    });
                    
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [KSToastView ks_showToast: message duration:4.0f];
                    });
                    
                }
            }
        }
    }];
    [dataTask resume];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


-(void) updateStatus:(NSString *) message{
    self.tvStatus.text = message;
    self.tvStatus.hidden = NO;
}

-(void) hideStatusView{
    self.tvStatus.hidden = YES;
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
