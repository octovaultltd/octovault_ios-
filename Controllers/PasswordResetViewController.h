//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordResetViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property(weak,nonatomic) IBOutlet UIView *password1;
@property(weak,nonatomic) IBOutlet UIView *password2;
@property(weak,nonatomic) IBOutlet UIView *password1border;
@property(weak,nonatomic) IBOutlet UIView *password2border;
@property(strong, nonatomic) IBOutlet UITextField *tfpassword1;
@property(strong, nonatomic) IBOutlet UITextField *tfpassword2;
@property(weak,nonatomic) IBOutlet UILabel *lblstatus;
@property(weak,nonatomic) IBOutlet UIButton *show1;
@property(weak,nonatomic) IBOutlet UIButton *show2;
@property(weak,nonatomic) IBOutlet UIButton *btnsave;
@property(weak,nonatomic) IBOutlet BLMultiColorLoader *spinner;

@end

NS_ASSUME_NONNULL_END
