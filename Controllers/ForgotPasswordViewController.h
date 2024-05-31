//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "ForgotPasswordViewController.h"
#import "BLMultiColorLoader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ForgotPasswordViewControllerDelegate<NSObject>

@optional
-(void)emailSentSuccess:(BOOL)success;

@end


@interface ForgotPasswordViewController : UIViewController
@property(assign,nonatomic) id <ForgotPasswordViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIView *backview;
@property (strong, nonatomic) IBOutlet UIView *emailborder;
@property (weak, nonatomic) IBOutlet UIView *emailview;
@property (weak, nonatomic) IBOutlet UIButton *btnreset;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UILabel *tvStatus;
@property(weak,nonatomic) IBOutlet BLMultiColorLoader *spinner;

@end

NS_ASSUME_NONNULL_END
