//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "PlainPing.h"

@implementation PlainPing
+(void) ping:(NSString *)hostName withTimeout:(NSTimeInterval) timeout withCompletionBlock:(PlainPingCompletion)completionBlock{
    
    PlainPing *plainPing = [[PlainPing alloc] init];
    plainPing.pingAdapter= [[SimplePingAdapter alloc] init];
    plainPing.pingAdapter.delegate = plainPing;
    plainPing.completionBlock = completionBlock;
    [plainPing.pingAdapter startPing:hostName withTimeout:timeout];
    
}

-(void) finalizePing:(NSTimeInterval) latency withError:(NSError *)error{
    
    if (latency != 0) {
        double elapsedTimeMs = latency*1000;
        if (self.completionBlock != nil) {
            self.completionBlock(elapsedTimeMs, error);
        }
    }else{
        self.completionBlock(0, error);
    }
    
    self.pingAdapter.delegate = nil;
    self.pingAdapter = nil;
}

- (void)didSendPing{
    self.pingStartTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)didReceivePong{
    double latency = [NSDate timeIntervalSinceReferenceDate] - self.pingStartTime;
    [self finalizePing:latency withError:nil];
}

- (void)didFailPingWithError:(NSError *)error{
    [self finalizePing:0 withError:error];
}

@end
