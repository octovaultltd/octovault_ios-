//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *subscriptionview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* subscriptionHeight;
@property (weak, nonatomic) IBOutlet UIView *subscriptionborder;
@property (weak, nonatomic) IBOutlet UIView *settingview;
@property (weak, nonatomic) IBOutlet UIView *settingborder;
@property (weak, nonatomic) IBOutlet UIView *supportview;
@property (weak, nonatomic) IBOutlet UIView *supportborder;
@property (weak, nonatomic) IBOutlet UIView *logout1;
@property (weak, nonatomic) IBOutlet UIView *logout2;
@property (weak, nonatomic) IBOutlet UIView *logout2border;

@property (weak, nonatomic) IBOutlet UIButton *btnlogout;
@property (weak, nonatomic) IBOutlet UIButton *btnsubscription;
@property (weak, nonatomic) IBOutlet UIButton *btnsetting;
@property (weak, nonatomic) IBOutlet UIButton *btndevice;
@property (weak, nonatomic) IBOutlet UIButton *btnrefer;
@property (weak, nonatomic) IBOutlet UIButton *btnsupport;
@property (weak, nonatomic) IBOutlet UIButton *btnaboutus;

@property (weak, nonatomic) IBOutlet UILabel *lbluserid;
@property (weak, nonatomic) IBOutlet UILabel *lblsubscription;
@property (weak, nonatomic) IBOutlet UILabel *lblsubsextra;
@property (weak, nonatomic) IBOutlet UIImageView *imgsubs;


@end

NS_ASSUME_NONNULL_END
