//
//  UIView+Border.m
//  Arabnet
//
//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import "UIView+Border.h"



@implementation UIView (Border)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self addSubview:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self addSubview:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [self addSubview:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self addSubview:border];
}

@end