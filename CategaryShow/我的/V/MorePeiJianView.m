//
//  MorePeiJianView.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/18.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "MorePeiJianView.h"
#import "morePeiJianCell.h"
#import "myBagModel.h"
#import "orderModel.h"
static MorePeiJianView *updateVersionView = nil;
@interface MorePeiJianView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic,strong)NSArray*dataSources;
@property(nonatomic,strong)NSString*titlestr;
@property (nonatomic, strong) UIImageView *versionView;
@property(nonatomic,strong)UILabel*titleLabels;
@property (nonatomic, copy) UpdateVersionGoBlock doneBlock;
@property(nonatomic,strong)UIButton*sureBtn;
@property(nonatomic,assign)NSInteger ischengping;
@property(nonatomic,strong)NSString*selectstr;
@end
@implementation MorePeiJianView
+(void)showWithData:(NSArray*)dataArr withTitle:(NSString*)title isChengPing:(NSInteger)ischengping withDoneBlock:(nonnull UpdateVersionGoBlock)doneBlock
{
    if (!updateVersionView) {
        updateVersionView = [[MorePeiJianView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withData:dataArr withTitle:title withDoneBlock:doneBlock isChengPing:ischengping];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:updateVersionView];
        //
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:.9
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             updateVersionView.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                         }
                         completion:^(BOOL finished) {
                         }];
        
    }
    
}
- (void)createUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    self.bgView = bgView;
    UIImageView *versionView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    //    [self addGestureRecognizer:tap];
    versionView.layer.cornerRadius=5;
    versionView.layer.masksToBounds=YES;
    versionView.userInteractionEnabled = YES;
    versionView.backgroundColor=[UIColor whiteColor];
    [self.bgView addSubview:versionView];
    [versionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.mas_equalTo(150);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(400);
    }];
    self.versionView = versionView;
    self.titleLabels = [UILabel new];
    self.titleLabels.text = self.titlestr;
    self.titleLabels.textColor = [UIColor colorWithHexString:@"#101010"];
    self.titleLabels.font =[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.versionView addSubview:self.titleLabels];
    [self.titleLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.versionView.mas_centerX);
        make.top.equalTo(self.versionView.mas_top).offset(20);
        make.height.mas_equalTo(25);
    }];
    UIButton* quedingBtn = [UIButton new];
    quedingBtn.layer.cornerRadius=20;
    quedingBtn.layer.masksToBounds=YES;
    [quedingBtn addTarget:self action:@selector(gotoUpdate) forControlEvents:UIControlEventTouchUpInside];
    [quedingBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.versionView addSubview:quedingBtn];
    [quedingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.versionView.mas_bottom).offset(-15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(228);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.versionView addSubview:self.tableView];
    [self.tableView registerClass:[morePeiJianCell class] forCellReuseIdentifier:@"morePeiJianCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabels.mas_bottom).offset(10);
        make.left.right.equalTo(self.versionView);
        make.bottom.equalTo(quedingBtn.mas_top).offset(-5);
    }];
    UIButton *dismissButton = [[UIButton alloc]init];
    [dismissButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    [self.versionView addSubview: dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionView.mas_top).offset(18);
        make.right.equalTo(self.versionView.mas_right).offset(-18);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ischengping==2) {
       skuModel *model = _dataSources[indexPath.row];
        morePeiJianCell*cell = [tableView dequeueReusableCellWithIdentifier:@"morePeiJianCell" forIndexPath:indexPath];
        cell.nameLabel.text =model.type;
        cell.valueLabel.text = model.value;
        return cell;
    }
    else
    {
    partModel*model = _dataSources[indexPath.row];
    morePeiJianCell*cell = [tableView dequeueReusableCellWithIdentifier:@"morePeiJianCell" forIndexPath:indexPath];
    cell.nameLabel.text =model.part_name;
    cell.valueLabel.text = model.part_value;
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectstr = _dataSources[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)dismissView{
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         self.versionView.top = SCREEN_HEIGHT;
                     }
                     completion:^(BOOL finished) {
                         [updateVersionView removeFromSuperview];
                         updateVersionView = nil;
                     }];
}

- (void)gotoUpdate {
    self.doneBlock(self.selectstr);
    [self dismissView];
}
- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray*)arr withTitle:(NSString*)title withDoneBlock:(UpdateVersionGoBlock)doneBlock isChengPing:(NSInteger)chengping
{
    self = [super initWithFrame:frame];
    if (self) {
        _doneBlock =doneBlock;
        _dataSources = arr;
        _titlestr =title;
        _ischengping=chengping;
        [self createUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
