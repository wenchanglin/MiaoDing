/**
 
 @return WXApiManager（微信结果回调类）
 */

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - 单粒

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFlase" object:nil];
                break;
        }
    }
}


@end
