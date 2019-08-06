//
//  TrustKitSSLValidator.m

#import "TrustKitSSLValidator.h"

@implementation TrustKitSSLValidator

+ (TrustKitSSLValidator *)sharedClient
{
    static TrustKitSSLValidator *sharedAPIClient = nil;
    static dispatch_once_t onceTokenAPIManager;
    dispatch_once(&onceTokenAPIManager, ^{
        sharedAPIClient = [[self alloc] init];
    });
    return sharedAPIClient;
}

-(void)callSSlPinningWithDomain:(NSString *)domainName publicKey:(NSString *)publicKey andBackupKey:(NSString *)backupKey andCompletion:(void (^)(BOOL isCompelete))completion{
    // Override TrustKit's logger method
    void (^loggerBlock)(NSString *) = ^void(NSString *message)
    {
       NSLog(@"TrustKit log: %@", message);
        
    };
    [TrustKit setLoggerBlock:loggerBlock];
    
    // Initialize TrustKit
    _trustKitConfig =
    @{
      // Do not auto-swizzle NSURLSession delegates
      kTSKSwizzleNetworkDelegates: @NO,
      
      kTSKPinnedDomains: @{
              domainName : @{
                      kTSKEnforcePinning:@YES,
//                      kTSKEnforcePinning:@NO,
                      kTSKPublicKeyAlgorithms : @[kTSKAlgorithmRsa2048],
                      
                      // Valid SPKI hashes to demonstrate success
                      kTSKPublicKeyHashes : @[
                              publicKey, // CA key: COMODO ECC Certification Authority
                              backupKey, // Fake key but 2 pins need to be provided
                              ],
                     // kTSKIncludeSubdomains : @NO
                      }
              }
      };
    
//    NSLog(@"_trustKitConfig :%@", _trustKitConfig);
    [TrustKit initSharedInstanceWithConfiguration:_trustKitConfig];
    //TrustKit *shared = [[TrustKit alloc] initWithConfiguration:_trustKitConfig];
    completion(true);
}

//- (void)initWithURLString:(NSString *)urlString andCompletion:(void(^)(bool sucess, NSError *error))completion{
//        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]
//                                                     delegate:self
//                                                delegateQueue:NSOperationQueue.mainQueue];
//
//    [self loadUrl:[NSURL URLWithString:urlString]];
//
//    self.trustkitCompletion = completion;
//}

#pragma mark TrustKit Pinning Reference

//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//    // Call into TrustKit here to do pinning validation
//    if (![TrustKit.sharedInstance.pinningValidator handleChallenge:challenge completionHandler:completionHandler])
//    {
//        // TrustKit did not handle this challenge: perhaps it was not for server trust
//        // or the domain was not pinned. Fall back to the default behavior
//        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
//    }
//}

//#pragma mark Test Control
//
//- (void)loadUrl:(NSURL *)url{
//
//    // Load a URL with a good pinning configuration
//    __weak typeof(self) weakSelf = self;
//
//    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        typeof(self) strongSelf = weakSelf;
//        if (!strongSelf) {
//            return;
//        }
//        if (error) {
//            strongSelf.trustkitCompletion(false, error);
//        }
//        else {
//            strongSelf.trustkitCompletion(true, error);
//        }
//    }];
//    [task resume];
//}
@end
