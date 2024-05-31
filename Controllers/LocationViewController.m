//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "LocationViewController.h"
#import "AppDelegate.h"
#import "Connection.h"
#import <objc/runtime.h>
#import "KLCPopup.h"
#import "KSToastView.h"

@interface LocationViewController () {
    NSMutableArray *allcountryWiseConnection;
    NSMutableArray *fliteredCountryWiseConnection;
    NSMutableArray *sectionHeaderViewArray;
    NSMutableArray *bookMarkedServers;
    NSMutableArray *filteredBookMarkedServers;
    NSMutableArray *fastServer;
    NSMutableArray *filtredFastServer;
    NSMutableArray *adsBlockerServer;
    NSMutableArray *filtredAdsBlockerServer;
    NSMutableArray *streamingServer;
    NSMutableArray *filtredStreamingServer;
    NSMutableArray *lastServer;
    NSMutableArray *filtredLastServer;
    BOOL isFastActive;
    BOOL isStreamActive;
    BOOL isAdsActive;
    BOOL searchActive;
    BOOL isFavoriteActive;
    BOOL isAllActive;
    BOOL isLastActive;
    NSUserDefaults *defaults;
    NSString* text;
    Connection *selectedConnection;
}
@end

@implementation LocationViewController
NSMutableArray * arrayForBool;

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
    
    self.searchview.layer.cornerRadius = 10;
    self.searchborder.layer.cornerRadius = 10;
    self.allview.layer.cornerRadius = 10;
    self.allborder.layer.cornerRadius = 10;
    self.favview.layer.cornerRadius = 10;
    self.favborder.layer.cornerRadius = 10;
    self.lastview.layer.cornerRadius = 10;
    self.lastborder.layer.cornerRadius = 10;
    self.highview.layer.cornerRadius = 10;
    self.highborder.layer.cornerRadius = 10;
    self.addview.layer.cornerRadius = 10;
    self.addborder.layer.cornerRadius = 10;
    self.streamview.layer.cornerRadius = 10;
    self.streamborder.layer.cornerRadius = 10;
    
    searchActive = NO;
    isFavoriteActive = NO;
    isFastActive = NO;
    isStreamActive = NO;
    isAdsActive = NO;
    isAllActive = YES;
    isLastActive = NO;
        
    defaults = [NSUserDefaults standardUserDefaults];
    bookMarkedServers = [[NSMutableArray alloc] init];
    filteredBookMarkedServers = [[NSMutableArray alloc] init];
    fastServer = [[NSMutableArray alloc] init];
    filtredFastServer = [[NSMutableArray alloc] init];
    adsBlockerServer = [[NSMutableArray alloc] init];
    filtredAdsBlockerServer = [[NSMutableArray alloc] init];
    streamingServer = [[NSMutableArray alloc] init];
    filtredStreamingServer = [[NSMutableArray alloc] init];
    lastServer = [[NSMutableArray alloc] init];
    filtredLastServer = [[NSMutableArray alloc] init];
    
    [self parseServerData];
    [self rearrangeServers];
    [self updateUI];
    [self updateSelectedSection];
}

-(void) viewDidAppear:(BOOL)animated{
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self scrollToSelectedPosition];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void) updateUI{
    self.searchTextfield.layer.cornerRadius = self.searchTextfield.frame.size.height/2;
    self.searchTextfield.clipsToBounds = YES;
    self.searchTextfield.delegate = self;
    [self.searchTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.searchTextfield, ivar);
    placeholderLabel.textColor = [UIColor colorNamed:@"white30%"];
    
    self.tabView.layer.cornerRadius = 10.0;
    self.tabView.clipsToBounds = YES;
    
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

-(void)textFieldDidChange:(UITextField*)textField{
    text = textField.text;
    if(text.length == 0){
        searchActive = FALSE;
    }else{
        searchActive = true;
        if (isFavoriteActive) {
            filteredBookMarkedServers = [[NSMutableArray alloc] init];
            for (Connection* connection in bookMarkedServers){
                NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
                if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                    [filteredBookMarkedServers addObject:connection];
                }
            }
        }else if(isAdsActive) {
            filtredAdsBlockerServer = [[NSMutableArray alloc] init];
            for (Connection* connection in adsBlockerServer){
                NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
                if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                    [filtredAdsBlockerServer addObject:connection];
                }
            }
        }else if(isLastActive) {
            filtredLastServer = [[NSMutableArray alloc] init];
            for (Connection* connection in lastServer){
                NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
                if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                    [filtredLastServer addObject:connection];
                }
            }
        }else if(isFastActive) {
            filtredFastServer = [[NSMutableArray alloc] init];
            for (Connection* connection in fastServer){
                NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
                if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                    [filtredFastServer addObject:connection];
                }
            }
        }else if(isStreamActive) {
            filtredStreamingServer = [[NSMutableArray alloc] init];
            for (Connection* connection in streamingServer){
                NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
                if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                    [filtredStreamingServer addObject:connection];
                }
            }
        }else{
            fliteredCountryWiseConnection = [[NSMutableArray alloc] init];
            for (CountryListWithServer* country in allcountryWiseConnection){
                NSRange nameRange1 = [country.CountryName rangeOfString:text options:NSCaseInsensitiveSearch];
                if(nameRange1.location != NSNotFound){
                    [fliteredCountryWiseConnection addObject:country];
                }else{
                    CountryListWithServer *tempCountry = [[CountryListWithServer alloc] init];
                    for (Connection *conn in country.servers) {
                        NSRange nameRange2 = [conn.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                        if (nameRange2.location != NSNotFound) {
                            tempCountry.CountryName = country.CountryName;
                            tempCountry.countryCode = country.countryCode;
                            tempCountry.countryFlag = country.countryFlag;
                            if (tempCountry.servers == nil) {
                                tempCountry.servers = [[NSMutableArray alloc] init];
                            }
                            [tempCountry.servers addObject:conn];
                        }
                    }
                    if (tempCountry.servers != nil && tempCountry.servers.count>0) {
                        [fliteredCountryWiseConnection addObject:tempCountry];
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CountryListWithServer *obj;
    if (isFavoriteActive) {
        if (searchActive) {
            return filteredBookMarkedServers.count;
        }else{
            return bookMarkedServers.count;
        }
    }else if (isFastActive) {
        if (searchActive) {
            return filtredFastServer.count;
        }else{
            return fastServer.count;
        }
    }else if (isLastActive) {
        if (searchActive) {
            return filtredLastServer.count;
        }else{
            return lastServer.count;
        }
    }else if (isStreamActive) {
        if (searchActive) {
            return filtredStreamingServer.count;
        }else{
            return streamingServer.count;
        }
    }else if (isAdsActive) {
        if (searchActive) {
            return filtredAdsBlockerServer.count;
        }else{
            return adsBlockerServer.count;
        }
    }else{
        BOOL manyCells  = [[ arrayForBool objectAtIndex:section] boolValue];
        if (searchActive) {
            obj = fliteredCountryWiseConnection[section];
        }else{
            obj = allcountryWiseConnection[section];
        }
        
        if (!manyCells) {
            return 0;
        }
        return [obj.servers count];
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
            
            NSLog(@"ipbundles : %@", bundles);
            
            NSMutableArray *lastUsedIpID = [defaults objectForKey:@"lastServer"];
            
            self.allConnections = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in bundles) {
                
                Connection *connection = [[Connection alloc] init];
                [connection parseJSON:dict];
                
                for(NSString *ipID in lastUsedIpID){
                    if([ipID isEqualToString: connection.ip_id]){
                        [lastServer addObject:connection];
                    }
                }
                
                if ([connection.connectionType isEqualToString:@"1"]) {
                    if([connection.platform isEqualToString:@"all"] || [connection.platform isEqualToString:@"ios"]){
                        [self.allConnections addObject:connection];
                    }
                }
            }
            
            NSLog(@"allconnection count: %lu", self.allConnections.count);
            NSLog(@"last count: %lu", lastServer.count);
            NSLog(@"last item: %@", lastServer);
            
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

-(Connection *) getSelectedServerConnection{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedConnectionID = [userDefaults valueForKey:@"selectedConnectionID"];
    [defaults synchronize];
    for (Connection* conn in self.allConnections){
        if ([selectedConnectionID isEqualToString:conn.ip_id]) {
            return conn;
        }
    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StateCell";
    CountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    Connection *connection;
 
//    NSLog(isLastActive ? @"Yes" : @"No");
    
    if (self.allConnections.count > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"selectedConnectionID"]) {
            selectedConnection = [self getSelectedServerConnection];
        }
    }else{
        selectedConnection = nil;
    }
        
    BOOL manyCells = YES;
    
    if (isFavoriteActive) {
        if (searchActive) {
            connection = filteredBookMarkedServers[indexPath.row];
        }else{
            connection = bookMarkedServers[indexPath.row];
        }
    }else if (isFastActive) {
        if (searchActive) {
            connection = filtredFastServer[indexPath.row];
        }else{
            connection = fastServer[indexPath.row];
        }
    }else if (isLastActive) {
        if (searchActive) {
            connection = filtredLastServer[indexPath.row];
        }else{
            connection = lastServer[indexPath.row];
        }
    }else if (isStreamActive) {
        if (searchActive) {
            connection = filtredStreamingServer[indexPath.row];
        }else{
            connection = streamingServer[indexPath.row];
        }
    }else if (isAdsActive) {
        if (searchActive) {
            connection = filtredAdsBlockerServer[indexPath.row];
        }else{
            connection = adsBlockerServer[indexPath.row];
        }
    }else{
        manyCells  = [[ arrayForBool objectAtIndex:indexPath.section] boolValue];
        CountryListWithServer *obj;
        if (searchActive) {
            obj = fliteredCountryWiseConnection[indexPath.section];
        }else{
            obj = allcountryWiseConnection[indexPath.section];
        }
        connection = obj.servers[indexPath.row];
    }
        
    if(!manyCells){
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.text = @"";
    }else{
        cell.indexPath = indexPath;
        cell.connection = connection;
        cell.name.text = connection.ipName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        BOOL selected = NO;
        BOOL favorite = NO;
        
        NSString *selectedID = [defaults valueForKey:@"selectedConnectionID"];
        
        if ([selectedID isEqualToString:connection.ip_id]) {
            selected = YES;
        }else {
            selected = NO;
        }
        
        if (selected) {
            cell.selectedImageView.image = [UIImage imageNamed:@"icoselected"];
        }else{
            cell.selectedImageView.image = [UIImage imageNamed:@"icoselectednot"];
        }
        
        NSString* favKey = [NSString stringWithFormat:@"FavouriteList-%@", [defaults valueForKey:@"username"]];
        NSMutableArray *favouriteListArray = [[defaults objectForKey:favKey] mutableCopy];
        
        if ([favouriteListArray isKindOfClass:[NSArray class]] && favouriteListArray) {
            favorite = NO;
            for (NSString *ip in favouriteListArray) {
                if ([ip isEqualToString:connection.ip_id]) {
                    favorite = YES;
                }
            }
        }
        
        if (favorite) {
            cell.favoriteImageView.image = [UIImage imageNamed:@"icofav"];
        }else{
            cell.favoriteImageView.image = [UIImage imageNamed:@"icofavnot"];
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (isFavoriteActive) {
        return 1;
    }if (isFastActive) {
        return 1;
    }if (isStreamActive) {
        return 1;
    }if (isLastActive) {
        return 1;
    }if (isAdsActive) {
        return 1;
    }else{
        if (searchActive) {
            return fliteredCountryWiseConnection.count;
        }else{
            return allcountryWiseConnection.count;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isFavoriteActive) {
        return 0;
    }
    if (isAdsActive) {
        return 0;
    }
    if (isLastActive) {
        return 0;
    }
    if (isFastActive) {
        return 0;
    }
    if (isStreamActive) {
        return 0;
    }
    return 50;
}

-(UIView *) createSectionView{
    CGFloat width = self.tableView.frame.size.width;
    UIView *sectionViewnew = [[UIView alloc]initWithFrame:CGRectMake(20, 0, width, 50)];
    sectionViewnew.backgroundColor =[UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 37, 24)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 101;
    [sectionViewnew addSubview:imageView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, 250, 24)];
    name.textColor = [UIColor whiteColor];
    name.tag = 102;
    [sectionViewnew addSubview:name];
    
    UIImageView *loadView = [[UIImageView alloc] initWithFrame:CGRectMake(width-45, 15, 20, 20)];
    loadView.contentMode = UIViewContentModeScaleAspectFit;
    loadView.tag = 103;
    [sectionViewnew addSubview:loadView];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(width-20, 15, 20, 20)];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    arrowView.tag = 100;
    [sectionViewnew addSubview:arrowView];

    return sectionViewnew;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (isFavoriteActive) {
        return NULL;
    }
    if (isFastActive) {
        return NULL;
    }
    if (isLastActive) {
        return NULL;
    }
    if (isStreamActive) {
        return NULL;
    }
    if (isAdsActive) {
        return NULL;
    }
    
    UIView *sectionViewnew = sectionHeaderViewArray[section];
    sectionViewnew.tag = section;
    UILabel *name = (UILabel *)[sectionViewnew viewWithTag:102];
    UIImageView *imageView = (UIImageView*)[sectionViewnew viewWithTag:101];
    UIImageView *loadView = (UIImageView*)[sectionViewnew viewWithTag:103];
    UIImageView *arrowView = (UIImageView*)[sectionViewnew viewWithTag:100];
    
    CountryListWithServer *obj;
    if (searchActive) {
        obj = fliteredCountryWiseConnection[section];
    }else{
        obj = allcountryWiseConnection[section];
    }
    
    name.text = [NSString stringWithFormat:@"%@",obj.CountryName];
    BOOL collapsed  = [[ arrayForBool objectAtIndex:section] boolValue];
    imageView.image = [UIImage imageNamed:obj.countryFlag];
    if(collapsed){
        arrowView.image = [UIImage imageNamed:@"icorowmin"];
    }else{
        arrowView.image = [UIImage imageNamed:@"icorowmax"];
    }
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionViewnew addGestureRecognizer:headerTapped];
    
    return  sectionViewnew;
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    BOOL collapsed  = [[ arrayForBool objectAtIndex:indexPath.section] boolValue];
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:!collapsed]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)connectionButton:(id)sender andConnection:(Connection *)connection withIndexPath:(NSIndexPath *)indexPath{
    if ([connection.ip containsString:@"8.8.8.8"]) {
        [KSToastView ks_showToast:@"Server Locked"];
    }else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:connection.ip_id forKey:@"selectedConnectionID"];
        [lastServer addObject:connection];
        
        NSMutableArray *lastUsedIpID = [[NSMutableArray alloc] init];
        for(Connection *con in lastServer){
            if(![lastUsedIpID containsObject:connection.ip_id]){
                [lastUsedIpID addObject: con.ip_id];
            }
        }
        
        [defaults setObject:lastUsedIpID forKey:@"lastServer"];
        [defaults setInteger:indexPath.section forKey:@"selectedSection"];
        [defaults setInteger:indexPath.row forKey:@"selectedRow"];
        
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectVPN" object:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            app.window.rootViewController = tabBarController;
        });
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)favouriteButton:(id)sender andConnection:(Connection *)connection{
    if(![connection.ip containsString:@"8.8.8.8"]){
        NSString* favKey = [NSString stringWithFormat:@"FavouriteList-%@", [defaults valueForKey:@"username"]];
        NSMutableArray *favouriteListArray = [[defaults objectForKey:favKey] mutableCopy];
        
        if (![favouriteListArray isKindOfClass:[NSArray class]]) {
            favouriteListArray = [[NSMutableArray alloc]init];
            [favouriteListArray addObject:connection.ip_id];
        }else {
            BOOL didFound = false;
            for (int i=0; i<favouriteListArray.count; i++) {
                NSString *ip = [favouriteListArray objectAtIndex:i];
                if ([ip isEqualToString:connection.ip_id]) {
                    [favouriteListArray removeObjectAtIndex:i];
                    didFound = true;
                }
            }
            if (!didFound) {
                [favouriteListArray addObject:connection.ip_id];
            }
        }
        [defaults setObject:favouriteListArray forKey:favKey];
        [defaults synchronize];
        [self.tableView reloadData];
    }
}

-(void)updateSelectedSection{
    if(isAllActive){
        if((allcountryWiseConnection.count >0) || (fliteredCountryWiseConnection.count >0)){
            self.noServerStatus.hidden = true;
        }else{
            self.noServerStatus.hidden = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.allborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
            self.favborder.backgroundColor = [UIColor blackColor];
            self.lastborder.backgroundColor = [UIColor blackColor];
            self.highborder.backgroundColor = [UIColor blackColor];
            self.addborder.backgroundColor = [UIColor blackColor];
            self.streamborder.backgroundColor = [UIColor blackColor];
            
            self.allServer.textColor = [UIColor blackColor];
            self.favServer.textColor = [UIColor colorNamed:@"white30%"];
            self.lastServer.textColor = [UIColor colorNamed:@"white30%"];
            self.highServer.textColor = [UIColor colorNamed:@"white30%"];
            self.addServer.textColor = [UIColor colorNamed:@"white30%"];
            self.streemServer.textColor = [UIColor colorNamed:@"white30%"];
        });
    }if(isFavoriteActive){
        if((bookMarkedServers.count >0) || (filteredBookMarkedServers.count >0)){
            self.noServerStatus.hidden = true;
        }else{
            self.noServerStatus.hidden = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.favborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
            self.allborder.backgroundColor = [UIColor blackColor];
            self.lastborder.backgroundColor = [UIColor blackColor];
            self.streamborder.backgroundColor = [UIColor blackColor];
            self.highborder.backgroundColor = [UIColor blackColor];
            self.addborder.backgroundColor = [UIColor blackColor];
            
            self.favServer.textColor = [UIColor blackColor];
            self.allServer.textColor = [UIColor colorNamed:@"white30%"];
            self.lastServer.textColor = [UIColor colorNamed:@"white30%"];
            self.highServer.textColor = [UIColor colorNamed:@"white30%"];
            self.addServer.textColor = [UIColor colorNamed:@"white30%"];
            self.streemServer.textColor = [UIColor colorNamed:@"white30%"];
        });
    }if(isLastActive){
        if((lastServer.count >0) || (filtredLastServer.count >0)){
            self.noServerStatus.hidden = true;
        }else{
            self.noServerStatus.hidden = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.lastborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
            self.highborder.backgroundColor = [UIColor blackColor];
            self.addborder.backgroundColor = [UIColor blackColor];
            self.favborder.backgroundColor = [UIColor blackColor];
            self.streamborder.backgroundColor = [UIColor blackColor];
            self.allborder.backgroundColor = [UIColor blackColor];
            
            self.lastServer.textColor = [UIColor blackColor];
            self.allServer.textColor = [UIColor colorNamed:@"white30%"];
            self.addServer.textColor = [UIColor colorNamed:@"white30%"];
            self.favServer.textColor = [UIColor colorNamed:@"white30%"];
            self.highServer.textColor = [UIColor colorNamed:@"white30%"];
            self.streemServer.textColor = [UIColor colorNamed:@"white30%"];
        });
    }if(isFastActive){
        if((fastServer.count >0) || (filtredFastServer.count >0)){
            self.noServerStatus.hidden = true;
        }else{
            self.noServerStatus.hidden = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.highborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
            self.allborder.backgroundColor = [UIColor blackColor];
            self.streamborder.backgroundColor = [UIColor blackColor];
            self.addborder.backgroundColor = [UIColor blackColor];
            self.lastborder.backgroundColor = [UIColor blackColor];
            self.favborder.backgroundColor = [UIColor blackColor];
            
            self.highServer.textColor = [UIColor blackColor];
            self.allServer.textColor = [UIColor colorNamed:@"white30%"];
            self.favServer.textColor = [UIColor colorNamed:@"white30%"];
            self.addServer.textColor = [UIColor colorNamed:@"white30%"];
            self.streemServer.textColor = [UIColor colorNamed:@"white30%"];
            self.lastServer.textColor = [UIColor colorNamed:@"white30%"];
        });
    }if(isStreamActive){
        if((streamingServer.count >0) || (filtredStreamingServer.count >0)){
            self.noServerStatus.hidden = true;
        }else{
            self.noServerStatus.hidden = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.streamborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
            self.allborder.backgroundColor = [UIColor blackColor];
            self.favborder.backgroundColor = [UIColor blackColor];
            self.lastborder.backgroundColor = [UIColor blackColor];
            self.highborder.backgroundColor = [UIColor blackColor];
            self.addborder.backgroundColor = [UIColor blackColor];
            
            self.streemServer.textColor = [UIColor blackColor];
            self.allServer.textColor = [UIColor colorNamed:@"white30%"];
            self.favServer.textColor = [UIColor colorNamed:@"white30%"];
            self.addServer.textColor = [UIColor colorNamed:@"white30%"];
            self.highServer.textColor = [UIColor colorNamed:@"white30%"];
            self.lastServer.textColor = [UIColor colorNamed:@"white30%"];
        });
    }if(isAdsActive){
        if((adsBlockerServer.count >0) || (filtredAdsBlockerServer.count >0)){
            self.noServerStatus.hidden = true;
        }else{
            self.noServerStatus.hidden = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.addborder.backgroundColor = [UIColor colorNamed:@"orangecolor"];
            self.allborder.backgroundColor = [UIColor blackColor];
            self.favborder.backgroundColor = [UIColor blackColor];
            self.highview.backgroundColor = [UIColor blackColor];
            self.lastborder.backgroundColor = [UIColor blackColor];
            self.streamborder.backgroundColor = [UIColor blackColor];
            
            self.addServer.textColor = [UIColor blackColor];
            self.lastServer.textColor = [UIColor colorNamed:@"white30%"];
            self.favServer.textColor = [UIColor colorNamed:@"white30%"];
            self.allServer.textColor = [UIColor colorNamed:@"white30%"];
            self.streemServer.textColor = [UIColor colorNamed:@"white30%"];
            self.highServer.textColor = [UIColor colorNamed:@"white30%"];
        });
    }
}

-(void) rearrangeServers{
    allcountryWiseConnection = [[NSMutableArray alloc] init];
    fliteredCountryWiseConnection = [[NSMutableArray alloc] init];
    arrayForBool = [[NSMutableArray alloc] init];
    sectionHeaderViewArray = [[NSMutableArray alloc] init];
    NSMutableArray *countryCodeList = [[NSMutableArray alloc] init];
    
    adsBlockerServer = [[NSMutableArray alloc] init];
    fastServer = [[NSMutableArray alloc] init];
    streamingServer = [[NSMutableArray alloc] init];
    
    NSMutableArray *unsortedCountry = [[NSMutableArray alloc] init];
    
    for (int i= 0; i< self.allConnections.count; i++) {
        
        Connection *conn = self.allConnections[i];
        if (![countryCodeList containsObject:conn.countryCode]) {
            [countryCodeList addObject:conn.countryCode];
        }
        
        if(conn.isFast){
            [fastServer addObject:conn];
        }
        
        if(conn.isAdsBloker){
            [adsBlockerServer addObject:conn];
        }
        
        if(conn.isStreaming){
            [streamingServer addObject:conn];
        }
    }
    
    NSLog(@"strm server count: %lu", streamingServer.count);
    NSLog(@"ads server count: %lu", adsBlockerServer.count);
    NSLog(@"fast server count: %lu", fastServer.count);
    NSLog(@"last server count: %lu", lastServer.count);
    
    for (int j=0; j<countryCodeList.count; j++) {
        CountryListWithServer *obj = [[CountryListWithServer alloc] init];
        NSString* code = countryCodeList[j];
        NSString *countryName;
        NSString *countryFlag;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        int priority = 99999;
        
        for (int i= 0; i< self.allConnections.count; i++) {
            Connection *conn = self.allConnections[i];
            if (code == conn.countryCode) {
                countryName = conn.countryName;
                countryFlag = conn.flag;
                if (priority > [conn.priority intValue]) {
                    priority = [conn.priority intValue];
                }
                [temp addObject:conn];
            }
        }
        
        [obj addArrayObject:[self sortInnerServerAlphabeticallyWithPriority:temp] withName:countryName withCode:code withFlagName:countryFlag withPriority:priority];
        [unsortedCountry addObject:obj];
        UIView *tempView = [self createSectionView];
        [sectionHeaderViewArray addObject:tempView];
    }
    
    NSSortDescriptor *sorts = [NSSortDescriptor sortDescriptorWithKey:@"CountryName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *alphabeticallySortedArray = [unsortedCountry sortedArrayUsingDescriptors:@[sorts]];
    NSArray *sortedCountryArray = [alphabeticallySortedArray sortedArrayUsingComparator:^NSComparisonResult(CountryListWithServer* obj1, CountryListWithServer *obj2) {
        if (obj1.priority > obj2.priority) {
          return (NSComparisonResult)NSOrderedDescending;
        }

        if (obj1.priority < obj2.priority) {
          return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
      }];
    
    [allcountryWiseConnection addObjectsFromArray:sortedCountryArray];
    
    for (int i=0; i<[ countryCodeList count]; i++) {
        [ arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
}


-(NSArray *) sortInnerServerAlphabeticallyWithPriority:(NSArray *) unsortedArray{
    NSSortDescriptor *sortserver = [NSSortDescriptor sortDescriptorWithKey:@"ipName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *alphabeticallySortedArray = [unsortedArray sortedArrayUsingDescriptors:@[sortserver]];
    NSArray *sortedCountryArray = [alphabeticallySortedArray sortedArrayUsingComparator:^NSComparisonResult(Connection* obj1, Connection *obj2) {
        if ([obj1.priority intValue] > [obj2.priority intValue]) {
          return (NSComparisonResult)NSOrderedDescending;
        }

        if ([obj1.priority intValue] < [obj2.priority intValue]) {
          return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
      }];
    
    return sortedCountryArray;
}

-(IBAction) allButtonTapped:(id)sender{
    if(!searchActive){
        isFavoriteActive = NO;
        isFastActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isAllActive = YES;
        isLastActive = NO;
        [self.tableView reloadData];
        [self scrollToSelectedPosition];
    }else{
        isFavoriteActive = NO;
        isFastActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isAllActive = YES;
        isLastActive = NO;
        
        fliteredCountryWiseConnection = [[NSMutableArray alloc] init];
        for (CountryListWithServer* country in allcountryWiseConnection){
            NSRange nameRange1 = [country.CountryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange1.location != NSNotFound){
                [fliteredCountryWiseConnection addObject:country];
            }else{
                CountryListWithServer *tempCountry = [[CountryListWithServer alloc] init];
                for (Connection *conn in country.servers) {
                    NSRange nameRange2 = [conn.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
                    if (nameRange2.location != NSNotFound) {
                        tempCountry.CountryName = country.CountryName;
                        tempCountry.countryCode = country.countryCode;
                        tempCountry.countryFlag = country.countryFlag;
                        if (tempCountry.servers == nil) {
                            tempCountry.servers = [[NSMutableArray alloc] init];
                        }
                        [tempCountry.servers addObject:conn];
                    }
                }
                if (tempCountry.servers != nil && tempCountry.servers.count>0) {
                    [fliteredCountryWiseConnection addObject:tempCountry];
                }
            }
        }
        [self.tableView reloadData];
    }
    [self updateSelectedSection];
}


-(IBAction) favoriteButtonTapped:(id)sender{
    if(!searchActive){
        if (isFavoriteActive) {
            return;
        };
        isFavoriteActive = YES;
        isFastActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isAllActive = NO;
        isLastActive = NO;
        
        NSString* favKey = [NSString stringWithFormat:@"FavouriteList-%@", [defaults valueForKey:@"username"]];
        NSMutableArray *favouriteListArray = [[defaults objectForKey:favKey] mutableCopy];
        if ([favouriteListArray isKindOfClass:[NSArray class]] && favouriteListArray.count>0) {
            bookMarkedServers = [[NSMutableArray alloc] init];
            
            for (int i = 0; i<self.allConnections.count; i++) {
                Connection *conn = self.allConnections[i];
                
                if ([favouriteListArray containsObject:conn.ip_id]) {
                    [bookMarkedServers addObject:conn];
                }
            }
        }else{
            bookMarkedServers = [[NSMutableArray alloc] init];
        }
        [self.tableView reloadData];
    }else{
        if (isFavoriteActive) {
            return;
        };
        isFavoriteActive = YES;
        isFastActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isAllActive = NO;
        isLastActive = NO;
        NSString* favKey = [NSString stringWithFormat:@"FavouriteList-%@", [defaults valueForKey:@"username"]];
        NSMutableArray *favouriteListArray = [[defaults objectForKey:favKey] mutableCopy];
        if ([favouriteListArray isKindOfClass:[NSArray class]] && favouriteListArray.count>0) {
            bookMarkedServers = [[NSMutableArray alloc] init];
            
            for (int i = 0; i<self.allConnections.count; i++) {
                Connection *conn = self.allConnections[i];
                
                if ([favouriteListArray containsObject:conn.ip_id]) {
                    [bookMarkedServers addObject:conn];
                }
            }
        }else{
            bookMarkedServers = [[NSMutableArray alloc] init];
        }
        filteredBookMarkedServers = [[NSMutableArray alloc] init];
        for (Connection* connection in bookMarkedServers){
            NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                [filteredBookMarkedServers addObject:connection];
            }
        }
        [self.tableView reloadData];
    }
    [self updateSelectedSection];
}

- (IBAction)lastUsedTapped:(id)sender {
    if(!searchActive){
        if (isLastActive) {
            return;
        };
        isFavoriteActive = NO;
        isFastActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isAllActive = NO;
        isLastActive = YES;
        
        [self.tableView reloadData];
        [self scrollToSelectedPosition];
    }else{
        if (isLastActive) {
            return;
        };
        isFavoriteActive = NO;
        isFastActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isAllActive = NO;
        isLastActive = YES;
        
        
        filtredLastServer = [[NSMutableArray alloc] init];
        for (Connection* connection in lastServer){
            NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                [filtredLastServer addObject:connection];
            }
        }
        [self.tableView reloadData];
    }
    [self updateSelectedSection];
}

- (IBAction)highSpeedTapped:(id)sender {
    if(!searchActive){
        if (isFastActive) {
            return;
        };
        isFastActive = YES;
        isFavoriteActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isLastActive = NO;
        isAllActive = NO;
        
        [self.tableView reloadData];
        [self scrollToSelectedPosition];
    }else{
        if (isFastActive) {
            return;
        };
        isFastActive = YES;
        isFavoriteActive = NO;
        isAdsActive = NO;
        isStreamActive = NO;
        isLastActive = NO;
        isAllActive = NO;
        
        filtredFastServer = [[NSMutableArray alloc] init];
        for (Connection* connection in fastServer){
            NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                [filtredFastServer addObject:connection];
            }
        }
        [self.tableView reloadData];
    }
    [self updateSelectedSection];
}

- (IBAction)streemingTapped:(id)sender {
    if(!searchActive){
        if (isStreamActive) {
            return;
        };
        isStreamActive = YES;
        isFavoriteActive = NO;
        isFastActive = NO;
        isAdsActive = NO;
        isLastActive = NO;
        isAllActive = NO;
        
        [self.tableView reloadData];
        [self scrollToSelectedPosition];
    }else{
        if (isStreamActive) {
            return;
        };
        isStreamActive = YES;
        isFavoriteActive = NO;
        isFastActive = NO;
        isAdsActive = NO;
        isLastActive = NO;
        isAllActive = NO;
        
        filtredStreamingServer = [[NSMutableArray alloc] init];
        for (Connection* connection in streamingServer){
            NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                [filtredStreamingServer addObject:connection];
            }
        }
        [self.tableView reloadData];
    }
    [self updateSelectedSection];
}

- (IBAction)addBlokerTapped:(id)sender {
    if(!searchActive){
        if (isAdsActive) {
            return;
        };
        isAdsActive = YES;
        isFavoriteActive = NO;
        isFastActive = NO;
        isStreamActive = NO;
        isLastActive = NO;
        isAllActive = NO;
        
        [self.tableView reloadData];
        [self scrollToSelectedPosition];
    }else{
        if (isAdsActive) {
            return;
        };
        isAdsActive = YES;
        isFavoriteActive = NO;
        isFastActive = NO;
        isStreamActive = NO;
        isLastActive = NO;
        isAllActive = NO;
        
        filtredAdsBlockerServer = [[NSMutableArray alloc] init];
        for (Connection* connection in adsBlockerServer){
            NSRange nameRange1 = [connection.ipName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [connection.countryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if((nameRange1.location != NSNotFound)|| (nameRange2.location != NSNotFound)){
                [filtredAdsBlockerServer addObject:connection];
            }
        }
        [self.tableView reloadData];
    }
    [self updateSelectedSection];
}

- (void)scrollToSelectedPosition{

}

-(BOOL) isRowPresentInTableView:(NSInteger)row withSection:(NSInteger)section{
    if(section < [self.tableView numberOfSections])
    {
        if(row < [self.tableView numberOfRowsInSection:section])
        {
            return YES;
        }
    }
    return NO;
}


@end
