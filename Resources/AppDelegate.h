//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>
#import "LGSideMenuController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

-(void)loadInAppProducts:(NSArray*)productList;
-(NSString *) base64DecodedString:(NSString *)string;
- (void)saveContext;
-(BOOL)reachable;
-(NSString *) base64DecodedStringForLoginResponse:(NSString *)string;
+ (AppDelegate *)sharedAppDelegate;

@end

