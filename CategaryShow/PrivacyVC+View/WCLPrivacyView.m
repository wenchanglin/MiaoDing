//
//  WCLPrivacyView.m
//  PhotoAppStore
//
//  Created by 文长林 on 2018/11/28.
//  Copyright © 2018年 黄梦炜. All rights reserved.
//

#import "WCLPrivacyView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WCLPrivacyH5ViewController.h"
@interface WCLPrivacyView()<YBAttributeTapActionDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray*fourArr;
@end
@implementation WCLPrivacyView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        self.fourArr = @[@"1.本公司如何收集你的部分必要信息.",@"2.本公司如何使用你的个人信息.",@"3.个人信息安全问题.",@"4.本公司会将个人信息保存多久"];
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.contentMode=UIViewContentModeScaleAspectFill;
    blackView.userInteractionEnabled=YES;
    UIImage *image =[UIImage imageNamed:@"yinsizc"];
    blackView.layer.contents = (id)image.CGImage;
    [self addSubview:blackView];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"妙定隐私政策";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:AdaptW(23)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [blackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT/3-AdaptW(25));
        make.centerX.equalTo(self.mas_centerX);
    }];
    UILabel*detailLabel1 = [UILabel new];
    detailLabel1.textAlignment=NSTextAlignmentCenter;
    detailLabel1.font=[UIFont boldSystemFontOfSize:AdaptW(14)];
    detailLabel1.text =@"本隐私政策将向您说明:";
    [blackView addSubview:detailLabel1];
    [detailLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(AdaptW(28));
        make.centerX.equalTo(self.mas_centerX);
    }];
    UITableView*tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.estimatedRowHeight=35;
    [blackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(detailLabel1.mas_bottom).offset(AdaptW(6));
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.height.mas_equalTo(160);
    }];

    NSString *label_text2 = @"你可以查看完整版的隐私政策";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AdaptW(14)] range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([label_text2 length]-4, 4)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label_text2 length])];
    
    UILabel *ybLabel2 = [[UILabel alloc] init];
    [ybLabel2 setTextColor:getUIColor(Color_loginNoUserName)];
    [ybLabel2 setFont:[UIFont systemFontOfSize:AdaptW(14)]];
    ybLabel2.attributedText = attributedString2;
    [ybLabel2 setTextAlignment:NSTextAlignmentCenter];
    [blackView addSubview:ybLabel2];
    [ybLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.mas_bottom).offset(AdaptW(22));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [ybLabel2 yb_addAttributeTapActionWithStrings:@[@"隐私政策"] delegate:self];
    UIButton*disagreeBtn = [UIButton new];
    disagreeBtn.tag=887;
    [disagreeBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [disagreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
    [disagreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    disagreeBtn.layer.cornerRadius =2;
    disagreeBtn.layer.borderWidth=1;
    disagreeBtn.layer.borderColor=getUIColor(Color_loginNoUserName).CGColor;
    [blackView addSubview:disagreeBtn];
    [disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ybLabel2.mas_bottom).offset(50);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH/2-30);
        make.height.mas_equalTo(38);
    }];
    UIButton*agreeBtn = [UIButton new];
    agreeBtn.tag=888;
    [agreeBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitle:@"同    意" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.backgroundColor = [UIColor blackColor];
    agreeBtn.layer.cornerRadius =2;
    [blackView addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ybLabel2.mas_bottom).offset(50);
        make.left.equalTo(disagreeBtn.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH/2-20);
        make.height.mas_equalTo(38);
    }];
}
-(void)twoBtnClick:(UIButton*)btn
{
    switch (btn.tag) {
        case 887:
            {
                UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要同意《妙定隐私政策》方可使用本软件" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction*sureAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sureAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            break;
        case 888:
        {
            self.agreeBlock();
            [UIView animateWithDuration:.2 animations:^{
                [self removeFromSuperview];
            }];
        }
            break;
        default:
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fourArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cellss"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellss"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:AdaptW(13)];
    cell.textLabel.text = self.fourArr[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
//    NSLog(@"你点击了我");
    self.privacyBlock(index);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
