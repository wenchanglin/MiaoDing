//
//  getTheIconTitle.h
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getTheIconTitle : NSObject

+ (instancetype) getInstance;



- (void)getNotforOrForCollectionTitleAndIcon;

@property (nonatomic, retain) NSMutableArray *iconForCollection;  //mine table icon for collection

@property (nonatomic, retain) NSMutableArray *iconNotForCollection; //mine table icon not for collection


@property (nonatomic, retain) NSMutableArray *titleForCollection;  //mine table title for Collection;

@property (nonatomic, retain) NSMutableArray *titleNotForCollection;  //mine table title not for collection


@property (nonatomic, retain) NSMutableArray *iconForMainTabCollection;//main tab table icon for collection
@property (nonatomic, retain) NSMutableArray *titleForMainTabCollection;   //main tab table title for Collection;

@end
