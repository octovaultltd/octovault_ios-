//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.


#import "IAPManager.h"
#import "IAPTools.h"
#import "AFNetworking.h"
#define kReceipt @"RECEIPT"
#define kFileExt @"receipt"
#import <UICKeyChainStore.h>
#import <OneSignal/OneSignal.h>
#import "KSToastView.h"

@interface IAPManager ()<SKProductsRequestDelegate>

@property (nonatomic, copy) IAPCompletionBlock completionBlock;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSData *receipt;// 本次购买凭证

@property (nonatomic, strong) IAPLoadingView *loadingView;
@property (nonatomic, strong) NSOperationQueue *ioQueue;
@property (nonatomic, strong, readonly) NSString *filePathBase;

@end

@implementation IAPManager

+ (instancetype)shared{
    static IAPManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[IAPManager alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self filePathBase] withIntermediateDirectories:true attributes:nil error:nil];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:(id)self];
        
        //[self restorePurchases];
    }
    return self;
}



- (void)restorePurchases {
    [self showLoading];
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self dismissLoading];
    NSLog(@"SKRequest : didFailWithError :%@",error);
}

- (void)requestDidFinish:(SKRequest *)request
{
    [self dismissLoading];
    NSLog(@"SKRequest : requestDidFinish ");

}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
  
    [self dismissLoading];
    NSLog(@"Restored");
    [KSToastView ks_showToast:@"Subscription Restored"];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [self dismissLoading];
    NSLog(@"Error in restoring:%@",error);
    [KSToastView ks_showToast:error];
}


- (IAPLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[[NSBundle mainBundle] loadNibNamed:@"IAPLoadingView" owner:self options:nil] firstObject];
        return _loadingView;
    }
    return _loadingView;
}

- (NSOperationQueue *)ioQueue{
    if (!_ioQueue){
        _ioQueue = [[NSOperationQueue alloc] init];
        _ioQueue.name = @"IAP_IO_QUEUE";
    }
    return _ioQueue;
}

- (NSString *)filePathBase{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [IAPTools documentsDirectory], kReceipt];
    return path;
}

- (UIWindow *)window{
    return [[UIApplication sharedApplication] keyWindow];
}

#pragma mark - Public

+ (void)checkIfLocalReceiptsNotValided:(IAPCompletionBlock)completion{
    [[IAPManager shared] checkIfLocalReceiptsNotValided:completion];
}



#pragma mark - Private

- (void)showLoading{
    UIWindow *window = [self window];
    self.loadingView.frame = window.frame;
    [window addSubview:_loadingView];
    [_loadingView show];
}

- (void)dismissLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_loadingView dismiss];
    });
    
}


- (void)checkIfLocalReceiptsNotValided:(IAPCompletionBlock)completion{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [self.ioQueue addOperationWithBlock:^{
        NSArray *files = [self filesAtPath:[self filePathBase] fileManager:fileManager];
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:files.count];
        for (NSString *item in files) {
            [results addObject:[self dataWithFile:item]];
        }
        if (completion) {
            completion(IAPResultCodeSuccess, results);
        }
    }];
}



- (void)getProductInfo:(NSString *)productIdentifier {
    [self showLoading];
    
    NSArray *product = [[NSArray alloc] initWithObjects: productIdentifier, nil];
    NSSet *set = [NSSet setWithArray: product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers: set];
    request.delegate = self;
    [request start];
}


#pragma mark - IO Operations

- (void)storeReceipt:(NSData *)receipt productId:(NSString *)productId userId:(NSString *)userId{
    [self.ioQueue addOperationWithBlock:^{
        NSString *fileName = [NSString stringWithFormat:@"%@UUU%@", productId, userId];
        NSString *encodeFileName = [IAPTools encodeString:fileName];
        NSString *filePath = [self.filePathBase stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.XXX%@", encodeFileName, kFileExt]];
        [receipt writeToFile:filePath atomically:true];
    }];
}

- (NSArray <NSString *>*)filesAtPath:(NSString *)basePath fileManager:(NSFileManager *)fileManager{
    if ([fileManager fileExistsAtPath:basePath]) {
        NSMutableArray *temp = [NSMutableArray array];
        NSArray *childerFiles = [fileManager subpathsAtPath:basePath];
        for (NSString *fileName in childerFiles) {
            NSString *fileExt = [[fileName componentsSeparatedByString:@".XXX"] lastObject];
            if ([fileExt isEqualToString:kFileExt]){
                NSString *absolutePath = [basePath stringByAppendingPathComponent:fileName];
                [temp addObject:absolutePath];
            }
        }
        return temp;
    }
    return nil;
}

- (NSDictionary *)dataWithFile:(NSString *)filePath{
    if (filePath) {
        NSData *receiptData = [NSData dataWithContentsOfFile:filePath];
        NSString *lastPathComponent = filePath.lastPathComponent;
        NSString *fileName = [[lastPathComponent componentsSeparatedByString:@".XXX"] firstObject];
        NSString *decodeString = [IAPTools decodeString:fileName];
        NSArray *names = [decodeString componentsSeparatedByString:@"UUU"];
        NSDictionary *result = @{
            @"productId":[names firstObject],
            @"userId":[names lastObject],
            @"receiptData": receiptData
        };
        return result;
    }
    return nil;
}

- (BOOL)deleteFileWith:(NSString *)path fileManager:(NSFileManager *)fileManager{
    NSError *error = nil;
    [fileManager removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"*******删除文件失败********");
        return false;
    }
    return true;
}


-(void) loadInAppProducts:(NSArray *)productIdentifier{

    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifier]];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    if (response.invalidProductIdentifiers.count > 0) {
        NSLog(@"Invalid Product IDs: %@", response.invalidProductIdentifiers);
    }
    
    if (response.products.count == 0){
        return;
    }
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    self.availableProducts = [response.products sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    NSLog(@"count--: %lu", (unsigned long)self.availableProducts.count);
}

-(NSArray *) getProducts{
    return self.availableProducts;
}

+(NSArray *) getAvailableProducts{
    return [[IAPManager shared] getProducts];
}


+ (void)purchaseWithProduct:(SKProduct *)product
                userId:(NSString *)userId
       completionBlock:(IAPCompletionBlock)completion{
    [[IAPManager shared] purchase:product
                                 userId:userId
                        completionBlock:completion];
}

- (void)purchase:(SKProduct *)product
                userId:(NSString *)userId
       completionBlock:(IAPCompletionBlock)completion{
    
    if (![SKPaymentQueue canMakePayments]){
        if (completion){
            completion(IAPResultCodeUserCanceled, @"Users are prohibited from using in-app purchases");
        }
        return;
    }
    
    self.completionBlock = completion;
    self.productId = product.productIdentifier;
    self.userId = userId;
    
    if (!self.availableProducts) {
      NSLog(@"No products are available. Did you initialize MKStoreKit by calling [[MKStoreKit sharedKit] startProductRequest]?");
        
        if (completion){
            completion(IAPResultCodeFailed, @"No item available");
        }
        
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [self showLoading];
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                self.receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                if (!self.receipt){
                    if (self.completionBlock){
                        [self dismissLoading];
                        self.completionBlock(IAPResultCodeFailed, @"Can't find proof of purchase!");
                    }
                    return;
                }
                if (self.completionBlock){
                    [self dismissLoading];
                    self.completionBlock(IAPResultCodeValidingWithServer, @"Verifying the proof of purchase with the server...");
                }
                [self completeTransaction:transaction];
                [self storeReceipt:self.receipt productId:transaction.transactionIdentifier userId:[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
                [self dismissLoading];
                break;
            case SKPaymentTransactionStateFailed:
                [self dismissLoading];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self dismissLoading];
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)completePurchase:(NSString *)productId
                        userId:(NSString *)userId
               completionBlock:(IAPCompletionBlock)completion{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [self.ioQueue addOperationWithBlock:^{
        NSString *fileName = [NSString stringWithFormat:@"%@UUU%@", productId, userId];
        NSString *encodeFileName = [IAPTools encodeString:fileName];
        NSString *filePath = [self.filePathBase stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.XXX%@", encodeFileName, kFileExt]];
        BOOL success = [self deleteFileWith:filePath fileManager:fileManager];
        if (completion) {
            completion(success ? IAPResultCodeSuccess : IAPResultCodeFailed, nil);
        }
    }];
}

+ (void)completePurchaseWithProduct:(NSString *)productId
                        userId:(NSString *)userId
               completionBlock:(IAPCompletionBlock)completion{
    [[IAPManager shared] completePurchase:productId
                                         userId:userId
                                completionBlock:(IAPCompletionBlock)completion];
}


#pragma mark - Testing

+ (void)validateReceiptWithRemoteServerwithEmail:(NSString *)email withCompletion:(IAPCompletionBlock)completion{
    NSData *receipt = [[IAPManager shared] receipt];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.spinytel.octovault"];
    NSString *username = [keychain stringForKey:@"username"];
    
    NSString* pushUserID = @"";
    if([OneSignal getDeviceState].userId != nil){
        pushUserID = [OneSignal getDeviceState].userId;
    }
    
    NSDictionary *params = @{@"username": username,
                             @"receipt": [receipt base64EncodedStringWithOptions:0],
                             @"contact_email": email,
                             @"player_id": pushUserID,
                             @"isSandbox":@"0"
    };
    
    NSLog(@"params: %@", params);
    
    if (!receipt) {
        if (completion){
            completion(IAPResultCodeFailed, @"Cannot find Receipt");
            return;
        }
    }
    
    [[IAPManager shared] showLoading];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *url = @"https://octovaultpayment.gutrrea.xyz/inapp_ios_common_staging.php?app_name=octavaultvpn";
    NSString *url = @"https://octovaultpayment.gutrrea.xyz/inapp_ios_common_live.php?app_name=octavaultvpn";
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[IAPManager shared] dismissLoading];
        NSLog(@"%@",responseObject);
        NSString *myString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        IAPResultCode code;
        NSLog(@"%@",myString);
        NSData *responseData = [myString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:NULL error:&jsonError];
        
        NSLog(@"%@",json);
        
        NSString *msg = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        
        int response_code = [[json valueForKey:@"response_code"] intValue];
        
        
        if (response_code == 2) {
            
            code = IAPResultCodeSuccess;
        }else{
            code = IAPResultCodeInvalid;
        }
        
        if (completion){
            completion(code, msg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[IAPManager shared] dismissLoading];
        if (completion){
            completion(IAPResultCodeFailed, @"Network error during verification");
        }
    }];
}


+ (void)validateReceiptWithRemoteServerInBackground:(NSData *)receipt withCompletion:(IAPCompletionBlock)completion{
    
    //NSData *receipt = [[IAPManager shared] receipt];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults valueForKey:@"username"];
    
    NSDictionary *params = @{@"username": username,
                             @"receipt": [receipt base64EncodedStringWithOptions:0],
                             @"isSandbox":@"0"
    };
    
    if (!receipt) {
        if (completion){
            completion(IAPResultCodeFailed, @"Cannot find Receipt");
            return;
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = @"https://octovaultpayment.gutrrea.xyz/inapp_ios_common_live.php?app_name=octavaultvpn";
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *myString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        IAPResultCode code;
        NSData *responseData = [myString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:NULL error:&jsonError];
        NSString *msg = [NSString stringWithFormat:@"%@",[json objectForKey:@"message"]];
        int response_code = [[json objectForKey:@"response_code"] intValue];
        if (response_code == 2) {
            code = IAPResultCodeSuccess;
        }else{
            code = IAPResultCodeInvalid;
        }
        
        if (completion){
            completion(code, msg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completion){
            completion(IAPResultCodeFailed, @"Network error during verification");
        }
    }];
}


+ (void)validReceiptWithAppStore:(IAPCompletionBlock)completion{ // 仅供沙箱测试使用
    NSData *receipt = [[IAPManager shared] receipt];
    NSError *error = nil;
    NSDictionary *requestContents = @{
        @"receipt-data": [receipt base64EncodedStringWithOptions:0],
        @"password": @"9e20d535dc3a498ea231d999718141bc"
    };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) {
        if (completion){
            completion(IAPResultCodeFailed, @"Cannot find Receipt");
            return;
        }
    }
    // https://buy.itunes.apple.com/verifyReceipt
    NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (completion){
                completion(IAPResultCodeFailed, @"Network error during verification");
            }
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                if (completion){
                    completion(IAPResultCodeFailed, @"Verify that the returned data is incorrect");
                }
            }else{
                IAPResultCode code;
                NSString *hint;
                if ([[jsonResponse objectForKey:@"status"] integerValue]== 0){// 成功
                    code = IAPResultCodeSuccess;
                }else{
                    code = IAPResultCodeFailed;
                    hint = [NSString stringWithFormat:@"ErrorCode: %@", [jsonResponse objectForKey:@"status"]];
                    // 请参考 https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html#//apple_ref/doc/uid/TP40010573-CH104-SW1
                }
                if (completion){
                    completion(code, hint);
                }
            }
        }
    }];
}

@end
