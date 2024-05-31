//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutUsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UIImageView *termimage;
@property (weak, nonatomic) IBOutlet UIView *mainborder;
@property (weak, nonatomic) IBOutlet UIView *mainview;
@property (weak, nonatomic) IBOutlet UIView *termview;
@property (weak, nonatomic) IBOutlet UIView *termborder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *termHeight;
@property (weak, nonatomic) IBOutlet UIView *termDetailsView;

@end

NS_ASSUME_NONNULL_END
