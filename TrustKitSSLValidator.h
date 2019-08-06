//
//  TrustKitSSLValidator.h

//

#import <Foundation/Foundation.h>
#import <TrustKit/TrustKit.h>

@interface TrustKitSSLValidator : NSObject<NSURLSessionDelegate>

typedef void(^TrustKitCompletion)(bool sucess, NSError *error);

@property (nonatomic) NSURLSession *session;

@property (readwrite, nonatomic, copy) TrustKitCompletion trustkitCompletion;
@property (nonatomic, readonly) NSDictionary *trustKitConfig;

-(void)callSSlPinningWithDomain:(NSString *)domainName publicKey:(NSString *)publicKey andBackupKey:(NSString *)backupKey andCompletion:(void (^)(BOOL isCompelete))completion;
//- (void)initWithURLString:(NSString *)urlString andCompletion:(void(^)(bool sucess, NSError *error))completion;
+ (TrustKitSSLValidator *)sharedClient;
@end
