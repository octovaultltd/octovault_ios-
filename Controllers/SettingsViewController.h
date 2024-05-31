//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnnotificationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnkillSwitch;
@property(weak,nonatomic) IBOutlet BLMultiColorLoader *spinner;
@property(weak,nonatomic) IBOutlet UIView *notificationview;
@property(weak,nonatomic) IBOutlet UIView *notificationborder;
@property(weak,nonatomic) IBOutlet UIView *deletview;
@property(weak,nonatomic) IBOutlet UIView *deleteborder;
@property(weak,nonatomic) IBOutlet UIView *backview;
@property(weak,nonatomic) IBOutlet UIButton *btnback;
@property(weak,nonatomic) IBOutlet UIImageView *notificationimage;
@property(weak,nonatomic) IBOutlet UIImageView *killswitchimage;

@property (weak, nonatomic) IBOutlet UIView *noty;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notyHC;


@end

