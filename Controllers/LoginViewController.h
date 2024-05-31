//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *secureButton;

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *getSupport;

@property (weak, nonatomic) IBOutlet UILabel *tvStatus;
@property(weak,nonatomic) IBOutlet BLMultiColorLoader *spinner;
@property (weak, nonatomic) NSString *openPromoPage;
@property (weak, nonatomic) NSString *referTitle;
@property (weak, nonatomic) NSString *referBody;
@property (weak, nonatomic) NSString *referImage;


@end

NS_ASSUME_NONNULL_END
