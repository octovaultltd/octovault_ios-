//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "FavoriteView.h"
#import "HexColors.h"

@implementation FavoriteView

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
//        byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
//        cornerRadii:CGSizeMake(10, 10)
//    ];
//
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//    self.clipsToBounds = YES;
//    self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
//    self.layer.masksToBounds = YES;
    
}


-(void) setSelected:(BOOL) selected{
    
    if (selected) {
        [self createSelectedView];
    }else{
        [self createUnselectedView];
    }
}

-(void) createSelectedView{
        
    self.name.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithHexString:@"#ED1A23"];
    self.imageView.image = [UIImage imageNamed:@"love_white_border"];
    
}

-(void) createUnselectedView{
    
    self.name.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.imageView.image = [UIImage imageNamed:@"love_red"];
    
}

@end
