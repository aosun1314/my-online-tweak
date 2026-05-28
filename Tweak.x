#import <Foundation/Foundation.h>

// =======================================================
// 完全体网络内购劫持器（无缝对接云端万能 SDK）
// =======================================================
@interface NSURLSessionTaskDependencyDescription : NSURLProtocol
@end

@implementation NSURLSessionTaskDependencyDescription

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    @try {
        NSString *url = request.URL.absoluteString;
        if (!url) return NO;
        if ([NSURLProtocol propertyForKey:@"ProcessedBySystemProxyCore" inRequest:request]) {
            return NO;
        }
        // 核心拦截：苹果官方内购收据验证连接
        if ([url containsString:@"buy.itunes.apple.com/verifyReceipt"]) {
            return YES;
        }
    } @catch (NSException *e) {}
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest *strippedRequest = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"ProcessedBySystemProxyCore" inRequest:strippedRequest];
    @try {
        NSString *currentBundleID = [[NSBundle mainBundle] bundleIdentifier] ? : @"com.apple.placeholder";
        
        // 动态计算过期时间：当前时间顺延 60 天，完美避开风控
        NSTimeInterval dynamicFutureTime = [[NSDate date] timeIntervalSince1970] + (60 * 24 * 60 * 60);
        NSString *dynamicExpiresMs = [NSString stringWithFormat:@"%.0f000", dynamicFutureTime];
        
        // 伪造完美的终身 VIP 官方回执 JSON 字典
        NSDictionary *fakeResponseDict = @{
            @"status": @0,
            @"receipt": @{ @"bundle_id": currentBundleID, @"application_version": @"1.0" },
            @"latest_receipt_info": @[
                @{
                    @"product_id": @"premium_lifetime_unlocked", // 对应 App 终身会员 ID
                    @"expires_date_ms": dynamicExpiresMs, 
                    @"is_in_intro_offer_period": @"false",
                    @"original_transaction_id": @"4000000000000001"
                }
            ]
        };
        
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:fakeResponseDict options:NSJSONWritingPrettyPrinted error:nil];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:strippedRequest.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"application/json"}];
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:responseData];
        [self.client URLProtocolDidFinishLoading:self];
    } @catch (NSException *exception) {
        [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:@"com.apple.proxy.err" code:-1 userInfo:nil]];
    }
}

- (void)stopLoading {}
@end

%hook NSURLSessionConfiguration
+ (NSURLSessionConfiguration *)defaultSessionConfiguration {
    NSURLSessionConfiguration *config = %orig;
    if (config) {
        NSMutableArray *protocols = [config.protocolClasses mutableCopy] ? : [NSMutableArray array];
        if (![protocols containsObject:[NSURLSessionTaskDependencyDescription class]]) {
            [protocols insertObject:[NSURLSessionTaskDependencyDescription class] atIndex:0];
            config.protocolClasses = protocols;
        }
    }
    return config;
}

+ (NSURLSessionConfiguration *)ephemeralSessionConfiguration { 
    NSURLSessionConfiguration *config = %orig;
    if (config) {
        NSMutableArray *protocols = [config.protocolClasses mutableCopy] ? : [NSMutableArray array];
        if (![protocols containsObject:[NSURLSessionTaskDependencyDescription class]]) {
            [protocols insertObject:[NSURLSessionTaskDependencyDescription class] atIndex:0];
            config.protocolClasses = protocols;
        }
    }
    return config;
}
%end

%ctor {
    @autoreleasepool {
        [NSURLSessionConfiguration defaultSessionConfiguration];
        [NSURLSessionConfiguration ephemeralSessionConfiguration];
        [NSURLProtocol registerClass:[NSURLSessionTaskDependencyDescription class]];
    }
}
