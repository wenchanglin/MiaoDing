//
//  HHBaseViewController.h
//  DalianPort
//
//  Created by mac on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseDomain.h"
#import "UrlManager.h"
#import "SelfPersonInfo.h"
#import "JYHColor.h"
#import "XHImageViewer.h"
#import "NSDictionary+EmptyString.h"
#import "CommonFunction.h"
#import "userInfoModel.h"
@interface BaseViewController : UIViewController //<UITextFieldDelegate,UIAlertViewDelegate>

@property (retain,nonatomic) UIBarButtonItem *buttonBarLeft;

@property (retain,nonatomic) UIBarButtonItem *buttonBarRight;

@property (retain,nonatomic) UIView * viewRootBak;

@property (nonatomic, assign) NSInteger flogNumber;

- (void) setRigthButtonDefaultStyle :(id) target action:(SEL) action;


- (void)progressShow:(NSString*) title animated:(BOOL)animated;

- (void)progressHide:(BOOL)animated;

- (Boolean) checkHttpResponseResultStatus:(id) domain;

- (void)setExtraCellLineHidden: (UITableView *)tableView;

- (Boolean)checkCompanyResultStatus;
- (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width;
- (Boolean)checkCOmpanyRenZhengOrNot:(NSString *)string;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
-(UIImage *)imageWithColor:(UIColor *)color;
+ (NSString*) getFriendlyDateString : (long long) lngDate;
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
-(void)settabTitle :(NSString *)title;
-(void)settabImg:(NSString *)Img;
-(void )getDateBegin:(NSDate *)dateBegin currentView:(NSString *)view1 fatherView:(NSString *)view2;

-(void)getDateBeginHaveReturn:(NSDate *)dateBegin  fatherView:(NSString *)view2;


-(void)getDateDingZhi:(NSMutableDictionary *)dic beginDate:(NSDate *)date ifDing:(BOOL)ding;

- (void)onSpaceViewClickToCloseKeyboard:(id)sender;
- (CGFloat)cellContentViewWith;
-(Boolean)userHaveLogin;

-(BOOL)networking;
-(void)showJiaZaiAlert;

-(void)alertViewShowOfTime :(NSString *)message time:(NSInteger )time;
- (NSString*)deviceVersion;
@end
