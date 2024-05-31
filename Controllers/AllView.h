//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllView : UIView

@property (strong, nonatomic) IBOutlet UILabel *name;
-(void) setSelected:(BOOL) selected;

@end

NS_ASSUME_NONNULL_END
