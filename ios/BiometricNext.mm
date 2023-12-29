#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(BiometricNext, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(enableBioMetric:(NSString *)title subtitle:(NSString *)subtitle callback:(RCTResponseSenderBlock)callback)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
