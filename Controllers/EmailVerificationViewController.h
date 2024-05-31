//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmailVerificationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *verificationID;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIView *cancelview;
@property (strong, nonatomic) IBOutlet UIButton *btncancel;
@property (strong, nonatomic) IBOutlet UIButton *btnverify;
@property (strong, nonatomic) IBOutlet UIButton *btnresend;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view1border;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view2border;
@property (strong, nonatomic) IBOutlet UIView *view3border;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view4border;
@property (strong, nonatomic) IBOutlet UILabel *lblstatus;
@property (strong, nonatomic) IBOutlet BLMultiColorLoader *loaderview;
@property (strong, nonatomic) IBOutlet UITextField *digit1;
@property (strong, nonatomic) IBOutlet UITextField *digit2;
@property (strong, nonatomic) IBOutlet UITextField *digit3;
@property (strong, nonatomic) IBOutlet UITextField *digit4;

@end

NS_ASSUME_NONNULL_END
