//
//  UserFeedBackViewController.m
//  wyh
//
//  Created by bobo on 16/1/5.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "UserFeedBackViewController.h"
#import "PlaceholderTextView.h"
#import "PhotoCollectionViewCell.h"
#import "TZImagePickerController.h"
#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface UserFeedBackViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) UIView * aView;

@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;

@property (nonatomic, retain) NSString *photoDataArray;

//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;
//回收键盘
@property (nonatomic, strong)UITextField *textField;

//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
//邮箱
@property (nonatomic, assign)BOOL emailRight;
//手机
@property (nonatomic, assign)BOOL phoneRight;
//QQ
@property (nonatomic, assign)BOOL qqRight;



@end


@implementation UserFeedBackViewController
{
    BaseDomain *postData;
    NSMutableArray *selectedAssets;
}
//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (!_photoArrayM) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArrayM;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.frame = CGRectMake(10, 24+NavHeight, self.view.frame.size.width - 20, 225);
    [_aView.layer setBorderWidth:1];
    [_aView.layer setBorderColor:getUIColor(Color_loginBackViewColor).CGColor];
    [self.view addSubview:_aView];
    [self settabTitle:@"意见反馈"];
    

    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 24+NavHeight - 1, [UIScreen mainScreen].bounds.size.width - 40, 20)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    
    self.wordCountLabel.text = @"0/300";
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 24+NavHeight - 1 + 23, [UIScreen mainScreen].bounds.size.width - 40, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:_wordCountLabel];
    [_aView addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加一个label(问题截图（选填）)
    [self addLabelText];
    
    //创建collectionView进行上传图片
    
    [self addCollectionViewPicture];
    
    //添加联系方式
    
    [self addContactInformation];
    //提交信息的button
    [self.view addSubview:self.sendButton];
    
    //上传图片的button
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoBtn.frame = CGRectMake(10 , 154 - 5, 65, 65);
    [_photoBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    //[_photoBtn setBackgroundColor:[UIColor redColor]];
    
    [_photoBtn addTarget:self action:@selector(picureUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.aView addSubview:_photoBtn];
}

///图片上传
-(void)picureUpload:(UIButton *)sender{


    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = selectedAssets;
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}
//上传图片的协议与代理方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
////    [self.btn setImage:image forState:UIControlStateNormal];
//    [self.photoArrayM addObject:image];
//    
//    NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
//    
//    NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
//    
//    if ([_photoDataArray length] > 0) {
//        _photoDataArray = [NSString stringWithFormat:@"%@,%@",_photoDataArray,base64];
//    } else {
//        _photoDataArray = base64;
//    }
//    //选取完图片之后关闭视图
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _photoDataArray = @"";
    _photoArrayM = [NSMutableArray arrayWithArray:photos];
    selectedAssets = [NSMutableArray arrayWithArray:assets];
    if ([photos count] > 0) {
        [self.photoBtn setHidden:YES];
    } else {
        [self.photoBtn setHidden:NO];
    }
   
    for (UIImage *imageP in photos) {
        NSData * imageData = UIImageJPEGRepresentation(imageP, 0.3);
        //
        NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
    
        if ([_photoDataArray length] > 0) {
            _photoDataArray = [NSString stringWithFormat:@"%@,%@",_photoDataArray,base64];
        } else {
            _photoDataArray = base64;
        }

    }
    
    [_collectionV reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = selectedAssets;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//button的frame

///填写意见
-(void)addLabelText{
    UILabel * labelText = [[UILabel alloc] init];
    labelText.text = @"问题截图(选填)";
    labelText.frame = CGRectMake(10, 125,[UIScreen mainScreen].bounds.size.width - 20, 20);
    labelText.font = [UIFont systemFontOfSize:14.f];
    labelText.textColor = _textView.placeholderColor;
    [_aView addSubview:labelText];


}
#pragma mark 上传图片UIcollectionView

-(void)addCollectionViewPicture{
   //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake(65 , 65 );
    flowL.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 145, self.aView.frame.size.width, (_aView.frame.size.width - 60) / 5 + 15) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor whiteColor];
   // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.aView addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

}

///添加联系方式
-(void)addContactInformation{
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_aView.frame)+5, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    _textField.backgroundColor = [UIColor whiteColor];
    [_textField.layer setBorderColor:getUIColor(Color_background).CGColor];
    [_textField.layer setBorderWidth:1];
    
    UIImageView *imageViewCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    imageViewCheck.image=[UIImage imageNamed:@"textFieldLeft"];
    _textField.leftView=imageViewCheck;
    _textField.leftViewMode=UITextFieldViewModeAlways;
    _textField.font = [UIFont systemFontOfSize:14.f];
    _textField.placeholder = @"   你的联系方式(手机号，QQ号或电子邮箱)";
    _textField.keyboardType = UIKeyboardTypeTwitter;
//    [_textView.layer setBorderColor:getUIColor(Color_loginBackViewColor).CGColor];
//    [_textView.layer setBorderWidth:1];
    [self.view addSubview:_textField];

}
-(PlaceholderTextView *)textView{

    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 100)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 4.0f;
//        _textView.layer.borderColor = kTextBorderColor.CGColor;
//        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"写下你遇到的问题，或告诉我们你的宝贵意见~";
       
            
    }
    
    return _textView;
}

//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }

    return YES;
}

- (UIButton *)sendButton{

    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 2.0f;
        _sendButton.frame = CGRectMake(10, CGRectGetMaxY(_aView.frame)+50, self.view.frame.size.width - 20, 40);
        _sendButton.backgroundColor = [UIColor blackColor];
        [_sendButton setTitle:@"提交" forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendButton addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
    }

    return _sendButton;

}

#pragma mark 提交意见反馈
- (void)sendFeedBack{
    if (self.textView.text.length == 0) {
        
        UIAlertController *alertLength = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的信息为空，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *suer = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertLength addAction:suer];
        [self presentViewController:alertLength animated:YES completion:nil];
            }
    else{
        [self isMobileNumber:self.textField.text];
        [self isValidateEmail:self.textField.text];
        //验证qq未写
        
        if (self.emailRight != 0 || self.phoneRight != 0) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:self.textView.text forKey:@"content"];
            [params setObject:self.textField.text forKey:@"contect"];
            
            if([_photoDataArray isEqualToString:@""]||_photoDataArray==nil)
            {
                _photoDataArray =@"";
            }
            
            [params setObject:_photoDataArray forKey:@"img_list"];
            
            [postData postData:URL_SuggestPost PostParams:params finish:^(BaseDomain *domain, Boolean success) {
               
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"意见反馈" message:@"亲你的意见我们已经收到，我们会尽快处理" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *album = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:album];
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
        }
        else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"通知" message:@"你输入的邮箱，QQ号或者手机号错误,请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }

    
    }
}


- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.photoV.image = self.photoArrayM[indexPath.item];
    return cell;
}

#pragma mark textField的字数限制

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
    [self wordLimit:textView];
}
#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 300) {
        NSLog(@"%ld",text.text.length);
        self.textView.editable = YES;
        
    }
    else{
        self.textView.editable = NO;
    
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

#pragma mark 判断邮箱，手机，QQ的格式
-(BOOL)isValidateEmail:(NSString *)email{

    NSString *emailRegex = @"[1-9][0-9]{4,14}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    self.emailRight = [emailTest evaluateWithObject:email];
    return self.emailRight;

}

//验证手机号码的格式

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188 198
     * 联通：130 131 132 145 155 156 166 171 175 176 185 186
     * 电信：133 149 153 173 177 180 181 189 199
     * 虚拟运营商: 170
     */
    NSString *target = @"^(0|86|17951)?(13[0-9]|15[012356789]|16[6]|19[89]]|17[01345678]|18[0-9]|14[579])[0-9]{8}$";
    NSPredicate *targetPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", target];
    if ([targetPredicate evaluateWithObject:mobileNum])
    {
        self.phoneRight = 1;
        return YES;
    }
    else
    {
        self.phoneRight = 0;
        return NO;
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
