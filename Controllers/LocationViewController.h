//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import "CountryTableViewCell.h"
#import "CountryListWithServer.h"
#import "AllView.h"
#import "FavoriteView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol LocationViewControllerCellDelegate<NSObject>

-(void)connectionButton:(id)sender andConnection:(Connection*)connection withIndexPath:(NSIndexPath*)indexPath;

@end

@interface LocationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CountryTableViewCellDelegate,UITextFieldDelegate>


@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *allConnections;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property(assign,nonatomic) id <LocationViewControllerCellDelegate> delegate;
@property(nonatomic, weak) IBOutlet UIView *tabView;
@property(nonatomic, weak) IBOutlet AllView *viewAll;
@property(nonatomic, weak) IBOutlet FavoriteView *viewFavorite;


@property (weak, nonatomic) IBOutlet UIView *searchview;
@property (weak, nonatomic) IBOutlet UIView *searchborder;
@property (weak, nonatomic) IBOutlet UIView *allview;
@property (weak, nonatomic) IBOutlet UIView *allborder;
@property (weak, nonatomic) IBOutlet UIView *favview;
@property (weak, nonatomic) IBOutlet UIView *favborder;
@property (weak, nonatomic) IBOutlet UIView *highview;
@property (weak, nonatomic) IBOutlet UIView *highborder;
@property (weak, nonatomic) IBOutlet UIView *streamview;
@property (weak, nonatomic) IBOutlet UIView *streamborder;
@property (weak, nonatomic) IBOutlet UIView *addview;
@property (weak, nonatomic) IBOutlet UIView *addborder;
@property (weak, nonatomic) IBOutlet UIView *lastview;
@property (weak, nonatomic) IBOutlet UIView *lastborder;
@property (weak, nonatomic) IBOutlet UILabel* allServer;
@property (weak, nonatomic) IBOutlet UILabel* lastServer;
@property (weak, nonatomic) IBOutlet UILabel* favServer;
@property (weak, nonatomic) IBOutlet UILabel* streemServer;
@property (weak, nonatomic) IBOutlet UILabel* highServer;
@property (weak, nonatomic) IBOutlet UILabel* addServer;
@property (strong, nonatomic) IBOutlet UILabel *noServerStatus;

@end

NS_ASSUME_NONNULL_END
