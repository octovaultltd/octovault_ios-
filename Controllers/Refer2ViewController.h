//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface Refer2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIView *balanceview;
@property (weak, nonatomic) IBOutlet UIView *balanceborder;
@property (weak, nonatomic) IBOutlet UILabel *balancelabel;
@property (weak, nonatomic) IBOutlet UIView *withdrawview;
@property (weak, nonatomic) IBOutlet UIButton *btnwithdraw;
@property (weak, nonatomic) IBOutlet UIView *referview;
@property (weak, nonatomic) IBOutlet UILabel *referlabel;
@property (weak, nonatomic) IBOutlet UIView *referborder;
@property (weak, nonatomic) IBOutlet UIView *btncopy;
@property (weak, nonatomic) IBOutlet UIView *btnshare;
@property (weak, nonatomic) IBOutlet UIView *btnapply;
@property (weak, nonatomic) IBOutlet UIView *redeemview;
@property (weak, nonatomic) IBOutlet UIView *redeemborder;
@property (weak, nonatomic) IBOutlet UIView *applyview;
@property (weak, nonatomic) IBOutlet UIView *applyborder;
@property (weak, nonatomic) IBOutlet UITextField *redeemcode;
@property(weak,nonatomic) IBOutlet BLMultiColorLoader *spinner;

@property (weak, nonatomic) IBOutlet UIView *referxview;



@end

NS_ASSUME_NONNULL_END
