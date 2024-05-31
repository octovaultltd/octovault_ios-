//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "Connection.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CountryTableViewCellDelegate<NSObject>

@optional
-(void)connectionButton:(id)sender andConnection:(Connection*)connection withIndexPath:(NSIndexPath*)indexPath;
-(void)favouriteButton:(id)sender andConnection:(Connection*)connection;

@end
@interface CountryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (strong, nonatomic) IBOutlet UIView *rootView;


@property(assign,nonatomic) id <CountryTableViewCellDelegate> delegate;
@property (strong, nonatomic) Connection *connection;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

NS_ASSUME_NONNULL_END
