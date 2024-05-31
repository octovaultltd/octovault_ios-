//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "DeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "AFNetworking.h"
#import "KSToastView.h"
#import "DeviceInfo.h"
#import <UICKeyChainStore.h>
#import "AppDelegate.h"
#import "BLMultiColorLoader.h"

@interface DeviceViewController (){
    NSUserDefaults *defaults;
    NSMutableArray *deviceList;
}
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainview.layer.cornerRadius = 10;
    self.mainborder.layer.cornerRadius = 10;
    self.btnback.layer.cornerRadius = 25;
    self.backview.layer.cornerRadius = 25;
    
    self.btnback.layer.borderColor = [UIColor colorNamed:@"orangecolor"].CGColor;
    self.btnback.layer.borderWidth = 1.5;
    
    [self getDeviceData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
     return UIStatusBarStyleLightContent;
}

- (IBAction)backbtnTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        app.window.rootViewController = tabBarController;
        [tabBarController setSelectedIndex:2];
    });
}

-(void) getDeviceData{
    [self startSpinner];
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
//    NSString* url = @"http://185.174.110.126:4041/vpn_api_v2_new/public/api_v2/get-logged-in-devices";
    NSString *url = @"https://dragonia.squarefootuni.store/deviceinfo.php";
    
    NSString *username = [keychain stringForKey:@"username"];
    NSString *password = [keychain stringForKey:@"password"];
    NSString *uuid = [keychain stringForKey:@"UUID"];
    if (uuid.length == 0) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setString:uuid forKey:@"UUID"];
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
    [postData appendData:[[NSString stringWithFormat:@"&noEcrypted=1"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&udid=%@",uuid] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSLog(@"sent device data: %@", postData);
    
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
                NSLog(@"Json device data: %@", json);
                NSString *responseCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"response_code"]];
                
                NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                [self->defaults setValue:message forKey:@"message"];
                [self->defaults synchronize];
                
                if ([responseCode isEqualToString:@"1"]) {
                    NSArray* data = [json valueForKey:@"data"];
                    self->deviceList = [[NSMutableArray alloc]init];
                    for(NSDictionary *dict in data){
                        DeviceInfo *device = [[DeviceInfo alloc] init];
                        device.model = [dict valueForKey:@"model"];
                        device.osName = [dict valueForKey:@"os_name"];
                        device.osVersion = [dict valueForKey:@"os_version"];
                        device.type = @"Item";
                        [self->deviceList addObject:device];
                    }
                    [self initDeviceList];
                }else{
                    [KSToastView ks_showToast: message duration:4.0f];
                }
                [self->defaults synchronize];
            }
        }
    }];
    [dataTask resume];
}

-(void) initDeviceList{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableview reloadData];
    });
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DeviceTableViewCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"DeviceTableViewCell" forIndexPath:indexPath];
    DeviceInfo* device = deviceList[indexPath.row];
    [cell.itemView setHidden:NO];
    NSString* deviceName;
    deviceName = [NSString stringWithFormat:@"%@", device.model];
    cell.lblDeviceName.text = deviceName;
        
    NSString* osName = [NSString stringWithFormat:@"%@ %@", device.osName, device.osVersion];
    cell.lblOsName.text = osName;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (deviceList.count == 1){
        self.tableheight.constant = 70;
    }else if (deviceList.count == 2){
        self.tableheight.constant = 120;
    }else if (deviceList.count == 3){
        self.tableheight.constant = 170;
    }else if (deviceList.count == 4){
        self.tableheight.constant = 220;
    }else if (deviceList.count == 5){
        self.tableheight.constant = 270;
    }
    return deviceList.count;
    
}

//-------Encryption & Decryption------//

-(NSString *) base64DecodedStringForResponse:(NSString *)string {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return [self EncryptOrDecryptForResponse:decodedString];
}

-(NSString *) EncryptOrDecryptForResponse:(NSString *)string {
    
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
            keyIndex = 0;
            keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
