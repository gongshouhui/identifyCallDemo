//
//  YSProvePhotoRemoveViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2020/2/11.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSProvePhotoRemoveViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/Photos.h>

@interface YSProvePhotoRemoveViewController ()

@end

@implementation YSProvePhotoRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复工证明";
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"保存" position:QMUINavigationButtonPositionRight target:self action:@selector(judgePhotoPermissions)];
}

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 700))];
    self.tableView.tableHeaderView = headerView;
    UIImageView *logImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yslogo"]];
    [headerView addSubview:logImg];
    [logImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50*kHeightScale);
        make.left.mas_equalTo(25*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 12*kHeightScale));
    }];
    
    UILabel *lineLab = [UILabel new];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#FF000000"];
    [headerView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImg.mas_left);
        make.right.mas_equalTo(-25*kWidthScale);
        make.height.mas_equalTo(kHeightScale);
        make.top.mas_equalTo(logImg.mas_bottom).offset(5.5);
    }];
    
    //标题
    UILabel *titleLabe = [UILabel new];
    titleLabe.text = @"工 作 证 明";
    titleLabe.textColor = [UIColor colorWithHexString:@"#FF000000"];
    titleLabe.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(20)];
    [headerView addSubview:titleLabe];
    [titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0); make.top.mas_equalTo(lineLab.mas_bottom).offset(50*kHeightScale);
    }];
    
    //内容
    UILabel *contentLab = [UILabel new];
    contentLab.numberOfLines = 0;
    contentLab.attributedText = [self addLineForString];
    [headerView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*kWidthScale);
        make.right.mas_equalTo(-25*kWidthScale);
        make.top.mas_equalTo(titleLabe.mas_bottom).offset(40*kHeightScale);
    }];
    NSString *companyName = @"浙江亚厦装饰股份有限公司杭州分公司";
    NSString *companyImgName = @"yaShaZHSH";
    if ([[self.paramDic objectForKey:@"company"] isEqualToString:@"亚厦幕墙"]) {
        companyName = @"浙江亚厦幕墙有限公司杭州分公司";
        companyImgName = @"yaShaMQ";
    }else if ([[self.paramDic objectForKey:@"company"] isEqualToString:@"蘑菇加"]) {
        companyName = @"浙江亚厦蘑菇加装饰设计工程有限公司";
        companyImgName = @"yaShaMGJ";
    }
    // 落款
    UILabel *companyLab = [UILabel new];
    companyLab.text = companyName;
    companyLab.textColor = [UIColor colorWithHexString:@"#FF000000"];
    companyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [headerView addSubview:companyLab];
    [companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25*kWidthScale);
        make.top.mas_equalTo(contentLab.mas_bottom).offset(103*kHeightScale);
    }];

    // 时间
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年M月d日"];
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
    
    UILabel *timeLab = [UILabel new];
    timeLab.text = nowDateString;
    timeLab.textColor = [UIColor colorWithHexString:@"#FF000000"];
    timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [headerView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(companyLab.mas_right);
        make.top.mas_equalTo(companyLab.mas_bottom).offset(12*kHeightScale);
    }];
    //章
    UIImageView *companyImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:companyImgName]];
    [headerView addSubview:companyImg];
    [companyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 150*kWidthScale));
        make.right.mas_equalTo(companyLab.mas_right).offset(-10);
        make.bottom.mas_equalTo(timeLab.mas_bottom);
    }];
    
    //
    UILabel *bottomLab = [UILabel new];
    bottomLab.text = @" ";
    [headerView addSubview:bottomLab];
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(companyImg.mas_bottom);
        make.centerX.mas_equalTo(0);
    }];
}
- (NSAttributedString*)addLineForString {
    
    //记录校验结果：0未知，1男，2女
    NSString *fontNumer = @"男";
    NSString *iDNumber = [self.paramDic objectForKey:@"idCard"];
    if (iDNumber.length == 15){ // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [iDNumber substringWithRange:NSMakeRange(14, 1)];
    }else if (iDNumber.length == 18){ // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [iDNumber substringWithRange:NSMakeRange(16, 1)];
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1){
        fontNumer = @"男";
    }else if (genderNumber % 2 == 0){
        fontNumer = @"女";
    }
    
    NSString *changeStr = [NSString stringWithFormat:@"兹有我单位员工 %@ ，性别 %@ ，\n身份证号 %@ ，\n目前我单位已通过杭州市政府企业复工申请。因工作需要，需往返工作单位和居住地。\n本人身体健康且未与疫区人员接触，能够保证在上班期间做好个人防护工作。\n本单位承诺该同志在我司工作期间，我司负责排查防控。", [self.paramDic objectForKey:@"name"], fontNumer, [self.paramDic objectForKey:@"idCard"]];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:changeStr];
    NSRange nameRange = NSMakeRange([[contentStr string] rangeOfString:[NSString stringWithFormat:@" %@ ", [self.paramDic objectForKey:@"name"]]].location, [[contentStr string] rangeOfString:[self.paramDic objectForKey:@"name"]].length+2);
    NSRange uidRange = NSMakeRange([[contentStr string] rangeOfString:[NSString stringWithFormat:@" %@ ", fontNumer]].location, [[contentStr string] rangeOfString:fontNumer].length+2);
    
    NSRange idCardRange = NSMakeRange([[contentStr string] rangeOfString:[NSString stringWithFormat:@" %@ ", [self.paramDic objectForKey:@"idCard"]]].location, [[contentStr string] rangeOfString:[self.paramDic objectForKey:@"idCard"]].length+2);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF000000"] range:NSMakeRange(0, changeStr.length)];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)] range:NSMakeRange(0, changeStr.length)];
    
    [contentStr addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)} range:nameRange];
    [contentStr addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)} range:uidRange];
    [contentStr addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)} range:idCardRange];
    
    //首行缩进 行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20;
    paragraphStyle.headIndent = 0.0f;
    paragraphStyle.firstLineHeadIndent = Multiply(14)*2;
    NSRange range = NSMakeRange(0, [contentStr length]);
    [contentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return contentStr;
    
}

#pragma mark--保存照片到本地
- (void)judgePhotoPermissions {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == QMUIAssetAuthorizationStatusAuthorized) {
                    [self savePhoto];
                }else {
                    [QMUITips showInfo:@"请您设置允许该应用访问您的相册\n设置>隐私>相机" inView:self.view hideAfterDelay:2];
                }
            });
        }];
    } else if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotAuthorized){
        [QMUITips showInfo:@"请您设置允许该应用访问您的相册\n设置>隐私>相机" inView:self.view hideAfterDelay:2];
    }else {
        [self savePhoto];
    }
}
- (void)savePhoto {
    
    UIImage *viewImage = nil;
    UIScrollView *scrollView = self.tableView;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height), NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    /*
     //要生成为图片的view
     UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, 0, [[UIScreen mainScreen] scale]);
     
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     */
    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    
    
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        
        NSLog(@"成功");
        [QMUITips showSucceed:@"保存成功,请去相册查看" inView:self.view hideAfterDelay:2];
    }else {
        
        NSLog(@"失败 - %@",error);
        [QMUITips showSucceed:@"保存失败" inView:self.view hideAfterDelay:2];

        
    }
    
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
