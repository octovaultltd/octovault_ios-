//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (strong, nonatomic) IBOutlet UILabel *lblPlatform;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (strong, nonatomic) IBOutlet UILabel *lblOsName;
@property (strong, nonatomic) IBOutlet UILabel *lblAppVersion;

@end

NS_ASSUME_NONNULL_END
