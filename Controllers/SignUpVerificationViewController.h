//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpVerificationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *verificationID;

@property (strong, nonatomic) IBOutlet UIImageView*logo;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view1border;
@property (weak, nonatomic) IBOutlet UIView *view2border;
@property (weak, nonatomic) IBOutlet UIView *view3border;
@property (weak, nonatomic) IBOutlet UIView *view4border;
@property (weak, nonatomic) IBOutlet UIView *btnverify;
@property (weak, nonatomic) IBOutlet UIView *btnback;
@property (weak, nonatomic) IBOutlet UIView *viewback;
@property (weak, nonatomic) IBOutlet UILabel *lblstatus;
@property (weak, nonatomic) IBOutlet UIView *btnresend;
@property (weak, nonatomic) IBOutlet BLMultiColorLoader *loaderview;
@property (weak, nonatomic) IBOutlet UITextField *digit1;
@property (weak, nonatomic) IBOutlet UITextField *digit2;
@property (weak, nonatomic) IBOutlet UITextField *digit3;
@property (weak, nonatomic) IBOutlet UITextField *digit4;


@end

NS_ASSUME_NONNULL_END
