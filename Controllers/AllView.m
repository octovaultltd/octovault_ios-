//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "AllView.h"
#import "HexColors.h"

@implementation AllView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setCornerRardius];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setCornerRardius];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCornerRardius];
    }
    return self;
}

-(void) setCornerRardius{

//    UIBezierPath *maskPath = [UIBezierPath
//        bezierPathWithRoundedRect:self.bounds
//        byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
//        cornerRadii:CGSizeMake(10, 10)
//    ];
//
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//    self.clipsToBounds = YES;
//    self.layer.masksToBounds = YES;
}

-(void) createSelectedView{
        
    self.name.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithHexString:@"#ED1A23"];
    
}

-(void) createUnselectedView{
    
    self.name.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

-(void) setSelected:(BOOL) selected{
    
    if (selected) {
        [self createSelectedView];
    }else{
        [self createUnselectedView];
    }
}

@end
