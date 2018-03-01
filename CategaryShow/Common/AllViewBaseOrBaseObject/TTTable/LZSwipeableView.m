//
//  LZSwipeableView.m
//  ZLSwipeCardableView
//
//  Created by LeoZ on 16/4/6.
//  Copyright © 2016年 LeoZ. All rights reserved.
//

#import "LZSwipeableView.h"
#import "LZSwipeCostantDefine.h"



// 通用性父类cell,集成此父类即可自定义cell
@class LZSwipeableViewCell;
@protocol LZSwipeableViewCellDelagate <NSObject>
@optional
- (void)swipeableViewCellDidRemoveFromSuperView:(LZSwipeableViewCell *)cell;
@end



@interface LZSwipeableViewCell ()
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, weak) id<LZSwipeableViewCellDelagate> delegate;
@end


@implementation LZSwipeableViewCell{
    CGFloat xFromCenter;
    CGFloat yFromCenter;
    UIPanGestureRecognizer *pan;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    // 为防止在初始化cell时 采用masonry布局子控件设置固定高度产生的约束冲突 初始化cell的时候提供初始化尺寸 在reloadData时会对cell进行重新布局
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)]){
        self.reuseIdentifier = reuseIdentifier;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)addSnapshotView:(UIView*)snapshotView {
    [self removeSnapshotView];
    
    UIView *view = snapshotView;
    view.tag = INTMAX_MAX;
    view.frame = self.bounds;
    if (view) {
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:view];
    }
}

- (void)removeSnapshotView {
    [[self viewWithTag:INTMAX_MAX] removeFromSuperview];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    // 设置阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影颜色
    self.layer.shadowOpacity = 0.25; // 设置阴影不透明度
    self.layer.shadowOffset = CGSizeMake(0, 5); // 设置阴影位置偏差
    self.layer.shadowRadius = 5.0; // 设置阴影圆角半径
    
    // 内容容器视图
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}


// 拖拽手势事件处理
- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer{
    
    xFromCenter = [gestureRecognizer translationInView:self].x;
    yFromCenter = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            self.transform = CGAffineTransformMakeTranslation(xFromCenter, yFromCenter);
            break;
        };
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.center = self.originalPoint;
                                 self.transform = CGAffineTransformIdentity;
                             }];
            break;
        };
    }
}

// 拖拽手势结束时 处理当前卡片的位置
- (void)afterSwipeAction
{
    if(!self.isLast){ // 非最后一张卡片
        if (xFromCenter > ACTION_MARGIN) { // 右边飞走
            [self rightAction];
        } else if (xFromCenter < -ACTION_MARGIN) { // 左边飞走
            [self leftAction];
        } else if (yFromCenter > ACTION_MARGIN) { // 底部飞走
            [self bottomAction];
        } else if (yFromCenter < -ACTION_MARGIN) { // 上边飞走
            [self topAction];
        }else { // 不飞走 回复原来位置
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.transform = CGAffineTransformIdentity;
                self.center = self.originalPoint;
            } completion:^(BOOL finished) {
            }];
        }
    }
    else { // 最后一张卡片不飞走
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
            self.center = self.originalPoint;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)rightAction
{
    CGFloat pointY = _originalPoint.y + (SCREEN_WIDTH + self.width) / 2 * yFromCenter / xFromCenter;
    CGFloat pointX = _originalPoint.x + (SCREEN_WIDTH + self.width) / 2;
    CGPoint finishPoint = CGPointMake(pointX,pointY);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        [self didCellRemoveFromSuperview];
    }];
}

-(void)leftAction
{
    CGFloat pointY = _originalPoint.y - (SCREEN_WIDTH + self.width) / 2 * yFromCenter / xFromCenter;
    CGFloat pointX = _originalPoint.x - (SCREEN_WIDTH + self.width) / 2;
    CGPoint finishPoint = CGPointMake(pointX,pointY);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        [self didCellRemoveFromSuperview];
    }];
}

-(void)topAction
{
    CGFloat pointY = _originalPoint.y - (SCREEN_HEIGHT + self.height) / 2;
    CGFloat pointX = _originalPoint.x - (SCREEN_HEIGHT + self.height) / 2 * xFromCenter / yFromCenter;
    CGPoint finishPoint = CGPointMake(pointX,pointY);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        [self didCellRemoveFromSuperview];
    }];
}

-(void)bottomAction
{
    CGFloat pointY = _originalPoint.y + (SCREEN_HEIGHT + self.height) / 2;
    CGFloat pointX = _originalPoint.x + (SCREEN_HEIGHT + self.height) / 2 * xFromCenter / yFromCenter;
    CGPoint finishPoint = CGPointMake(pointX,pointY);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        [self didCellRemoveFromSuperview];
    }];
}

// 卡片飞走后调用代理方法
- (void)didCellRemoveFromSuperview{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(swipeableViewCellDidRemoveFromSuperView:)]) {
        [self.delegate swipeableViewCellDidRemoveFromSuperView:self];
    }
}
@end


@interface LZSwipeableView ()<UIGestureRecognizerDelegate,LZSwipeableViewCellDelagate>
/** 容器视图  */
@property (nonatomic, strong) UIView *containerView;

/** 最大显示卡片数  */
@property (nonatomic, assign) NSInteger maxCardsShowNumber;

/** 当前显示的卡片视图数组  */
@property (nonatomic, strong) NSArray *cardViewArray;

/** 所有卡片数组  */
@property (nonatomic, assign) NSInteger totalCardViewArrayCount;

/** 重用卡片数组  */
@property (nonatomic, strong) NSMutableArray *reuseCardViewArray;

/** 初始中心点  */
@property (nonatomic, assign) CGPoint originalPoint;
/** 结束中心点 */
@property (nonatomic, assign) CGPoint endPoint;

/** 注册cell  */
@property (nonatomic, assign) BOOL hasRegisterNib;
@property (nonatomic, assign) BOOL hasRegisterClass;

/** 重用标示  */
@property (nonatomic, strong) NSString *reuserNibIdentifier;
@property (nonatomic, strong) NSString *reuserClassIdentifier;

/** nib */
@property (nonatomic, strong) NSString *nibName;
/** class  */
@property (nonatomic, assign) Class cellClass;

// 头部和尾部视图
@property (nonatomic, strong,readwrite) UIView *headerView;
@property (nonatomic, strong,readwrite) UIView *footerView;

/** 正在创建cell  */
@property (nonatomic, assign) BOOL isCreating;

/** 数据源  */
@property (nonatomic, assign) NSInteger datasourceCount;
@end

@implementation LZSwipeableView

//- (NSMutableArray *)cardViewArray{
//    if (!_cardViewArray) {
//        _cardViewArray = [NSMutableArray array];
//    }
//    return _cardViewArray;
//}

- (NSMutableArray *)reuseCardViewArray{
    if (!_reuseCardViewArray) {
        _reuseCardViewArray = [NSMutableArray array];
    }
    return _reuseCardViewArray;
}


//- (NSMutableArray *)totalCardViewArray{
//    if (!_totalCardViewArray) {
//        _totalCardViewArray = [NSMutableArray array];
//    }
//    return _totalCardViewArray;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}


- (void)registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier{
    self.hasRegisterNib = YES;
    self.nibName = nibName;
    self.reuserNibIdentifier = identifier;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    self.hasRegisterClass = YES;
    self.cellClass = cellClass;
    self.reuserClassIdentifier = identifier;
}

- (__kindof LZSwipeableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    if (_hasRegisterNib) { // 注册nib
        BOOL hasNibCell = NO;
        for (LZSwipeableViewCell *cell in self.reuseCardViewArray) {
            if ([cell.reuseIdentifier isEqualToString:identifier]) {
                hasNibCell = YES;
                [self.reuseCardViewArray removeObject:cell];
                return cell;
            }
        }
        if (!hasNibCell) {
            LZSwipeableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:self.nibName owner:nil options:nil].lastObject;
            cell.reuseIdentifier = identifier;
            return cell;
        }
    }else if(_hasRegisterClass){ // 注册class
        BOOL hasCellClass = NO;
        for (LZSwipeableViewCell *cell in self.reuseCardViewArray) {
            if ([cell.reuseIdentifier isEqualToString:identifier]) {
                hasCellClass = YES;
                [self.reuseCardViewArray removeObject:cell];
                return cell;
            }
        }
        if (!hasCellClass) {
            LZSwipeableViewCell *cell = [[self.cellClass alloc] initWithReuseIdentifier:identifier];
            cell.reuseIdentifier = identifier;
            return cell;
        }
    }
    return nil;
}

- (void)setupSubViews{
    // 初始化容器视图
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor colorWithHex:0xebebeb];
    [self addSubview:self.containerView];
    
    // 默认最大卡片实现数量
    self.maxCardsShowNumber = LZSwipeableViewDefaultMaxShowCardNumber;
    
    self.originalPoint = CGPointMake((self.width - 40 )/ 2, 20 + (self.height - 60) / 2);
}

// 刷新界面(第一次刷新视图时使用)
- (void)reloadData{
    if (self.datasourceCount <= 0) return;
    self.cardViewArray = nil;
    self.reuseCardViewArray = nil;
//    self.totalCardViewArray = nil;
    self.totalCardViewArrayCount = 0;
    
    for (UIView *subView in self.containerView.subviews) {
        if ([subView isKindOfClass:[LZSwipeableViewCell class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSInteger showNumber = self.datasourceCount < [self getCurrentShowCount] ? self.datasourceCount : [self getCurrentShowCount];
    
    for (int i = 0; i < showNumber; i++) {
        [self createSwipeableCardCellWithIndex:i];
    }
    
    [self layoutCardViews];
    
    
    // 添加屏幕截图
//    NSMutableArray *cellArray = [NSMutableArray array];
//    
//    for (UIView  *subView in self.containerView.subviews) {
//        if ([subView isKindOfClass:[LZSwipeableViewCell class]]) {
//            [cellArray insertObject:subView atIndex:0];
//        }
//    }
    
    CGSize normalSize = self.containerView.size;
    CGSize size = CGSizeMake(normalSize.width - 40, normalSize.height - (self.maxCardsShowNumber - 1) * 9);
    if ([self.delegate respondsToSelector:@selector(swipeableViewSizeForTopCard:)]) {
        CGSize expectSize = [self.delegate swipeableViewSizeForTopCard:self];
        size = CGSizeMake(expectSize.width - 40, expectSize.height - (self.maxCardsShowNumber - 1) * 9);
    }
    for (int index = 0; index < self.cardViewArray.count; index++) {
        if (index != 0) {
            if ([self.delegate respondsToSelector:@selector(swipeableView:substituteCellForIndex:)]) {
                LZSwipeableViewCell *cell = self.cardViewArray[index];
                LZSwipeableViewCell *subCell = [self.delegate swipeableView:self substituteCellForIndex:cell.tag];
                subCell.layer.shadowColor = [UIColor clearColor].CGColor; // 设置阴影颜色
                subCell.layer.shadowOpacity = 0; // 设置阴影不透明度
                subCell.layer.shadowOffset = CGSizeMake(0, 0); // 设置阴影位置偏差
                subCell.layer.shadowRadius = 0; // 设置阴影圆角半径
                subCell.frame = CGRectMake(0, 0, size.width, size.height);
                
                [subCell setNeedsLayout];
                [subCell layoutIfNeeded];
                [cell addSnapshotView:subCell.snapshotView];
            }
        }
    }
}

// 刷新位置(用于父控件位置改变时调用)
- (void)layoutCardViews{

    CGSize normalSize = self.containerView.size;
    CGSize size = CGSizeMake(normalSize.width - 40, normalSize.height - (self.maxCardsShowNumber - 1) * 9);
    if ([self.delegate respondsToSelector:@selector(swipeableViewSizeForTopCard:)]) {
        CGSize expectSize = [self.delegate swipeableViewSizeForTopCard:self];
        size = CGSizeMake(expectSize.width - 40, expectSize.height - (self.maxCardsShowNumber - 1) * 9);
    }
    for (int i = 0; i < self.cardViewArray.count; i++) {
        LZSwipeableViewCell *cell = self.cardViewArray[i];
        if (i == 0) {
            if ([self.delegate respondsToSelector:@selector(swipeableView:didTopCardShow:)]) {
                [self.delegate swipeableView:self didTopCardShow:cell];
            }
            cell.userInteractionEnabled = YES;
        }
        CGSize cellSize = CGSizeMake(size.width - 20 * i, size.height * (size.width - 20 * i) / size.width);
        CGFloat x = 20 + 10 * i;
        CGFloat y = 20 + 9 * i + (size.height - size.height * (size.width - 20 * i) / size.width);
        cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
    }
}



- (void)setDelegate:(id<LZSwipeableViewDelegate>)delegate{
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(headerViewForSwipeableView:)]) {
        self.headerView = [self.delegate headerViewForSwipeableView:self];
        [self insertSubview:self.headerView belowSubview:self.containerView];
    }
    
    if ([self.delegate respondsToSelector:@selector(footerViewForSwipeableView:)]) {
        self.footerView = [self.delegate footerViewForSwipeableView:self];
        [self insertSubview:self.footerView belowSubview:self.containerView];
    }
    
}

// 获取当前要显示的卡片数
- (NSInteger)getCurrentShowCount{
    if ([self.datasource respondsToSelector:@selector(swipeableViewMaxCardNumberWillShow:)]) {
        self.maxCardsShowNumber = [self.datasource swipeableViewMaxCardNumberWillShow:self] > 0 ? [self.datasource swipeableViewMaxCardNumberWillShow:self] : LZSwipeableViewDefaultMaxShowCardNumber;
    }
    return self.maxCardsShowNumber;
}


// 创建新的cell
- (void)createSwipeableCardCellWithIndex:(NSInteger)index{
    self.isCreating = YES;
    LZSwipeableViewCell *cell = [self.datasource swipeableView:self cellForIndex:index];
    cell.tag = index;
    cell.delegate = self;
    cell.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [cell addGestureRecognizer:tap];
    [self.containerView insertSubview:cell atIndex:0];
    NSLog(@"%@",self.containerView.subviews);
//    [self.cardViewArray addObject:cell];
//    [self.totalCardViewArray addObject:cell];
    self.totalCardViewArrayCount += 1;
    self.isCreating = NO;
}

- (NSArray *)cardViewArray{
    NSMutableArray *cellArray = [NSMutableArray array];

    for (UIView  *subView in self.containerView.subviews) {
        if ([subView isKindOfClass:[LZSwipeableViewCell class]]) {
            [cellArray insertObject:subView atIndex:0];
        }
    }
    return cellArray;
}


// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 头部视图存在
    if (self.headerView) {
        if([self.delegate respondsToSelector:@selector(heightForHeaderView:)]){
            self.headerView.height = [self.delegate heightForHeaderView:self];
        }else{
            self.headerView.height = 49;
        }
        self.headerView.frame = CGRectMake(0, 0, self.width, self.headerView.height);
    }
    
    if (self.footerView) { // 底部视图存在
        if([self.delegate respondsToSelector:@selector(heightForFooterView:)]){
            self.footerView.height = [self.delegate heightForFooterView:self];
        }else{
            self.footerView.height = 49;
        }
    }
    
    CGRect containerFrame = self.bounds;
    if(self.headerView && self.footerView == nil){
        containerFrame = CGRectMake(0, self.headerView.height, self.width, self.height - self.headerView.height);
    }else if(self.headerView == nil && self.footerView){
        containerFrame = CGRectMake(0, 0, self.width, self.height - self.footerView.height);
    }else if (self.headerView && self.footerView){
        containerFrame = CGRectMake(0, self.headerView.height, self.width, self.height - self.headerView.height - self.footerView.height);
    }
    self.containerView.frame = containerFrame;
    
    if (self.footerView) {
        self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.containerView.frame), self.width, self.footerView.height);
    }
}

- (void)updateSubViews{
    CGSize normalSize = self.containerView.size;
    CGSize size = CGSizeMake(normalSize.width - 40, normalSize.height - 58);
    if ([self.delegate respondsToSelector:@selector(swipeableViewSizeForTopCard:)]) {
        CGSize expectSize = [self.delegate swipeableViewSizeForTopCard:self];
        size = CGSizeMake(expectSize.width - 40, expectSize.height - 58);
    }
    

    // 添加屏幕截图
//    NSMutableArray *cellArray = [NSMutableArray array];
//
//    for (UIView  *subView in self.containerView.subviews) {
//        if ([subView isKindOfClass:[LZSwipeableViewCell class]]) {
//            [cellArray insertObject:subView atIndex:0];
//        }
//    }
    
    // 添加屏幕截图
    for (int i = 0; i < self.cardViewArray.count; i++) {
        LZSwipeableViewCell *cell = self.cardViewArray[i];
        if ([self.delegate respondsToSelector:@selector(swipeableView:substituteCellForIndex:)]) {
            LZSwipeableViewCell *subCell = [self.delegate swipeableView:self substituteCellForIndex:cell.tag];
            subCell.layer.shadowColor = [UIColor clearColor].CGColor; // 设置阴影颜色
            subCell.layer.shadowOpacity = 0; // 设置阴影不透明度
            subCell.layer.shadowOffset = CGSizeMake(0, 0); // 设置阴影位置偏差
            subCell.layer.shadowRadius = 0; // 设置阴影圆角半径
            subCell.frame = CGRectMake(0, 0, size.width, size.height);
            [subCell setNeedsLayout];
            [subCell layoutIfNeeded];
            [cell addSnapshotView:subCell.snapshotView];
        }
    }
    
    if (self.cardViewArray.count == self.maxCardsShowNumber) {
        // 位置重排 为动画前位置调整
        for (int i = 0; i < self.cardViewArray.count; i++) {
            LZSwipeableViewCell *cell = self.cardViewArray[i];
            if (i == self.cardViewArray.count - 1) {
                CGSize cellSize = CGSizeMake(size.width - 20 * i, size.height * (size.width - 20 * i) / size.width);
                CGFloat x = 20 + 10 * i;
                CGFloat y = 20 + 9 * i + (size.height - size.height * (size.width - 20 * i) / size.width);
                cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
            }else{ // 其余卡片
                CGSize cellSize = CGSizeMake(size.width - 20 * (i + 1), size.height * (size.width - 20 * (i + 1)) / size.width);
                CGFloat x = 20 + 10 * (i + 1);
                CGFloat y = 20 + 9 * (i + 1) + (size.height - size.height * (size.width - 20 * (i + 1)) / size.width);
                cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
            }
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
    
    // 动画
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         for (int i = 0; i < self.cardViewArray.count; i++) {
                             LZSwipeableViewCell *cell = self.cardViewArray[i];
                             CGFloat x = 20 + 10 * i;
                             CGFloat y = 20 + 9 * i + (size.height - size.height * (size.width - 20 * i) / size.width);
                             CGSize cellSize = CGSizeMake(size.width - 20 * i, size.height * (size.width - 20 * i) / size.width);
                             cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
                         }
                     } completion:^(BOOL finished) {
                         for (int i = 0; i < self.cardViewArray.count; i++) {
                             LZSwipeableViewCell *cell = self.cardViewArray[i];
                             if (i == 0) {
                                 if ([self.delegate respondsToSelector:@selector(swipeableView:didTopCardShow:)]) {
                                     [self.delegate swipeableView:self didTopCardShow:cell];
                                 }
                                 [cell removeSnapshotView];
                                 cell.userInteractionEnabled = YES;
                             }
                         }
                     }];
    
}

- (void)setLayoutSubViews{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutCardViews];
}

#pragma mark - gesture
- (void)tap:(UITapGestureRecognizer *)tap{
    if([self.delegate  respondsToSelector:@selector(swipeableView:didTapCellAtIndex:)]){
        [self.delegate swipeableView:self didTapCellAtIndex:tap.view.tag];
    }
}


#pragma mark - 刷新数据源
- (void)refreshDataSource{
    self.datasourceCount = [self.datasource swipeableViewNumberOfRowsInSection:self];
    
    
    
//    NSMutableArray *cellArray = [NSMutableArray array];
//
//    for (UIView  *subView in self.containerView.subviews) {
//        if ([subView isKindOfClass:[LZSwipeableViewCell class]]) {
//            [cellArray insertObject:subView atIndex:0];
//        }
//    }
    
    // 当总数变化大于当前总数时(且当前显示卡片小于最大卡片数时继续创建)，继续创建cell
    if (self.datasourceCount - self.totalCardViewArrayCount > 0 && self.cardViewArray.count < self.maxCardsShowNumber) {
        NSInteger moreCount = self.datasourceCount - self.cardViewArray.count;
        NSInteger needCount = 0;
        if (moreCount >= self.maxCardsShowNumber - 1) { // 能创建全部的cell
            needCount = self.maxCardsShowNumber - self.cardViewArray.count;
            for (NSInteger i = 0; i < needCount; i++) {
                if (!self.isCreating) {
                    [self createSwipeableCardCellWithIndex:self.totalCardViewArrayCount];
                }
            }
        }else{ // 不能全部创建cell
            needCount = self.maxCardsShowNumber - 1 - self.cardViewArray.count;
            for (NSInteger i = 0; i < needCount; i++) {
                if (!self.isCreating) {
                    [self createSwipeableCardCellWithIndex:self.totalCardViewArrayCount];
                }
            }
        }
        [self updateSubViews];
    }
}

// 获取数据源数组数量
- (NSInteger)datasourceCount{
    return [self.datasource swipeableViewNumberOfRowsInSection:self];
}

#pragma mark - LZSwipeableViewCellDelagate
- (void)swipeableViewCellDidRemoveFromSuperView:(LZSwipeableViewCell *)cell{
    // 当cell被移除时重新刷新视图
//    [self.cardViewArray removeObject:cell];
    [self.reuseCardViewArray addObject:cell];
    
    // 当前数据源还有数据 继续创建cell
    if (self.datasourceCount > self.totalCardViewArrayCount) { // 当显示总数
        [self createSwipeableCardCellWithIndex:self.totalCardViewArrayCount];
    }
    
    // 更新位置
    [self updateSubViews];
    
    // 通知代理 移除了当前cell
    if ([self.delegate respondsToSelector:@selector(swipeableView:didCardRemovedAtIndex:)]) {
        [self.delegate swipeableView:self didCardRemovedAtIndex:cell.tag];
    }
    
    
    // 移除最后一个cell的代理方法
    if (self.cardViewArray.count == 0) { // 当前移除的cell是最后一个
        if ([self.delegate respondsToSelector:@selector(swipeableViewDidLastCardRemoved:)]) {
            [self.delegate swipeableViewDidLastCardRemoved:self];
        }
    }
    
    // 移除后的卡片是最后一张时调用代理方法
    if(self.cardViewArray.count == 1){ // 只有最后一张卡片的时候
        if ([self.delegate respondsToSelector:@selector(swipeableView:didLastCardShow:)]) {
            [self.delegate swipeableView:self didLastCardShow:[self.cardViewArray lastObject]];
        }
    }
}



@end
