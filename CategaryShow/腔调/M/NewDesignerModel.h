//
//  NewDesignerModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/10.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DesignerGoodsListModel;
@interface NewDesignerModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *story;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *bg_img;
@property(nonatomic)NSInteger goods_num;
@property(nonatomic)NSInteger collect_num;
@property(nonatomic)NSInteger sale_num;
@property(nonatomic,strong) NSArray * goods_list;
@property(nonatomic,strong)NSString * tag;
@end
@interface DesignerGoodsListModel:NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString *sub_name;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *c_time;
@property(nonatomic,strong)NSString * img_info;
@property (nonatomic) NSInteger goodsListId;
@property (nonatomic) NSInteger is_love;
@property (nonatomic) NSInteger is_collect;
@property(nonatomic)NSInteger love_num;
//"": "FC700080",
//"": "/uploads/img/2017112302201097549852.jpg",
//"id": 72,
//"type": 2,
//"c_time": "",
//"is_love": 0,
//"is_collect": 0,
//"love_num": 1
@end
