//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IAPTools : NSObject

+ (NSString *)documentsDirectory;
+ (NSString *)encodeString:(NSString *)string;
+ (NSString *)decodeString:(NSString *)string;

@end

@interface IAPLoadingView : UIView

- (void)show;
- (void)dismiss;

@end
