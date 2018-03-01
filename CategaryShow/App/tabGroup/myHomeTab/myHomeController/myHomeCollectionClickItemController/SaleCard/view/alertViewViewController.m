//
//  alertViewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "alertViewViewController.h"

@interface alertViewViewController ()<UITextFieldDelegate>

@end

@implementation alertViewViewController
{
    UITextField *codeText;
    UIButton *done;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)createView
{
    UIView *backAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backAlpha setBackgroundColor:[UIColor grayColor]];
    [backAlpha setAlpha:0.5];
    [self.view addSubview:backAlpha];
    
    
    
    
    UIView *Popup = [UIView new];
    [self.view addSubview:Popup];
    Popup.sd_layout
    .leftSpaceToView(self.view, 37)
    .rightSpaceToView(self.view, 37)
    .bottomSpaceToView(self.view, 295)
    .heightIs(175);
    [Popup.layer setCornerRadius:5];
    [Popup.layer setMasksToBounds:YES];
    [Popup setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [UIView new];
    [Popup addSubview:lineView];
    lineView.sd_layout
    .bottomSpaceToView(Popup, 47)
    .heightIs(1)
    .rightEqualToView(Popup)
    .leftEqualToView(Popup);
    [lineView setBackgroundColor:getUIColor(Color_lightGrayLine)];
    [lineView setAlpha:0.8];
    
    UILabel *titleLabel = [UILabel new];
    [Popup addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(Popup, 20)
    .centerXEqualToView(Popup)
    .heightIs(20)
    .widthIs(100);
    [titleLabel setText:@"添加礼品卡"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    codeText = [UITextField new];
    [Popup addSubview:codeText];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    codeText.leftView = view;
    codeText.leftViewMode = UITextFieldViewModeAlways;
    codeText.sd_layout
    .topSpaceToView(titleLabel, 15)
    .rightSpaceToView(Popup, 25)
    .leftSpaceToView(Popup, 25)
    .heightIs(40);
    codeText.delegate = self;
    [codeText.layer setCornerRadius:3];
    [codeText.layer setMasksToBounds:YES];
    [codeText.layer setBorderColor:getUIColor(Color_lightGrayLine).CGColor];
    [codeText.layer setBorderWidth:1];
    [codeText setPlaceholder:@"请输入密码"];
    [codeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIButton *Cancel = [UIButton new];
    [Popup addSubview:Cancel];
    Cancel.sd_layout
    .leftEqualToView(Popup)
    .heightIs(47)
    .widthIs(149)
    .bottomEqualToView(Popup);
    [Cancel setTitle:@"取消" forState:UIControlStateNormal];
    [Cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [Cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineV = [UIView new];
    [Popup addSubview:lineV];
    lineV.sd_layout
    .leftSpaceToView(Cancel, 0)
    .bottomEqualToView(Popup)
    .heightIs(47)
    .widthIs(1);
    [lineV setBackgroundColor:getUIColor(Color_lightGrayLine)];
    
    done = [UIButton new];
    [Popup addSubview:done];
    done.sd_layout
    .rightEqualToView(Popup)
    .heightIs(47)
    .widthIs(149)
    .bottomEqualToView(Popup);
    [done setTitle:@"绑定" forState:UIControlStateNormal];
    [done setUserInteractionEnabled:NO];
    [done setTitleColor:getUIColor(Color_lightGrayLine) forState:UIControlStateNormal];
    [done.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [done addTarget:self action:@selector(adoneClickAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length > 0) {
        [done setUserInteractionEnabled:YES];
        [done setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)adoneClickAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(doneClickActin:)]) {
        [_delegate doneClickActin:codeText.text];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
