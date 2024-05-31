//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, IAPResultCode){
    IAPResultCodeIdle = 0,// 空闲状态
    IAPResultCodeSuccess, // 成功
    IAPResultCodeFailed, // 失败
    IAPResultCodeUserCanceled, //用户取消
    IAPResultCodeValidingWithServer, //与服务端验证购买凭证
    IAPResultCodeUnknown,//未知错误 可见IAPCompletionBlock的 info 参数
    IAPResultCodeInvalid
};

typedef void(^IAPCompletionBlock)(IAPResultCode code, id info);

@interface IAPManager: NSObject


@property NSArray *availableProducts;

+ (instancetype)shared;




// 检查没有和服务器验证的购买凭证
+ (void)checkIfLocalReceiptsNotValided:(IAPCompletionBlock)completion;

// 本地测试
+ (void)validReceiptWithAppStore:(IAPCompletionBlock)completion;
+ (void)validateReceiptWithRemoteServerwithEmail:(NSString *)email withCompletion:(IAPCompletionBlock)completion;
//+ (void)validateReceiptWithRemoteServerInBackground:(IAPCompletionBlock)completion;
+ (void)validateReceiptWithRemoteServerInBackground:(NSData *)receipt withCompletion:(IAPCompletionBlock)completion;



- (void)restorePurchases;

- (void) loadInAppProducts:(NSArray *)items;

+(NSArray *) getAvailableProducts;
+ (void)purchaseWithProduct:(SKProduct *)productId
                userId:(NSString *)userId
       completionBlock:(IAPCompletionBlock)completion;

+ (void)completePurchaseWithProduct:(NSString *)productId
                        userId:(NSString *)userId
               completionBlock:(IAPCompletionBlock)completion;

@end
