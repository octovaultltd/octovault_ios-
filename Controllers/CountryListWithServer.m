//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "CountryListWithServer.h"

@implementation CountryListWithServer

-(void)addObject:(NSMutableArray *)servers withName:(NSString *)name withCode:(NSString *) code withFlagName:(NSString *)flag withPriority:(int) priority{
    self.servers = [[NSMutableArray alloc] initWithArray:servers];
    self.countryCode = code;
    self.CountryName = name;
    self.countryFlag = flag;
    self.priority = priority;
    
}


-(void)addArrayObject:(NSArray *)servers withName:(NSString *)name withCode:(NSString *) code withFlagName:(NSString *)flag withPriority:(int) priority{
    self.servers = [[NSMutableArray alloc] initWithArray:servers];
    self.countryCode = code;
    self.CountryName = name;
    self.countryFlag = flag;
    self.priority = priority;
    
}
@end
