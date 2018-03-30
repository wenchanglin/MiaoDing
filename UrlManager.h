//
//  UrlManager.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef CongestionOfGod_UrlManager_h
#define CongestionOfGod_UrlManager_h


#endif
#define BanBenHao @"/index5_4"
#define URL_LoginAuth @"/index/login/do_login"
//#define URL_LoginAuth [NSString stringWithFormat:@"/index%@/do_login",BanBenHao]


//#define URL_ExitLogin @"/index/index/login_out"
#define URL_ExitLogin [NSString stringWithFormat:@"/index%@/login_out",BanBenHao]
#define URL_Server_String  @"http://www.cloudworkshop.cn/index.php"//www
#define URL_HEADURL @"http://www.cloudworkshop.cn/"//www
#define PIC_HEADURL @"http://source.cloudworkshop.cn/"
#define Share_ChengPin @"/web/jquery-obj/static/fx/html/chengping.html"
//#define URL_HEADURL @"http://192.168.1.156/"

//#define URL_WEBHEADURL @"http://192.168.1.156/web/jquery-obj/static/web/"
#define URL_WEBHEADURL @"http://cs.cloudworkshop.cn/web/jquery-obj/static/web/"
//webView

#define URL_WEBDESIGNER @"designer/designer.html"
#define URL_WEBCOMMENT @"comment/comment.html"
//#define URL_GetYingDao @"/index/index/get_guide_img"

#define URL_GetYingDao [NSString stringWithFormat:@"/index%@/get_guide_img",BanBenHao]

//#define URL_getIcon @"/index/index/get_app_icon_list"
#define URL_getIcon [NSString stringWithFormat:@"/index%@/get_app_icon_list",BanBenHao]

//获取个人资料
//#define URL_GetUserInfo @"/index/index/user_info"
#define URL_GetUserInfo [NSString stringWithFormat:@"/index%@/user_info",BanBenHao]
//获取验证吗
#define URL_GetCheckCount @"/index/login/send_sms"
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
//#define URL_GetMain @"/index/index/new_index_news"
#define URL_GetMain [NSString stringWithFormat:@"/index%@/new_index_news",BanBenHao]
//首页收藏
#define URL_Love_Main [NSString stringWithFormat:@"/index%@/userlove",BanBenHao]
//#define URL_OtherMain @"/index/index/index_tab_list"
#define URL_OtherMain [NSString stringWithFormat:@"/index%@/index_tab_list",BanBenHao]

//首页资讯
#define URL_ZiXun [NSString stringWithFormat:@"/index%@/index_news_list",BanBenHao] 
//优品
//#define URL_GetYouPingList @"/index/index/goods_list"
#define URL_GetYouPingList [NSString stringWithFormat:@"/index%@/goods_list",BanBenHao]

//#define URL_GetYouPingDetailNew @"/index/index/new_goods_detail"
#define URL_GetYouPingDetailNew [NSString stringWithFormat:@"/index%@/new_goods_detailNew",BanBenHao]

//#define URL_GetYouPingDetail @"/index/index/goods_detail"
#define URL_GetYouPingDetail [NSString stringWithFormat:@"/index%@/goods_detail",BanBenHao]


//#define URL_GetDingZhiPic @"/index/index/customize"
#define URL_GetDingZhiPic [NSString stringWithFormat:@"/index%@/customizenew",BanBenHao]




//#define URL_GetDiyData @"/index/index/new_goods_gxh"
#define URL_GetDiyData [NSString stringWithFormat:@"/index%@/new_goods_gxh",BanBenHao]



//#define URL_GetDingZhiPicNew @"/index/index/new_customize"
#define URL_GetDingZhiPicNew [NSString stringWithFormat:@"/index%@/new_customize",BanBenHao]

//匠心
//#define URL_DesingerList @"/index/index/cobbler"
#define URL_DesingerList [NSString stringWithFormat:@"/index%@/cobbler",BanBenHao]

//#define URL_designerChengP @"/index/index/get_chengping_goods_list"
#define URL_designerChengP [NSString stringWithFormat:@"/index%@/cobbler_goods_list",BanBenHao]


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


//#define URL_SaveList @"/index/index/my_collect"
#define URL_SaveList [NSString stringWithFormat:@"/index%@/my_collect",BanBenHao]

//#define URL_GetActorData @"/index/index/add_user_data"
#define URL_GetActorData [NSString stringWithFormat:@"/index%@/add_user_data",BanBenHao]

//#define URL_PostUserInfo @"/index/index/add_lt_data"
#define URL_PostUserInfo [NSString stringWithFormat:@"/index%@/add_lt_data",BanBenHao]


//#define URL_GetIntoDesignerImg @"/index/index/get_img"
#define URL_GetIntoDesignerImg [NSString stringWithFormat:@"/index%@/get_img",BanBenHao]


//#define URL_PostDesignerApply @"/index/index/apply_in"
#define URL_PostDesignerApply [NSString stringWithFormat:@"/index%@/apply_in",BanBenHao]

//#define URL_MyPayBag @"/index/index/my_car"
#define URL_MyPayBag [NSString stringWithFormat:@"/index%@/my_car",BanBenHao]

//#define URL_DeleteMyPayBag @"/index/index/delete_car"
#define URL_DeleteMyPayBag [NSString stringWithFormat:@"/index%@/delete_car",BanBenHao]

//#define URL_CreateOrder @"/index/index/add_order"
#define URL_CreateOrder [NSString stringWithFormat:@"/index%@/add_order_v4",BanBenHao]


//#define URL_GetOrder @"/index/index/goods_order"
#define URL_GetOrder [NSString stringWithFormat:@"/index%@/goods_order",BanBenHao]

//#define URL_GetOrderNew @"/index/index/goods_order_v5_2"
#define URL_GetOrderNew [NSString stringWithFormat:@"/index%@/goods_order_v5_2",BanBenHao]

//#define URL_UpdateUserInfo @"/index/index/change_user_info"
#define URL_UpdateUserInfo [NSString stringWithFormat:@"/index%@/change_user_info",BanBenHao]


//#define URL_GetOrderDetail @"/index/index/new_order_detail"
#define URL_GetOrderDetail [NSString stringWithFormat:@"/index%@/new_order_detail",BanBenHao]
//#define URL_YuYue @"/index/index/add_order_list"
#define URL_YuYue [NSString stringWithFormat:@"/index%@/add_order_list",BanBenHao]

//#define URL_ConfirmOrder @"/index/index/confirm_order"
#define URL_ConfirmOrder [NSString stringWithFormat:@"/index%@/confirm_order",BanBenHao]


//#define URL_invite @"/index/index/invite"
#define URL_invite [NSString stringWithFormat:@"/index%@/invite",BanBenHao]

//#define URL_YuYueData @"/index/index/get_yuyue_status"
#define URL_YuYueData [NSString stringWithFormat:@"/index%@/get_yuyue_status",BanBenHao]


//#define URL_SuggestClothes @"/index/index/goods_recommend"
#define URL_SuggestClothes [NSString stringWithFormat:@"/index%@/goods_recommend",BanBenHao]

#define URL_VIPUSERPRIVILEGE @"/index/user/user_privilege"
#define URL_VIPUSERPRIVILEGENEW @"/index/user/new_user_privilege"

#define URL_USEGRADE @"/index/user/new_user_grade"

#define URL_VipGrow @"/index/user/user_credit_record"
#define URL_Viphelp @"/index/user/user_help"
#define URL_GetBirthday @"/index/user/get_birthday_gift"
#define URL_GetVipUp @"/index/user/user_upgrade_gift"


//#define URL_GetBodyDate @"/index/index/lt_data"
#define URL_GetBodyDate [NSString stringWithFormat:@"/index%@/lt_data",BanBenHao]


#define URL_DiSanFang [NSString stringWithFormat:@"/index/login/partLogin"]


#define URL_PHOTOTAKE @"/web/cc/accept_img"
#define URL_PHOTOTAKETEST @"/web/cc/cameraImgUpload"
//#define URL_SearchWuLiu @"/index/index/kdcx"
#define URL_SearchWuLiu [NSString stringWithFormat:@"/index%@/kdcx",BanBenHao]

//我的 地址（添加）
//#define URL_AddressAdd @"/index/index/add_address"
#define URL_AddressAdd [NSString stringWithFormat:@"/index%@/add_address",BanBenHao]
// 获取
//#define URL_AddressGet @"/index/index/my_address"
#define URL_AddressGet [NSString stringWithFormat:@"/index%@/my_address",BanBenHao]
#define URL_StoreJoinShop  [NSString stringWithFormat:@"/index%@/add_carInsert",BanBenHao]
#define URL_StoreOrder  [NSString stringWithFormat:@"/index%@/quick_order",BanBenHao] 
//#define URL_AddressDelete @"/index/index/delete_address"
#define URL_AddressDelete [NSString stringWithFormat:@"/index%@/delete_address",BanBenHao]

//#define URL_ChooseAddress @"/index/index/set_default_address"
#define URL_ChooseAddress [NSString stringWithFormat:@"/index%@/set_default_address",BanBenHao]


//添加购物车
//#define URL_AddClothesCar @"/index/index/add_car"
#define URL_AddClothesCar [NSString stringWithFormat:@"/index%@/add_car",BanBenHao]


//修改购物车
//#define URL_UpdateClothesCarNum @"/index/index/change_car_num"
#define URL_UpdateClothesCarNum [NSString stringWithFormat:@"/index%@/change_car_num",BanBenHao]


//获取地址和物品信息
//#define URL_GetColthesAndAddress @"/index/index/buy"
#define URL_GetColthesAndAddress [NSString stringWithFormat:@"/index%@/buy",BanBenHao]

//#define URL_CancelOrder @"/index/index/cancel_order"
#define URL_CancelOrder [NSString stringWithFormat:@"/index%@/cancel_order",BanBenHao]

//#define URL_DeleteOrder @"/index/index/delete_order"
#define URL_DeleteOrder [NSString stringWithFormat:@"/index%@/delete_order",BanBenHao]
// 收藏
//#define URL_AddSave @"/index/index/add_user_collect"
#define URL_AddSave [NSString stringWithFormat:@"/index%@/add_user_collect",BanBenHao]

//获取定制详情
//#define URL_GetBagDingZhiDetail @"/index/index/dz_car_data"
#define URL_GetBagDingZhiDetail [NSString stringWithFormat:@"/index%@/dz_car_data",BanBenHao]


// 配置
#define URL_GETPEIZHI @"/index/sys/index"
//#define URL_GETFenLei @"/index/index/goods_classify"
#define URL_GETFenLei [NSString stringWithFormat:@"/index%@/goods_classify",BanBenHao]
//#define URL_GetMainFenLei @"/index/index/get_news_tags_arr"
#define URL_GetMainFenLei [NSString stringWithFormat:@"/index%@/get_news_tags_arr",BanBenHao]


// 支付宝支付
//#define URL_APAY @"/index/index/mk_pay_order"
#define URL_APAY [NSString stringWithFormat:@"/index%@/mk_pay_order_v4",BanBenHao]
#define URL_WXPAY @"/index/wxpay/mk_pay_order_v4"

//帮助
//#define URL_HelpType @"/index/index/help_classify"
#define URL_HelpType [NSString stringWithFormat:@"/index%@/help_classify",BanBenHao]

//#define URL_HelpList @"/index/index/help_list"
#define URL_HelpList [NSString stringWithFormat:@"/index%@/help_list",BanBenHao]

//#define URL_HelpDetail @"/index/index/help_detail"
#define URL_HelpDetail [NSString stringWithFormat:@"/index%@/help_detail",BanBenHao]

//优惠券
#define URL_Coupon @"/index/ticket/my_ticket"
#define URL_GetCoupon @"/index/ticket/exchange_ticket"
#define URL_ChooseCoupon @"/index/ticket/get_car_ticket"
#define URL_CouponRule @"/index/ticket/get_ticket_introduce"

//消息中心
#define URL_MessageType @"/index/message/message_type"
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

#define URL_GetPoper [NSString stringWithFormat:@"/index%@/exchange_gift_card",BanBenHao]   //绑定礼品卡
#define URL_GetPoperLastMoney [NSString stringWithFormat:@"/index%@/gift_card",BanBenHao]   //查询礼品卡

