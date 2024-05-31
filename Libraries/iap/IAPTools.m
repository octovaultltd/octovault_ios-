//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import "IAPTools.h"
@import UIKit;

@implementation IAPTools

+ (NSString *)documentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)encodeString:(NSString *)string{
    if (!string){ return nil;}
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    return encodedString;
}

+ (NSString *)decodeString:(NSString *)string{
    if (!string){ return nil;}
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end

@interface IAPLoadingView ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *contentView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation IAPLoadingView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.alpha = 0;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5];
}

- (void)show{
    self.contentView.hidden = false;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
