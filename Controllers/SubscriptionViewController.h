//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubscriptionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *subscriptionimage;
@property (strong, nonatomic) IBOutlet UILabel* subscriptionTitle;
@property (strong, nonatomic) IBOutlet UILabel* subscriptionExpiry;
@property (strong, nonatomic) IBOutlet UILabel* subscriptionPrice;
@property (strong, nonatomic) IBOutlet UILabel* subscriptionSubTitle;
@property (strong, nonatomic) IBOutlet UIView *upgradeview;
@property (strong, nonatomic) IBOutlet UIView *upgradeborder;
@property (strong, nonatomic) IBOutlet UIView *terminateview;
@property (strong, nonatomic) IBOutlet UIView *terminateborder;
@property (strong, nonatomic) IBOutlet UIView *backview;
@property (strong, nonatomic) IBOutlet UIButton *btnback;
@property (strong, nonatomic) IBOutlet UIButton *btnterminate;
@property (strong, nonatomic) IBOutlet UIButton *btnautorenew;
@property (strong, nonatomic) IBOutlet UIButton *btnupgrade;
@property (strong, nonatomic) IBOutlet UIImageView *sliderimage;
@property (weak, nonatomic) IBOutlet UIView *renewView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *renewalHC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *terminateHC;

@end

NS_ASSUME_NONNULL_END
