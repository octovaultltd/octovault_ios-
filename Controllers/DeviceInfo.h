//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfo : NSObject
@property(strong, nonatomic) NSString *deviceID;
@property(strong, nonatomic) NSString *platform;
@property(strong, nonatomic) NSString *brand;
@property(strong, nonatomic) NSString *model;
@property(strong, nonatomic) NSString *osName;
@property(strong, nonatomic) NSString *osVersion;
@property(strong, nonatomic) NSString *appVersion;
@property(strong, nonatomic) NSString *type;
@property(assign, nonatomic) int deviceType;


-(void)parseJSON:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
