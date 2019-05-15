//
//  MoreUrlInterface.m
//  CategaryShow
//
//  Created by 文长林 on 2018/11/1.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "MoreUrlInterface.h"

@implementation MoreUrlInterface

+(NSString*)URL_Server_String{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
//        return @"http://192.168.1.120/index.php/";
        return @"http://api.cloudworkshop.cn/";
    }
    else {//英文版
        return @"http://test.cloudworkshop.cn/index.php";
    }
}

+(NSString *)URL_OnePicUpload_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/together/uploads";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_EditUserInfo_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user_center/edit";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_MineHelpClassify_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user_center/help_classify";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_MineHelpList_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user_center/help_list";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_MineHelpDetail_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user_center/help_detail";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_GetKeFuPhone_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/sysset/get_tel";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_UserLoginProtocol_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/login/sys_set";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_MineHelpAddSuggest_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user_center/add_suggest";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_MineUserPrivilege_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/user/user_privilege";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_MineUserCreditRecord_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/user/user_credit_record";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_MineUserHelp_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/user/user_help";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_DingZhiDetailAndPeiJian_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"goods/detail";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_AddShoppingCar_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"shopping_cart/add";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_QueRenOrderForShoppingCarID_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/confirm";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_GetAddressList_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"delivery_address/list";
    }
    else
    {
        return @"";
    }
    
}
+(NSString *)URL_AddressAdd_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"delivery_address/add";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_Confirm_Delivery_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/confirm_delivery";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_CheckSfExpress_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/sf_express";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_UpdateAddress_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"delivery_address/update";
    }
    else
    {
        return @"";
    }
    
}
+(NSString *)URL_GetYinDaoForID_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/extra/get_guide_img";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_GetYouHuiQuanFromCarid_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ticket/cart_assoc";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ExchangeCouPon_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ticket/add";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ChangeCarNum_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"shopping_cart/update";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_OrderForCar_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/cart";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_BeforeDownOrder_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/order_confirm";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_OrderList_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/list";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_OrderDetailForOrdersn_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/detail";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_DeleteOrderForOrdersn_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/delete";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_CancleOrderForOrdersn_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/cancel";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_GiftCardToBuy_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"order/gift_card_buy";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ShoppingCartList_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"shopping_cart/list";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ShoppingCartRecommendGoods_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"shopping_cart/recommend_goods";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_DeleteOneOrMoreShopsFromShopping_Car_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"shopping_cart/delete";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ZhiFuBaoToPayOrder_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"alipay/order_pay_info";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_WxToPayOrder_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"wxpay/order_pay_info";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_CouponRule_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ticket/rule";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_YuYuelt_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/volume/prepare_volume";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_MyCollect_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/collects/my_collect";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_DesignerChengPin_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/goods/products";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ChengPinKuCun_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"goods/sku";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_JingZhunSaveVolumes_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/volume/save_volumes";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_setMorenLiangTi_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/volume/is_lt";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_NoticationType_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"notifications/type";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_NoticationList_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"notifications/list";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_GetDesignerImg_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/index/get_img";
    }
    else
    {
        return @"";
    }
}

+(NSString *)URL_DesignerApplyIn_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/center/apply_in";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_ShareUserForGoodsId_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/user/get_goods_id_encrypted";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_FenLeiForNamed_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/goods/goods_choose_option";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_XingTiDatas_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"volume/default";
    }
    else
    {
        return @"";
    }
}
+(NSString *)URL_GoodsCategoryWithID_String
{
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"user/goods/goods_category";
    }
    else
    {
        return @"";
    }
}
@end
