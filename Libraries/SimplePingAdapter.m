//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "SimplePingAdapter.h"

@implementation SimplePingAdapter

-(void) startPing:(NSString *)hostName withTimeout:(NSTimeInterval) timeout{

    self.timeoutDuration = timeout;
    self.pinger = [[SimplePing alloc] initWithHostName:hostName];
    self.pinger.delegate = self;
    [self.pinger start];
}

-(void) stopPinging{
    
    if (self.pinger != nil) {
        [self.pinger stop];
    }
    
    if (self.timeoutTimer != nil) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
}

-(void) timeout{
    
    NSError *error = [NSError errorWithDomain:@"PlainPingErrorDomain" code:-100 userInfo:nil];
    if (self.delegate != nil) {
        [self.delegate didFailPingWithError:error];
    }
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
    
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeoutDuration
                                                         target:self
                                                         selector:@selector(timeout)
                                                         userInfo:nil
                                                         repeats:false];
    [self.pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    
    if (self.delegate != nil) {
        [self.delegate didSendPing];
    }
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    
    if (self.delegate != nil) {
        [self.delegate didReceivePong];
    }
    
    [self stopPinging];
}
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet{
    [self stopPinging];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    
    if (self.delegate != nil) {
        [self.delegate didFailPingWithError:error];
    }
    [self stopPinging];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    
    if (self.delegate != nil) {
        [self.delegate didFailPingWithError:error];
    }
    [self stopPinging];
    
}

@end


