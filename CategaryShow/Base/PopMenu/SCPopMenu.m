

#import "SCPopMenu.h"

@implementation SCPopMenu

static UIButton *_cover;
static UIImageView *_container;
static void(^_dismiss)();
static UIViewController *_contentVc;

+ (void)popFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void(^)())dismiss {
    _contentVc = contentVc;
    
    [self popFromRect:rect inView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void(^)())dismiss {
    _contentVc = contentVc;
    
    [self popFromView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(void(^)())dismiss {
    // block需要进行copy才能保住性命
    // block的copy作用:将block的内存从桟空间移动到堆空间
    _dismiss = [dismiss copy];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.windowLevel = UIWindowLevelStatusBar;
    
    // 遮盖
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchDown];
    cover.frame = [UIScreen mainScreen].bounds;
    [window addSubview:cover];
    _cover = cover;
    
    // 容器
    UIImageView *container = [[UIImageView alloc] init];
    container.userInteractionEnabled = YES;
    container.image = [UIImage imageNamed:@"bottleSignLabelBkg"];
    
    [window addSubview:container];
    _container = container;
    
    // 添加内容到容器中
    CGRect contentFrame = content.frame;
    contentFrame.origin.x = 3;
    contentFrame.origin.y = 7;
    content.frame = contentFrame;
    [container addSubview:content];
    
    // 计算容器的尺寸
    CGRect containerFrame = container.frame;
    containerFrame.size.width = CGRectGetMaxX(content.frame) + content.frame.origin.x + 4;
    containerFrame.size.height = CGRectGetMaxY(content.frame) + content.frame.origin.x;
    containerFrame.origin.y = CGRectGetMaxY(rect);
    container.frame = containerFrame;
    
    CGPoint containerCenter = container.center;
    containerCenter.x = CGRectGetMidX(rect);
    container.center = containerCenter;
    
    // 转换位置
    container.center = [view convertPoint:container.center toView:window];
}

/**
 *  弹出一个菜单
 *
 *  @param view    菜单的箭头指向谁
 *  @param content 菜单里面的内容
 */
+ (void)popFromView:(UIView *)view content:(UIView *)content dismiss:(void(^)())dismiss {
    [self popFromRect:view.bounds inView:view content:content dismiss:dismiss];
}

/**
 *  点击遮盖
 */
+ (void)coverClick {
    [UIView animateWithDuration:0.2 animations:^{
        _cover.alpha = 0.0;
        _container.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
        [_container removeFromSuperview];
        _cover = nil;
        _container = nil;
        _contentVc = nil;
        if (_dismiss) {
            _dismiss(); // 调用nil的block,直接报内存错误
            _dismiss = nil;
        }
    }];
}
@end