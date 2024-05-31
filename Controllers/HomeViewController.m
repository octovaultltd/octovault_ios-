//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "HomeViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"
#import "MKStoreKit.h"
#import "KLCPopup.h"
#import "AppDelegate.h"
#import "Connection.h"
#import <UICKeyChainStore.h>
#import "Connection.h"
#import "ConnectionTableViewCell.h"
#import "JHNetworkSpeed.h"
#import "KSToastView.h"
#import <NetworkExtension/NETunnelProviderManager.h>
#import <NetworkExtension/NEVPNConnection.h>

@interface HomeViewController (){
    Connection *selectedConnection;
    BOOL isVPNConnected;
    BOOL isNetworkUpdateMethodCalled;
    JHNetworkSpeed *speed;
    NSUserDefaults *defaults;
}
@end

@implementation HomeViewController{
    __block NETunnelProviderManager * vpnManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:0];
    item1.image = [[UIImage imageNamed:@"1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"111"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:1];
    item2.image = [[UIImage imageNamed:@"2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"222"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:2];
    item3.image = [[UIImage imageNamed:@"3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"333"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.serverview.layer.cornerRadius = 16;
    self.serverborder.layer.cornerRadius = 16;
    self.uploadview.layer.cornerRadius = 16;
    self.uploadborder.layer.cornerRadius = 16;
    self.downloadview.layer.cornerRadius = 16;
    self.downloadborder.layer.cornerRadius = 16;
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeMutedStandard;
    [self.mapView setZoomEnabled:false];
    self.mapView.showsCompass = false;
    self.mapView.showsPointsOfInterest = false;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self parseServerData];
    if (selectedConnection == nil){
        selectedConnection = _allConnections[0];
        [self receiveNotification:nil];
    }
    
    CLLocation *RBCloc = [[CLLocation alloc] initWithLatitude:selectedConnection.lat.doubleValue longitude:selectedConnection.lng.doubleValue];
    [self updateLocation:RBCloc :selectedConnection.ipName];
    
    [self checkVPNStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:NEVPNStatusDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nowDisconnectVPN)
                                                 name:@"LogoutNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processVPNConnection)
                                                 name:@"connectVPN"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkVPNStatus)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
     return UIStatusBarStyleLightContent;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView* annotationView = [[MKPinAnnotationView alloc] init];
    [annotationView setPinTintColor: [UIColor yellowColor]];
    return annotationView;
}

-(void)updateLocation:(CLLocation*) location :(NSString*)title{
    MKPointAnnotation* point = [[MKPointAnnotation alloc] init];
    point.title = title;
    point.coordinate = location.coordinate;
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self.mapView addAnnotation:point];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000000, 1000000);
    [self.mapView setRegion: viewRegion animated:YES];
}

-(void) checkVPNStatus{
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray* newManagers, NSError *error){
        if(error != nil){
            NSLog(@"Load Preferences error: %@", error);
        }else{
            if([newManagers count] > 0){
                self->vpnManager = newManagers[0];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:@"disconnected" forKey:@"status"];
            }
            if (!self->vpnManager.enabled) {
                [[NSUserDefaults standardUserDefaults] setValue:@"disconnected" forKey:@"status"];
            }
        }
            if (self->vpnManager.enabled) {
            NEVPNConnection *cnn = [self->vpnManager connection];
            if (cnn.status == NEVPNStatusConnected) {
                [self changeStatus:@"connected"];
            }
            else if (cnn.status == NEVPNStatusDisconnected){
                [self changeStatus:@"disconnected"];
            }else {
                [self changeStatus:@"disconnected"];
            }
            [self->defaults synchronize];
        }else{
            [self->defaults synchronize];
        }
    }];
}

-(void) processVPNConnection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    selectedConnection = [self getSelectedServerConnection];
    NSString *userType = [defaults valueForKey:@"userType"];
    if ([userType isEqualToString:@"1"] || [userType isEqualToString:@"2"]){
        if (isVPNConnected){
            [vpnManager.connection stopVPNTunnel];
            NSTimeInterval delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self startEnterpriseVPN];
            });
        }else{
            [self startEnterpriseVPN];
        }
    }else {
        [KSToastView ks_showToast:@"Free user"];
    }
}

-(void) startEnterpriseVPN{
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray* newManagers, NSError *error){
        if(error != nil){
            NSLog(@"Load Preferences error: %@", error);
        }else{
            if([newManagers count] > 0){
                self->vpnManager = newManagers[0];
            }else{
                self->vpnManager = [[NETunnelProviderManager alloc] init];
            }
            
            [self->vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error){
                if(error != nil){
                    NSLog(@"Load Preferences error: %@", error);
                }else{
                    __block NETunnelProviderProtocol *protocol = [[NETunnelProviderProtocol alloc] init];
                    
                    [self->defaults setObject:[NSDate date] forKey:@"StartDate"];
                    [self->defaults setValue:self->selectedConnection.ip forKey:@"selectedIP"];
                    [self->defaults setValue:self->selectedConnection.ip forKey:@"server"];
                    
                    if([self->selectedConnection.type isEqualToString:@"2"]){
                        protocol.providerBundleIdentifier = @"com.spinytel.octovault.PacketTunnel";
                        
                        NSString *usernameS = [self->defaults valueForKey:@"username"];
                        NSString *passwordS = [self->defaults valueForKey:@"password"];
                        NSString *serverS = self->selectedConnection.ip;
                        
                        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.spinytel.octovault"];
                        [userDefaults setValue:@"openconnect" forKey:@"vpnCategory"];
                        [userDefaults synchronize];
                        
                        protocol.providerConfiguration = @{@"server": serverS,
                                                           @"username": usernameS,
                                                           @"password": passwordS
                        };
                        protocol.serverAddress = serverS;
                    }
                    
                    [self->defaults synchronize];
                    
                    self->vpnManager.localizedDescription = @"OctoVault VPN";
                    self->vpnManager.protocolConfiguration = protocol;
                    [self->vpnManager setEnabled:true];
                    
                    // Check If KillSwitch Is On
                    if([self->defaults boolForKey:@"KillSwitchEnabled"]){
                        NSLog(@"KillSwitch Enabled");
                        NEOnDemandRuleConnect* rule = [[NEOnDemandRuleConnect alloc] init];
                        rule.interfaceTypeMatch = NEOnDemandRuleInterfaceTypeAny;
                        NSArray* onDemandRules = [[NSArray alloc] initWithObjects:rule, nil];
                        [self->vpnManager setOnDemandRules:onDemandRules];
                        
                        [self->vpnManager setOnDemandEnabled:YES];
                    }else{
                        NSLog(@"KillSwitch Disabled");
                        [self->vpnManager setOnDemandEnabled:NO];
                    }
                    
                    [self->vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error){
                        if (error != nil) {
                            NSLog(@"Save to Preferences Error: %@", error);
                        }else{
                            NSLog(@"Save successfully");
                            [[NSUserDefaults standardUserDefaults] setValue:@"connecting" forKey:@"status"];
                            
                            if([self->selectedConnection.type isEqualToString:@"2"]){
                                [self openTunnel];
                            }
                        }
                    }];
                }}];
        }
    }];
}

- (void) openTunnel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self->vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if(error != nil){
            NSLog(@"%@", error);
        }else{
            NSString *usernameS = [self->defaults valueForKey:@"username"];
            NSString *passwordS = [self->defaults valueForKey:@"password"];
            
            NSError *startError = nil;
            if([self->selectedConnection.type isEqualToString:@"2"]){
                [self->vpnManager.connection startVPNTunnelWithOptions:nil andReturnError:&startError];
            }
            
            NSLog(@"user details: %@ %@ %@ %@", usernameS, passwordS, self->selectedConnection.ip, self->selectedConnection.type);
            
            if(startError != nil){
                NSLog(@"%@", startError);
            }else{
                NSLog(@"Complete");
                [self receiveNotification:nil];
            }
        }
    }];
}

- (void) receiveNotification:(NSNotification *) notification{
    NEVPNStatus status;
    status = vpnManager.connection.status;
    NSString *stat;
    
    if(status == NEVPNStatusInvalid){
        NSLog(@"NEVPNStatusInvalid");
        stat = @"disconnected";
        isNetworkUpdateMethodCalled = NO;
    }
    if(status == NEVPNStatusConnecting){
        NSLog(@"NEVPNStatusConnecting");
        stat = @"connecting";
        isNetworkUpdateMethodCalled = NO;
    }
    if(status == NEVPNStatusReasserting){
        NSLog(@"NEVPNStatusReasserting");
        stat = @"reasserting";
        isNetworkUpdateMethodCalled = NO;
    }
    if(status == NEVPNStatusConnected){
        NSLog(@"NEVPNStatusConnected");
        stat = @"connected";
        isNetworkUpdateMethodCalled = NO;
    }
    if(status == NEVPNStatusDisconnected){
        NSLog(@"NEVPNStatusDisconnected");
        stat = @"disconnected";
        isNetworkUpdateMethodCalled = NO;
    }
    if(status == NEVPNStatusDisconnecting){
        NSLog(@"NEVPNStatusDisconnecting");
        stat = @"disconnecting";
        isNetworkUpdateMethodCalled = NO;
    }
    [self changeStatus:stat];
    return;
}

-(void)changeStatus:(NSString*)status{
    [[NSUserDefaults standardUserDefaults] setValue:status forKey:@"status"];
    
    if ([status isEqualToString:@"connected"]) {
        self.start.image = [UIImage imageNamed:@"icostop"];
        self.status.text = @"VPN Connected";
        self.mapView.layer.cornerRadius = 10;
        self.mapView.layer.borderColor = [UIColor colorNamed:@"14C096"].CGColor;
        self.mapView.layer.borderWidth = 2.0;
        self.status.textColor = [UIColor colorNamed:@"14C096"];
        self.downloadtag.textColor = [UIColor colorNamed:@"white30%"];
        self.uploadtag.textColor = [UIColor colorNamed:@"white30%"];
        self.download.textColor = [UIColor whiteColor];
        self.upload.textColor = [UIColor whiteColor];
        self.countryname.text = selectedConnection.ipName;
        isVPNConnected = YES;
        NSString *ip = selectedConnection.ip;
        NSString* iptext = [ip componentsSeparatedByString:@":"][0];
        self.countryPing.text = iptext;
        self.downloadimage.image = [UIImage imageNamed:@"icocondown"];
        self.uploadimage.image = [UIImage imageNamed:@"icoconup"];
        self.countryimage.image = [UIImage imageNamed:selectedConnection.flag];
        if (isNetworkUpdateMethodCalled == NO) {
            isNetworkUpdateMethodCalled = YES;
        }
        [self updateNetworkStatus];
    }else if ([status isEqualToString:@"disconnected"]){
        self.start.image = [UIImage imageNamed:@"icostart"];
        self.status.text = @"VPN Disconnected";
        self.mapView.layer.cornerRadius = 10;
        self.mapView.layer.borderColor = [UIColor colorNamed:@"E84E4E"].CGColor;
        self.mapView.layer.borderWidth = 1.0;
        isVPNConnected = NO;
        self.status.textColor = [UIColor colorNamed:@"E84E4E"];
        self.downloadtag.textColor = [UIColor colorNamed:@"white10%"];
        self.uploadtag.textColor = [UIColor colorNamed:@"white10%"];
        self.download.textColor = [UIColor colorNamed:@"white30%"];
        self.upload.textColor = [UIColor colorNamed:@"white30%"];
        self.countryname.text = selectedConnection.ipName;
        self.countryPing.text = @"Last used location";
        self.downloadimage.image = [UIImage imageNamed:@"icodisdown"];
        self.uploadimage.image = [UIImage imageNamed:@"icodisup"];
        self.countryimage.image = [UIImage imageNamed:selectedConnection.flag];
        NSString *ip = selectedConnection.ip;
        NSString* iptext = [ip componentsSeparatedByString:@":"][0];
        self.iplabel.text = iptext;
        [self stopSpeedTest];
    }else if ([status isEqualToString:@"connecting"]){
        self.status.text = @"VPN Connecting";
        self.mapView.layer.cornerRadius = 10;
        self.mapView.layer.borderColor = [UIColor colorNamed:@"E84E4E"].CGColor;
        self.mapView.layer.borderWidth = 1.0;
        self.countryname.text = selectedConnection.ipName;
        self.countryPing.text = @"Last used location";
        self.countryimage.image = [UIImage imageNamed:selectedConnection.flag];
        NSString *ip = selectedConnection.ip;
        NSString* iptext = [ip componentsSeparatedByString:@":"][0];
        self.iplabel.text = iptext;
        self.downloadimage.image = [UIImage imageNamed:@"icodisdown"];
        self.uploadimage.image = [UIImage imageNamed:@"icodisup"];
    }else if ([status isEqualToString:@"disconnecting"]){
        self.status.text = @"VPN Disonnecting";
        self.mapView.layer.cornerRadius = 10;
        self.mapView.layer.borderColor = [UIColor colorNamed:@"E84E4E"].CGColor;
        self.mapView.layer.borderWidth = 1.0;
        self.countryname.text = selectedConnection.ipName;
        self.countryPing.text = @"Last used location";
        self.countryimage.image = [UIImage imageNamed:selectedConnection.flag];
        NSString *ip = selectedConnection.ip;
        NSString* iptext = [ip componentsSeparatedByString:@":"][0];
        self.iplabel.text = iptext;
        self.downloadimage.image = [UIImage imageNamed:@"icodisdown"];
        self.uploadimage.image = [UIImage imageNamed:@"icodisup"];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        self.countryimage.image = [UIImage imageNamed:@"map"];
        self.iplabel.text = @"Guest-Login";
    }
}

-(NSString *) retrieveIP:(NSString *) iptext{
    if ([iptext containsString:@":"]) {
        return [iptext componentsSeparatedByString:@":"][0];
    }else{
        return iptext;
    }
}

-(void)parseServerData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"data"];
    if (data.length > 0) {
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError) {
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        }else {
            NSArray *bundles = [json valueForKey:@"ip_bundle"];
            self.allConnections = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in bundles) {
                Connection *connection = [[Connection alloc] init];
                [connection parseJSON:dict];
                if ([connection.connectionType isEqualToString:@"1"]) {
                    if([connection.platform isEqualToString:@"all"] || [connection.platform isEqualToString:@"ios"]){
                        [self.allConnections addObject:connection];
                    }
                }
            }
            if (self.allConnections.count > 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([userDefaults objectForKey:@"selectedConnectionID"]) {
                    selectedConnection = [self getSelectedServerConnection];
                }
            }else{
                selectedConnection = nil;
            }
        }
    }else {
    }
}

-(IBAction)startTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    BOOL isVPNConnected = [defaults boolForKey:@"isVPNConnected"];
    if(!realUser){
        [KSToastView ks_showToast:@"Server Locked for Guest User"];
    }else{
        if(isVPNConnected){
            [self nowDisconnectVPN];
        }else{
            if ([selectedConnection.ip containsString:@"8.8.8.8"]) {
                [KSToastView ks_showToast:@"Server Locked"];
            }else {
                [self startEnterpriseVPN];
                [defaults setBool:YES forKey:@"isVPNConnected"];
                [defaults synchronize];
            }
        }
    }
}
    
-(void)nowDisconnectVPN{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isVPNConnected"];
    [defaults synchronize];
    [vpnManager.connection stopVPNTunnel];
}

-(Connection *) getSelectedServerConnection{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedConnectionID = [userDefaults valueForKey:@"selectedConnectionID"];
    
    for (Connection* conn in self.allConnections){
        if ([selectedConnectionID isEqualToString:conn.ip_id]) {
            return conn;
        }
    }
    return  nil;
}

-(void)updateNetworkStatus{
    __weak typeof(self) ws = self;
    speed = [JHNetworkSpeed share];
    [speed start];
    speed.speedBlock = ^(NSString * _Nonnull uploadSpeed, NSString * _Nonnull downloadSpeed, NSString * _Nonnull totalDownload, NSString * _Nonnull totalUpload) {
        
        if ([uploadSpeed containsString:@"--"]) {
            NSString *strimedup = [uploadSpeed stringByReplacingOccurrencesOfString:@"." withString:@","];
            NSArray *arr = [strimedup componentsSeparatedByString:@"--"];
            ws.upload.text = [NSString stringWithFormat:@"%@ %@",arr[0] ? arr[0] : @"0",arr[1] ? arr[1] : @"B/s"];
        }else{
            ws.upload.text =@"0,0 mb/s";
        }
        
        if ([downloadSpeed containsString:@"--"]) {
            NSString *strimeddown = [downloadSpeed stringByReplacingOccurrencesOfString:@"." withString:@","];
            NSArray *arr = [strimeddown componentsSeparatedByString:@"--"];
            ws.download.text = [NSString stringWithFormat:@"%@ %@",arr[0] ? arr[0] : @"0",arr[1] ? arr[1] : @"B/s"];
        }else{
            ws.download.text =@"0,0 mb/s";
        }
    
        NSTimeInterval connectedTime = [self->vpnManager.connection.connectedDate timeIntervalSinceDate:[NSDate date]];
        NSString *connectedString = [self stringFromTimeInterval:connectedTime];
        connectedString = [connectedString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.iplabel.text = connectedString;
    };
}

-(void)stopSpeedTest{
    isNetworkUpdateMethodCalled = NO;
    self.download.text =@"0,0 mb/s";
    self.upload.text =@"0,0 mb/s";
    JHNetworkSpeed *speed = [JHNetworkSpeed share];
    [speed stop];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)signInAlert{
//    UIView* contentView = [[UIView alloc] init];
//    contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    contentView.backgroundColor = [UIColor whiteColor];
//    contentView.layer.cornerRadius = 15.0;
//
//    // Create Title Label
//    UILabel* labelTitle = [[UILabel alloc] init];
//    labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor blackColor];
//    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.numberOfLines = 0;
//    labelTitle.text = @"Sign-up or Login to enable this feature.";
//
//    // Create Cancel Button
//    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
//    cancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
//    cancelButton.backgroundColor = [UIColor grayColor];
//    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[[cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [cancelButton setTitle:NSLocalizedString(@"CANCEL", @"") forState:UIControlStateNormal];
//    cancelButton.layer.cornerRadius = 15.0;
//    [cancelButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//    // Create Ok Button
//    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    okButton.translatesAutoresizingMaskIntoConstraints = NO;
//    okButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
//    okButton.backgroundColor = [UIColor colorNamed:@"E84E4E"];
//    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [okButton setTitleColor:[[okButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [okButton setTitle:@"ENABLE" forState:UIControlStateNormal];
//    okButton.layer.cornerRadius = 15.0;
//    [okButton addTarget:self action:@selector(enableCalled:) forControlEvents:UIControlEventTouchUpInside];
//
//    // Add Views
//    [contentView addSubview:labelTitle];
//    [contentView addSubview:okButton];
//    [contentView addSubview:cancelButton];
//
//    // Add Constraints
//    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, labelTitle, okButton, cancelButton);
//
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[labelTitle]-(20)-[okButton]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[labelTitle]-(20)-[cancelButton]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[labelTitle]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[okButton]-(20)-[cancelButton]-(20)-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[labelTitle(==250)][okButton(==120)][cancelButton(==120)]"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
//
//    [popup show];
//}
//
//- (void)dismissButtonPressed:(id)sender {
//    [sender dismissPresentingPopup];
//}
//
//- (void)enableCalled:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *splitViewController = [storyboard instantiateViewControllerWithIdentifier:@"SplitViewController"];
//        [AppDelegate sharedAppDelegate].window.rootViewController = splitViewController;
//    });
//}



@end
