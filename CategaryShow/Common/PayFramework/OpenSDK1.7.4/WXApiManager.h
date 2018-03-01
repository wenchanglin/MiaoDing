
/**
 
 @return WXApiManager（微信结果回调类）
 */

#import <Foundation/Foundation.h>
#import "WXApi.h"
@interface WXApiManager : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;

@end
