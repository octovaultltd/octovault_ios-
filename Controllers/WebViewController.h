//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BLMultiColorLoader.h"

@interface WebViewController : UIViewController<WKNavigationDelegate>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet BLMultiColorLoader *spinner;



@end
