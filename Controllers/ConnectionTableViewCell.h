//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "FLCircleProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ConnectionTableViewCellDelegate<NSObject>

@optional
-(void)connectionButton:(id)sender andConnection:(Connection*)connection;
-(void)favouriteButton:(id)sender andConnection:(Connection*)connection;


@end

@interface ConnectionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ipAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UISwitch *connectionSwitch;
@property (strong, nonatomic) IBOutlet UIButton *connectionButton;
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIImageView *networkImageView;


@property(assign,nonatomic) id <ConnectionTableViewCellDelegate> delegate;
@property (strong, nonatomic) Connection *connection;
@property (weak, nonatomic) IBOutlet FLCircleProgressView *circularView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *pingLabel;


@end



NS_ASSUME_NONNULL_END
