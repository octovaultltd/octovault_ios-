//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextfield;
@property (strong, nonatomic) IBOutlet UILabel *lblstatus;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordView;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet UIButton *secureButton;
@property (strong, nonatomic) IBOutlet UIButton *secureButton2;

@property(weak,nonatomic) IBOutlet BLMultiColorLoader *spinner;

@end

NS_ASSUME_NONNULL_END
