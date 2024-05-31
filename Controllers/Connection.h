//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Connection : NSObject
@property(strong, nonatomic)  NSString *bundleName;
@property(strong, nonatomic)  NSString *ipName;
@property(strong, nonatomic)  NSString *ip;
@property(strong, nonatomic)  NSString *ip_id;
@property(strong, nonatomic)  NSString *note;
@property(strong, nonatomic)  NSString *typeTxt;
@property(strong, nonatomic)  NSString *type;
@property(strong, nonatomic)  NSString *priority;
@property(strong, nonatomic)  NSString *config;
@property(strong, nonatomic)  NSString *network;
@property(strong, nonatomic)  NSString *countryCode;
@property(strong, nonatomic)  NSString *vpn_server_id;
@property(strong, nonatomic)  NSString *pingTime;
@property(assign, nonatomic)  double capacityLevel;
@property(strong, nonatomic)  NSString *connectionType;
@property(strong, nonatomic)  NSString *platform;
@property(strong, nonatomic)  NSString *countryName;
@property(strong, nonatomic)  NSString *flag;
@property(assign, nonatomic)  Boolean isFree;
@property(assign, nonatomic)  Boolean isStreaming;
@property(assign, nonatomic)  Boolean isGaming;
@property(assign, nonatomic)  Boolean isAdsBloker;
@property(assign, nonatomic)  Boolean isFast;
@property(strong, nonatomic)  NSString *sortingType;
@property(strong, nonatomic)  NSString*lat;
@property(strong, nonatomic)  NSString*lng;


-(void)parseJSON:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
