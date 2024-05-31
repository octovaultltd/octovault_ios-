//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <Foundation/Foundation.h>
#import "SimplePingAdapter.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PlainPingCompletion)(double elapsedTimeMs, NSError *error);

@interface PlainPing : NSObject<SimplePingAdapterDelegate>
@property (assign, nonatomic) NSTimeInterval pingStartTime;
@property (strong, nonatomic) SimplePingAdapter *pingAdapter;
@property (strong, nonatomic) PlainPingCompletion completionBlock;
+(void) ping:(NSString *)hostName withTimeout:(NSTimeInterval) timeout withCompletionBlock:(PlainPingCompletion)completionBlock;
@end

NS_ASSUME_NONNULL_END
