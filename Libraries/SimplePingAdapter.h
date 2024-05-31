//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import <Foundation/Foundation.h>
#import "SimplePing.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  SimplePingAdapterDelegate;

@interface SimplePingAdapter : NSObject<SimplePingDelegate>
@property (strong, nonatomic) id <SimplePingAdapterDelegate>delegate;
@property (strong, nonatomic) SimplePing *pinger;
@property (weak, nonatomic) NSTimer *timeoutTimer;
@property (assign, nonatomic) NSTimeInterval timeoutDuration;

-(void) startPing:(NSString *)hostName withTimeout:(NSTimeInterval) timeout;
-(void) stopPinging;
@end

@protocol SimplePingAdapterDelegate<NSObject>
@optional
-(void) didSendPing;
-(void) didReceivePong;
-(void) didFailPingWithError:(NSError *) error;
@end

NS_ASSUME_NONNULL_END
