//
//  commentModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/9.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject

@property (nonatomic, retain) NSMutableArray *collectArray;
@property (nonatomic, retain) NSMutableDictionary *commentDic;
@property (nonatomic, retain) NSString *comentNum;
@property (nonatomic, retain) NSString *likeNum;

@end
