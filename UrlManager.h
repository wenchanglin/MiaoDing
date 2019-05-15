//
//  UrlManager.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//
#import <UIKit/UIKit.h>


#define BanBenHao @"/index5_4"
#define URL_LoginAuth @"md/login"
#define URL_IsVaild @"token/is_valid"
//#define URL_LoginAuth [NSString stringWithFormat:@"/index%@/do_login",BanBenHao]

#define URLZIXUAN @"webapp/html/designer.html"
#define URLShare @"share/html/designer.html"
#define URL_DingZHi @"dd/index.html"

#define URL_ExitLogin @"md/logout"
#define URL_HEADURL @"http://www.cloudworkshop.cn/"//www
#define PIC_HEADURL @"http://newupload.oss-cn-beijing.aliyuncs.com/"
#define Share_ChengPin @"/web/jquery-obj/static/fx/html/chengping.html"
#define URL_HeadForH5 @"https://h5.morder.cn/"

//#define URL_WEBHEADURL @"http://192.168.1.156/web/jquery-obj/static/web/"
#define URL_WEBHEADURL @"http://cs.cloudworkshop.cn/web/jquery-obj/static/web/"
//webView
#define URL_YaoQingYouLi @"share/html/yaoqingyouli.html"
#define URL_YaoQing @"share/html/yaoqing.html"
#define URL_PaySucessShare @"share/html/invitation_1000.html"
#define URL_WEBDESIGNER @"designer/designer.html"
#define URL_WEBCOMMENT @"comment/comment.html"
//#define URL_GetYingDao @"/index/index/get_guide_img"


#define URL_GuanLiLT @"volume/list"
//#define URL_getIcon @"/index/index/get_app_icon_list"
#define URL_getIcon [NSString stringWithFormat:@"/index%@/get_app_icon_list",BanBenHao]

//获取个人资料
#define URL_GetUserInfo @"user_center/index"
//获取验证吗
#define URL_GetCheckCount @"user/login/send"
//首页
//#define URL_GetBaner @"/index/index/get_img/"
#define URL_GetBaner [NSString stringWithFormat:@"/index%@/get_img",BanBenHao]
#define URL_MenDian [NSString stringWithFormat:@"/index%@/shop_list",BanBenHao]
#define URL_MenDianInfo [NSString stringWithFormat:@"/index%@/shop_list_info",BanBenHao]
#define URL_MenDianSelect [NSString stringWithFormat:@"/index%@/shop_list_select",BanBenHao]
//#define URL_GetDetail @"/index/index/index_news"
#define URL_GetDetail [NSString stringWithFormat:@"/index%@/index_news",BanBenHao]
//再来一单
#define URL_NextOrder [NSString stringWithFormat:@"/index%@/cloumorder",BanBenHao]



//首页新
#define URL_GetMain @"user/index/index"

//首页收藏
#define URL_Love_Main [NSString stringWithFormat:@"/index%@/userlove",BanBenHao]
//#define URL_OtherMain @"/index/index/index_tab_list"
#define URL_OtherMain [NSString stringWithFormat:@"/index%@/index_tab_list",BanBenHao]

//首页资讯
#define URL_ZiXun [NSString stringWithFormat:@"/index%@/index_news_list",BanBenHao] 
//优品
//#define URL_GetYouPingList @"/index/index/goods_list"
#define URL_GetYouPingList [NSString stringWithFormat:@"/index%@/goods_list",BanBenHao]
//定制-商品详情
#define URL_GetYouPingDetail @"user/goods/goods_one"


//#define URL_GetDingZhiPic @"/index/index/customize"
#define URL_GetDingZhiPic [NSString stringWithFormat:@"/index%@/customizenew",BanBenHao]

#define URL_GetDingZhiDetail @"user/goods/custom_series"


//#define URL_GetDiyData @"/index/index/new_goods_gxh"
#define URL_GetDiyData [NSString stringWithFormat:@"/index%@/new_goods_gxh",BanBenHao]



//#define URL_GetDingZhiPicNew @"/index/index/new_customize"
#define URL_GetDingZhiPicNew [NSString stringWithFormat:@"/index%@/new_customize",BanBenHao]

//匠心
//#define URL_DesingerList @"/index/index/cobbler"
#define URL_DesingerList [NSString stringWithFormat:@"/index%@/cobbler",BanBenHao]



#define REFRESHCOUNT 15
//#define URL_GetDesignerDeetail @"/index/index/user_intro"
#define URL_GetDesignerDeetail [NSString stringWithFormat:@"/index%@/user_intro",BanBenHao]
//#define URL_GetDesigner @"/index/index/get_designer_list"
#define URL_GetDesigner [NSString stringWithFormat:@"/index%@/get_designer_list",BanBenHao]

//#define URL_getDesignerBaner @"/index/index/cobbler_v5_2"
#define URL_getDesignerBaner [NSString stringWithFormat:@"/index%@/cobbler_v5_2",BanBenHao]

//我的
//#define URL_SuggestPost @"/index/index/add_suggest"
#define URL_SuggestPost [NSString stringWithFormat:@"/index%@/add_suggest",BanBenHao]



//#define URL_GetActorData @"/index/index/add_user_data"
#define URL_GetActorData [NSString stringWithFormat:@"/index%@/add_user_data",BanBenHao]

//#define URL_PostUserInfo @"/index/index/add_lt_data"
#define URL_PostUserInfo [NSString stringWithFormat:@"/index%@/add_lt_data",BanBenHao]




//#define URL_PostDesignerApply @"/index/index/apply_in"
#define URL_PostDesignerApply [NSString stringWithFormat:@"/index%@/apply_in",BanBenHao]

//#define URL_CreateOrder @"/index/index/add_order"
#define URL_CreateOrder [NSString stringWithFormat:@"/index%@/add_order_v4",BanBenHao]


//#define URL_GetOrder @"/index/index/goods_order"
#define URL_GetOrder [NSString stringWithFormat:@"/index%@/goods_order",BanBenHao]


//#define URL_UpdateUserInfo @"/index/index/change_user_info"
#define URL_UpdateUserInfo [NSString stringWithFormat:@"/index%@/change_user_info",BanBenHao]



//#define URL_YuYue @"/index/index/add_order_list"
#define URL_GetYuYueStatus @"user/volume/get_yuyue_status"



//#define URL_invite @"/index/index/invite"
#define URL_invite [NSString stringWithFormat:@"/index%@/invite",BanBenHao]


#define URL_VIPUSERPRIVILEGE @"/index/user/user_privilege"
#define URL_VIPUSERPRIVILEGENEW @"/index/user/new_user_privilege"

#define URL_USEGRADE @"/index/user/new_user_grade"

#define URL_Viphelp @"/index/user/user_help"


#define URL_GetBirthday @"user/user/get_birthday_gift"
#define URL_GetVipUp @"user/user/user_upgrade_gift"

//量体数据详情
#define URL_GetBodyDate @"volume/detail"


#define URL_DiSanFang [NSString stringWithFormat:@"/index/login/partLogin"]


#define URL_PHOTOTAKE @"/web/cc/accept_img"
#define URL_PHOTOTAKETEST @"/web/cc/cameraImgUpload"




#define URL_StoreJoinShop  [NSString stringWithFormat:@"/index%@/add_carInsert",BanBenHao]
#define URL_StoreOrder  [NSString stringWithFormat:@"/index%@/quick_order",BanBenHao] 
//我的 删除收货地址
#define URL_AddressDelete @"delivery_address/delete"

//我的 设置默认收货地址
#define URL_ChooseAddress @"delivery_address/set_default"

#define Url_SetDefaultLt [NSString stringWithFormat:@"/index%@/is_lt",BanBenHao]
//添加购物车
//#define URL_AddClothesCar @"/index/index/add_car"
#define URL_AddClothesCar [NSString stringWithFormat:@"/index%@/add_car",BanBenHao]




//获取地址和物品信息
//#define URL_GetColthesAndAddress @"/index/index/buy"
#define URL_GetColthesAndAddress [NSString stringWithFormat:@"/index%@/buy",BanBenHao]

//#define URL_DeleteOrder @"/index/index/delete_order"
#define URL_DeleteOrder [NSString stringWithFormat:@"/index%@/delete_order",BanBenHao]
// 收藏
#define URL_CollectSave @"user/collects/add_user_collect"
#define URL_LoveSave @"user/love/add_user_love"

//获取定制详情
//#define URL_GetBagDingZhiDetail @"/index/index/dz_car_data"
#define URL_GetBagDingZhiDetail [NSString stringWithFormat:@"/index%@/dz_car_data",BanBenHao]


//#define URL_GETFenLei @"/index/index/goods_classify"
#define URL_GETFenLei @"user/goods/get_goods_type"
//#define URL_GetMainFenLei @"/index/index/get_news_tags_arr"
#define URL_GetMainFenLei [NSString stringWithFormat:@"/index%@/get_news_tags_arr",BanBenHao]


// 支付宝支付
//#define URL_APAY @"/index/index/mk_pay_order"
#define URL_APAY [NSString stringWithFormat:@"/index%@/mk_pay_order_v4",BanBenHao]
#define URL_WXPAY @"/index/wxpay/mk_pay_order_v4"
#define Description -(NSString *)description{NSMutableDictionary * dictionry = [NSMutableDictionary dictionary];uint count;objc_property_t *propertys = class_copyPropertyList([self class], &count);for (int i=0; i<count; i++) {objc_property_t preperty = propertys[i];NSString *name = @(property_getName(preperty));id value = [self valueForKey:name]?:@"nil";[dictionry setObject:value forKey:name];}free(propertys);return [NSString stringWithFormat:@"<%@: %p>-- %@",[self class],self,dictionry];}



//#define URL_HelpDetail @"/index/index/help_detail"
#define URL_HelpDetail [NSString stringWithFormat:@"/index%@/help_detail",BanBenHao]

//我的-优惠券列表
#define URL_Coupon @"ticket/list"
//我的-优惠券兑换
#define URL_ExchangeCoupon @"ticket/add"
#define URL_ChooseCoupon @"/index/ticket/get_car_ticket"
#define URL_CouponRule @"/index/ticket/get_ticket_introduce"

//消息中心
#define URL_MessageList @"/index/message/message_list"



//通知
//#define URL_Message @"/index/index/add_device"
#define URL_Message [NSString stringWithFormat:@"/index%@/add_device",BanBenHao]

//用户行为
//#define URL_USerActionMain @"/index/index/save_index_log"
#define URL_USerActionMain [NSString stringWithFormat:@"/index%@/save_index_log",BanBenHao]

//#define URL_UserActionLogin @"/index/index/save_user_login_log"
#define URL_UserActionLogin [NSString stringWithFormat:@"/index%@/save_user_login_log",BanBenHao]


//#define URL_UserDingAction @"/index/index/save_goods_log"
#define URL_UserDingAction [NSString stringWithFormat:@"/index%@/save_goods_log",BanBenHao]

//评论
//#define URL_AddCommend @"/index/index/save_order_comment"
#define URL_AddCommend [NSString stringWithFormat:@"/index%@/save_order_comment",BanBenHao]
//#define URL_CommendList @"/index/index/get_goods_comment_list"
#define URL_CommendList [NSString stringWithFormat:@"/index%@/get_goods_comment_list",BanBenHao]

#define URL_GetPoper @"gift_card/add"  //绑定礼品卡
#define URL_GiftBalance @"gift_card/balance"//查询 礼品卡余额
#define URL_GetPoperLastMoney @"gift_card/list"  //查询礼品卡列表

