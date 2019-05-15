//
//  MoreUrlInterface.h
//  CategaryShow
//
//  Created by 文长林 on 2018/11/1.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreUrlInterface : NSObject
/**
 基础请求头
 */
+(NSString*)URL_Server_String;

/**
 单张图片上传
 */
+(NSString*)URL_OnePicUpload_String;

/**
 opencv精准拍照 保存量体数据
 */
+(NSString*)URL_JingZhunSaveVolumes_String;

/**
 设置默认量体数据
 */
+(NSString*)URL_setMorenLiangTi_String;

/**
  用户信息修改
 */
+(NSString*)URL_EditUserInfo_String;

/**
 我的-帮助与反馈-帮助分类
 */
+(NSString*)URL_MineHelpClassify_String;

/**
 我的-帮助与反馈-帮助列表
 */
+(NSString*)URL_MineHelpList_String;

/**
 我的-帮助与反馈-帮助详情
 */
+(NSString*)URL_MineHelpDetail_String;

/**
 我的-帮助与反馈-新增意见反馈
 */
+(NSString*)URL_MineHelpAddSuggest_String;

/**
 我的-会员等级
 */
+(NSString*)URL_MineUserPrivilege_String;

/**
 我的会员成长
 */
+(NSString *)URL_MineUserCreditRecord_String;

/**
 我的会员规则接口
 */
+(NSString*)URL_MineUserHelp_String;

/**
 获取客服热线接口
 */
+(NSString*)URL_GetKeFuPhone_String;

/**
 获取用户注册协议接口
 */
+(NSString*)URL_UserLoginProtocol_String;

/**
 查询商品详情+配件
 */
+(NSString*)URL_DingZhiDetailAndPeiJian_String;

/**
 商品添加到购物车
 */
+(NSString*)URL_AddShoppingCar_String;

/**
 通过购物车id确认订单
 */
+(NSString*)URL_QueRenOrderForShoppingCarID_String;

/**
获取用户所有收货地址
 */
+(NSString*)URL_GetAddressList_String;

/**
 我的-添加收货地址
 */
+(NSString*)URL_AddressAdd_String;

/**
 我的-更新收货地址
 */
+(NSString*)URL_UpdateAddress_String;

/**
 获取引导图 根据id
 */
+(NSString*)URL_GetYinDaoForID_String;

/**
 查看用户跟当前订单可用的优惠券
 */
+(NSString*)URL_GetYouHuiQuanFromCarid_String;

/**
 优惠券兑换
 */
+(NSString*)URL_ExchangeCouPon_String;

/**
 优惠券规则
 */
+(NSString*)URL_CouponRule_String;

/**
修改购物车
 */
+(NSString*)URL_ChangeCarNum_String;
/**
 购物车下单
 */
+(NSString*)URL_OrderForCar_String;
/**
 下单前，订单确认
 */
+(NSString*)URL_BeforeDownOrder_String;

/**
 订单列表
 */
+(NSString*)URL_OrderList_String;

/**
 订单详情
 */
+(NSString*)URL_OrderDetailForOrdersn_String;
/**
删除订单
 */
+(NSString*)URL_DeleteOrderForOrdersn_String;

/**
取消订单
 */
+(NSString*)URL_CancleOrderForOrdersn_String;

/**
确认收货
*/
+(NSString*)URL_Confirm_Delivery_String;

/**
 礼品卡全额支付订单
 */
+(NSString*)URL_GiftCardToBuy_String;

/**
  购物车列表
 */
+(NSString*)URL_ShoppingCartList_String;
/**
 购物车推荐商品
 */
+(NSString*)URL_ShoppingCartRecommendGoods_String;

/**
 删除购物车里的商品
 */
+(NSString*)URL_DeleteOneOrMoreShopsFromShopping_Car_String;

/**
    查看顺丰订单的物流(有半小时延迟)
 */
+(NSString*)URL_CheckSfExpress_String;

/**
 支付宝支付
 */
+(NSString *)URL_ZhiFuBaoToPayOrder_String;

/**
 微信支付
 */
+(NSString*)URL_WxToPayOrder_String;

/**
 预约量体
 */
+(NSString*)URL_YuYuelt_String;

/**
 我的收藏
 */
+(NSString*)URL_MyCollect_String;

/**
 成品腔调列表
 */
+(NSString*)URL_DesignerChengPin_String;

/**
 成品库存
 */
+(NSString*)URL_ChengPinKuCun_String;

/**
 消息类型
 */
+(NSString*)URL_NoticationType_String;

/**
 消息列表
 */
+(NSString*)URL_NoticationList_String;

/**
 设计师招募
 */
+(NSString*)URL_GetDesignerImg_String;

/**
 设计师申请入驻
 */
+(NSString *)URL_DesignerApplyIn_String;

/**
 用户商品分享加密
 */
+(NSString*)URL_ShareUserForGoodsId_String;

/**
 定制分类
 */
+(NSString *)URL_FenLeiForNamed_String;

/**
 形体数据
 */
+(NSString *)URL_XingTiDatas_String;

/**
 根据商品id(加密/不加密) 查商品分类
 */
+(NSString*)URL_GoodsCategoryWithID_String;
@end
NS_ASSUME_NONNULL_END
