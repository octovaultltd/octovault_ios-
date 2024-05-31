//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PricingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *backview;
@property (strong, nonatomic) IBOutlet UIView *item1view;
@property (strong, nonatomic) IBOutlet UIView *item2view;
@property (strong, nonatomic) IBOutlet UIView *item3view;
@property (strong, nonatomic) IBOutlet UIView *item4view;
@property (strong, nonatomic) IBOutlet UILabel *sign1;
@property (strong, nonatomic) IBOutlet UILabel *sign2;
@property (strong, nonatomic) IBOutlet UILabel *sign3;
@property (strong, nonatomic) IBOutlet UILabel *sign4;
@property (strong, nonatomic) IBOutlet UILabel *highlightedText1;
@property (strong, nonatomic) IBOutlet UILabel *highlightedText2;
@property (strong, nonatomic) IBOutlet UILabel *highlightedText3;
@property (strong, nonatomic) IBOutlet UILabel *highlightedText4;
@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UILabel *title3;
@property (strong, nonatomic) IBOutlet UILabel *title4;
@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *price2;
@property (strong, nonatomic) IBOutlet UILabel *price3;
@property (strong, nonatomic) IBOutlet UILabel *price4;
@property (strong, nonatomic) IBOutlet UILabel *monthly1;
@property (strong, nonatomic) IBOutlet UILabel *monthly2;
@property (strong, nonatomic) IBOutlet UILabel *monthly3;
@property (strong, nonatomic) IBOutlet UILabel *monthly4;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btnback;
@property (strong, nonatomic) IBOutlet UIButton *btnterms;
@property (strong, nonatomic) IBOutlet UIButton *btnpolicy;
@property (strong, nonatomic) IBOutlet UIButton *btngetpremium;
@property (strong, nonatomic) IBOutlet UIButton *btnrestore;
@property (strong, nonatomic) IBOutlet BLMultiColorLoader *loaderview;
@property (strong, nonatomic) IBOutlet UIView *package;

@end

NS_ASSUME_NONNULL_END
