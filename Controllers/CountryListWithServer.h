//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryListWithServer : NSObject

@property(strong, nonatomic)  NSString *CountryName;
@property(strong, nonatomic)  NSString *countryCode;
@property(strong, nonatomic)  NSString *countryFlag;
@property(assign, nonatomic)  int priority;
@property(strong, nonatomic)  NSMutableArray *servers;

-(void)addObject:(NSMutableArray *)servers withName:(NSString *)name withCode:(NSString *) code withFlagName:(NSString *)flag withPriority:(int) priority;
-(void)addArrayObject:(NSArray *)servers withName:(NSString *)name withCode:(NSString *) code withFlagName:(NSString *)flag withPriority:(int) priority;
@end

NS_ASSUME_NONNULL_END
