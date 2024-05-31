//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "CountryTableViewCell.h"
#import "KSToastView.h"


@implementation CountryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)connectionTapped:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL realUser = [defaults boolForKey:@"realUserLogin"];
    if(!realUser){
        [KSToastView ks_showToast:@"Server Locked for Guest Login"];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(connectionButton:andConnection:withIndexPath:)]) {
            [self.delegate connectionButton:sender andConnection:self.connection withIndexPath:self.indexPath];
            NSLog(@"connectionbtn tapped");
        }
    }
}

- (IBAction)favouriteButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(favouriteButton:andConnection:)]) {
        [self.delegate favouriteButton:sender andConnection:self.connection];
        
        NSLog(@"favbtn tapped");
    }
}

@end
