//
//  YSComplaintViewController.m
//  YaSha-iOS
//
//  Created by mHome on 2017/4/21.
//
//

#import "YSComplaintViewController.h"
#import <IQKeyboardManager.h>
#import "ActionSheetPicker.h"
#import "YSComplaintTableViewCell.h"
#import "YSAttendanceViewController.h"
#import "HisDatePicer.h"
#import "YSMultipleImagePickerPreviewViewController.h"
#import "YSAttendanceNewPageController.h"

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@interface YSComplaintViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate,HisPickerViewDelegate,UINavigationControllerDelegate,QMUITextViewDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate, YSMultipleImagePickerPreviewViewControllerDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) NSString *businessStr;
@property (nonatomic, strong) NSString *levelStr;
@property (nonatomic, strong) NSString *businessCode;
@property (nonatomic, strong) NSString *levelCode;
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, assign) BOOL isChoose;//是否营销人员
@property (nonatomic, assign) BOOL isRegionalCompany;//是否为区域公司
@property (nonatomic, strong) UITextField *textfield ;
@property (nonatomic, strong) NSMutableArray *positionlevelArray;
@property (nonatomic, strong) NSMutableArray *positionlevelCodeArray;
@property (nonatomic, strong) NSMutableArray *businessArray;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *outCompanyStr;
@property (nonatomic, strong) NSString *visitTelephoneStr;
@property (nonatomic, strong) NSString *imgId;

@end

@implementation YSComplaintViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.positionlevelArray = [NSMutableArray array];
    self.positionlevelCodeArray = [NSMutableArray array];
    self.businessArray = [NSMutableArray array];
    self.imgArr = [NSMutableArray array];
    [self switchViewEvent];
    //[self getMapData];
    [self creatTable];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [QMUITips hideAllToastInView:self.view animated:YES];
    
}


//获取职位名称的Map
//- (void)getMapData{
//
//    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%d",YSDomain,getDicInfo,1] isNeedCache:NO parameters:nil successBlock:^(id response) {
//        DLog(@"========%@",response);
//        for (NSDictionary *dic in response[@"data"]) {
//            [self.positionlevelArray addObject:dic[@"text"]];
//            [self.positionlevelCodeArray addObject:dic[@"code"]];
//        }
//    } failureBlock:^(NSError *error) {
//
//    } progress:nil];
//}
- (void)switchViewEvent {
    if (self.pageIndex == 0) {
        self.nameArray = @[@"考勤机记录",@"证明材料"];
        [self.table reloadData];
    }else if (self.pageIndex == 1){
        self.isChoose = YES;
        self.nameArray = @[@"考勤机记录",@"是否营销人员",@"外出开始时间",@"外出结束时间",@"外出地点",@"外出单位",@"拜访人员及电话",@"证明材料"];
        [self.table reloadData];
    }else{
        self.nameArray = @[@"考勤机记录",@"证明材料"];
        [self.table reloadData];
    }
}

//创建Tanleview显示视图
- (void)creatTable {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

#pragma UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 230*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45*kHeightScale;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRects(0, 0, 375, 100)];
    view.backgroundColor = [UIColor whiteColor];
    QMUITextView *textView = [[QMUITextView alloc]initWithFrame:CGRects(0, 5, 375, 145)];
    textView.delegate = self;
    textView.autoResizable = YES;
    textView.maximumTextLength = 35;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    if (self.remark.length > 0) {
        textView.text = self.remark;
    }else{
        textView.placeholder = @"请输入事由说明。。。";
    }
    textView.font = [UIFont systemFontOfSize:16];
    [view addSubview:textView];

    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRects(15, 170, 345, 40);
    submitButton.backgroundColor = kThemeColor;
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.cornerRadius = 5;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitEvent) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *inde = @"cell";
//    YSComplaintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
//    if (cell == nil) {
//        cell = [[YSComplaintTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inde];
//    }
    YSComplaintTableViewCell *cell = [[YSComplaintTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.titleLabel.text = self.nameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.pageIndex == 0 || self.pageIndex == 2) {
        [cell.textfield removeFromSuperview];
        switch (indexPath.row) {
            case 0:{
                if ([self.type isEqual:@"140"]) {
                    cell.conterLabel.text = [NSString stringWithFormat:@"%@ 上班打卡异常！",[self.model.sdate substringToIndex:10]];
                    }
                if ([self.type isEqual:@"150"]) {
                     cell.conterLabel.text = [NSString stringWithFormat:@"%@ 下班打卡异常！",[self.model.sdate substringToIndex:10]];
                    }
                if ([self.type isEqual:@"70"]) {
                    cell.conterLabel.text = [NSString stringWithFormat:@"%@ 迟到！",[self.model.sdate substringToIndex:10]];
                    }
                [cell.img removeFromSuperview];
                [cell.switchView removeFromSuperview];
                break;
            }
            case 1:{
                [cell.switchView removeFromSuperview];
                cell.conterLabel.text = _numStr;
                cell.conterLabel.textAlignment = NSTextAlignmentCenter;
                cell.conterLabel.textColor = [UIColor whiteColor];
                cell.conterLabel.frame = CGRects(330, 12, 20, 20);
                if (_numStr.length>0) {
                    cell.conterLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:203.0/255.0 blue:210.0/255.0 alpha:1.0];
                }
                cell.conterLabel.layer.masksToBounds = YES;
                cell.conterLabel.layer.cornerRadius = 10*BIZ;
                break;
            }
            default:
                break;
        }
    }
    
    if (self.pageIndex == 1) {
        [cell.textfield addTarget:self action:@selector(namemethods:) forControlEvents:UIControlEventEditingChanged];
        cell.textfield.tag = indexPath.row;
        switch (indexPath.row) {
            case 0:{
                [cell.switchView removeFromSuperview];
                [cell.textfield removeFromSuperview];
                if ([self.type isEqual:@"140"]) {
                    cell.conterLabel.text = [NSString stringWithFormat:@"%@ 上班打卡异常",[self.model.sdate substringToIndex:10]];
                }
                if ([self.type isEqual:@"150"]) {
                    cell.conterLabel.text = [NSString stringWithFormat:@"%@ 下班打卡异常",[self.model.sdate substringToIndex:10]];
                }
                if ([self.type isEqual:@"70"]) {
                    cell.conterLabel.text = [NSString stringWithFormat:@"%@ 迟到",[self.model.sdate substringToIndex:10]];
                }
                [cell.img removeFromSuperview];
                break;
            }
           
            case 1:{
                [cell.img removeFromSuperview];
                [cell.textfield removeFromSuperview];
                [cell.conterLabel removeFromSuperview];
               
                cell.switchView.on = self.isChoose;
               
                cell.switchView.tag = 120;
                [cell.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                break;
            }
            case 2:{
                [cell.switchView removeFromSuperview];
                [cell.textfield removeFromSuperview];
                cell.conterLabel.text = self.startTime;
                break;
            }
            case 3:{
                [cell.switchView removeFromSuperview];
                [cell.textfield removeFromSuperview];
                cell.conterLabel.text = self.endTime;
                break;
            }
            case 4:{
                [cell.switchView removeFromSuperview];
                [cell.img removeFromSuperview];
                if (self.addressStr) {
                    cell.textfield.text = self.addressStr;
                }
                break;
            }
            case 5:{
                if (self.isChoose) {
                    [cell.switchView removeFromSuperview];
                    [cell.img removeFromSuperview];
                    if (self.outCompanyStr) {
                        cell.textfield.text = self.outCompanyStr;
                    }
                    
                }else{
                    cell.conterLabel.text = _numStr;
                    [cell.textfield removeFromSuperview];
                    [cell.switchView removeFromSuperview];
                    cell.conterLabel.textAlignment = NSTextAlignmentCenter;
                    cell.conterLabel.textColor = [UIColor whiteColor];
                    cell.conterLabel.frame = CGRects(320, 12, 20, 20);
                    if (_numStr.length>0) {
                        cell.conterLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:203.0/255.0 blue:210.0/255.0 alpha:1.0];
                    }
                    cell.conterLabel.layer.masksToBounds = YES;
                    cell.conterLabel.layer.cornerRadius = 10;
                    
                }
                break;
            }
            case 6:{
                [cell.switchView removeFromSuperview];
                [cell.img removeFromSuperview];
                if (self.addressStr) {
                    cell.textfield.text = self.visitTelephoneStr;
                }
                
                break;
            }
            case 7:{
                cell.conterLabel.text = _numStr;
                [cell.switchView removeFromSuperview];
                [cell.textfield removeFromSuperview];
                cell.conterLabel.textAlignment = NSTextAlignmentCenter;
                cell.conterLabel.textColor = [UIColor whiteColor];
                cell.conterLabel.frame = CGRects(330, 12, 20, 20);
                if (_numStr.length>0) {
                    cell.conterLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:203.0/255.0 blue:210.0/255.0 alpha:1.0];
                }
                cell.conterLabel.layer.masksToBounds = YES;
                cell.conterLabel.layer.cornerRadius = 10;
                break;
            }
            default:
                break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1 && self.pageIndex != 1) {
        DLog(@"你点击了上传材料按钮");
        [self authorizationPresentAlbumViewControllerWithTitle:@"选择多张图片"];
    }
    if (indexPath.row == 2 || indexPath.row == 3) {
        {
            HisDatePicer *pickerview =[[HisDatePicer alloc] init];
            pickerview.backgroundColor = [UIColor whiteColor];
            pickerview.timeLabel.text = [self.model.sdate substringToIndex:10];
            pickerview.delegate=self;
            pickerview.tag = indexPath.row;
            [self.view addSubview:pickerview];
            [pickerview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.view.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 300*kHeightScale));
            }];
        }
    }
    if (indexPath.row == 7 && self.pageIndex == 1 && self.isChoose) {
        DLog(@"你点击了上传材料按钮");
        [self authorizationPresentAlbumViewControllerWithTitle:@"选择多张图片"];
    }
    if (indexPath.row == 5 && self.pageIndex == 1 && !self.isChoose) {
        DLog(@"你点击了上传材料按钮");
        [self authorizationPresentAlbumViewControllerWithTitle:@"选择多张图片"];
    }
}

#pragma mark - QMUITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    //    self.chooseInstructions = textView.text;
    self.remark = textView.text;
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:1.0];
}

#pragma mark - 提交数据
- (void)submitEvent {
    [self doNetworking];
    
}

#pragma mark - textFiled文本监听

-(void) namemethods:(UITextField *) tf{
    if (tf.tag == 4) {
        self.addressStr = tf.text;
    }
    if (tf.tag == 5) {
        self.outCompanyStr = tf.text;
    }
    if (tf.tag == 6) {
        self.visitTelephoneStr = tf.text;
    }
}

- (void)switchAction :(UISwitch *) sitch{
    
    if (self.pageIndex == 1) {
            if(sitch.on){
                self.nameArray = @[@"考勤机记录",@"是否营销人员",@"外出开始时间",@"外出结束时间",@"外出地点",@"外出单位",@"拜访人员及电话",@"证明材料"];
                self.isChoose = YES;
                [self.table reloadData];
            
            }else{
                self.nameArray = @[@"考勤机记录",@"是否营销人员",@"外出开始时间",@"外出结束时间",@"外出地点",@"证明材料"];
                self.isChoose = NO;
                [self.table reloadData];
            }
    }
    
}
#pragma mark --HisDatePicer代理方法
- (void)hisPickerView:(HisDatePicer *)alertView {
    if (alertView.tag == 3) {
        if (alertView.Taketime.length > 0) {
            self.endTime =[NSString stringWithFormat:@"%@ %@",[self.model.sdate substringToIndex:10] ,alertView.Taketime];
        }
    }else if(alertView.tag == 2){
        if (alertView.Taketime.length > 0) {
            self.startTime =[NSString stringWithFormat:@"%@ %@",[self.model.sdate substringToIndex:10],alertView.Taketime];
        }
    }
    [alertView removeFromSuperview];
    [self.table reloadData];
    
}

- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
    if ([title isEqualToString:@"选择单张图片"]) {
        albumViewController.view.tag = SingleImagePickingTag;
    } else if ([title isEqualToString:@"选择多张图片"]) {
        albumViewController.view.tag = MultipleImagePickingTag;
    } else if ([title isEqualToString:@"调整界面"]) {
        albumViewController.view.tag = ModifiedImagePickingTag;
        albumViewController.albumTableViewCellHeight = 70;
    } else {
        albumViewController.view.tag = NormalImagePickingTag;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    [[YSUtility getCurrentViewController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - QMUIAlbumViewControllerDelegate

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = MaxSelectedImageCount;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    if (albumViewController.view.tag == SingleImagePickingTag) {
        imagePickerViewController.allowsMultipleSelection = NO;
    }
    if (albumViewController.view.tag == ModifiedImagePickingTag) {
        imagePickerViewController.minimumImageWidth = 65;
    }
    return imagePickerViewController;
}
#pragma mark - QMUIImagePickerViewControllerDelegate

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (QMUIAsset *imageAsset in imagesAssetArray) {
        [mutableArray addObject:imageAsset.originImage];
    }
    self.imgArr  = [mutableArray copy];
    [self updatePicturesArr:self.imgArr];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    if (imagePickerViewController.view.tag == MultipleImagePickingTag) {
        YSMultipleImagePickerPreviewViewController *imagePickerPreviewViewController = [[YSMultipleImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.maximumSelectImageCount = MaxSelectedImageCount;
        imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    } else if (imagePickerViewController.view.tag == ModifiedImagePickingTag) {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        imagePickerPreviewViewController.toolBarBackgroundColor = UIColorMake(66, 66, 66);
        return imagePickerPreviewViewController;
    } else {
        QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
        imagePickerPreviewViewController.delegate = self;
        imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
        return imagePickerPreviewViewController;
    }
}

#pragma mark - QMUIImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    DLog(@"2");
}



#pragma mark - YSMultipleImagePickerPreviewViewControllerDelegate

- (void)imagePickerPreviewViewController:(YSMultipleImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (QMUIAsset *imageAsset in imagesAssetArray) {
        [mutableArray addObject:imageAsset.originImage];
    }
    self.imgArr  = [mutableArray copy];
   [self updatePicturesArr:self.imgArr];
    
}

-(void)updatePicturesArr:(NSArray *)picArr {
    
    self.numStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.imgArr.count];
    [self.table reloadData];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",YSDomain, upImage];
    [YSNetManager ys_uploadImageWithUrlString:urlString parameters:nil imageArray:self.imgArr file:@"files" successBlock:^(id response) {
        
        self.imgId = response[@"data"];
    
    } failurBlock:^(NSError *error) {
        
    } upLoadProgress:nil];
}

-(void) doNetworking{
    
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:100];
    [dic setValue:[self.model.sdate substringToIndex:10] forKey:@"sdate"];
    [dic setValue:self.imgId forKey:@"attachments"];
    [dic setValue:_levelCode forKey:@"orgLevelId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"appealType"]; // 0忘记打卡 1因公外出2 其他
    [dic setValue:self.remark forKey:@"remark"];
    [dic setValue:self.type forKey:@"type"];    //140上午未打卡   150 下午未打卡
    [dic setValue:[YSUtility getUID] forKey:@"no"];
    if (self.pageIndex == 1) {
        if (self.isChoose) {              //0：不是    1：是 营销人员
            [dic setValue:@0 forKey:@"slesman"];
            [dic setValue:self.outCompanyStr forKey:@"outCompany"];
            [dic setValue:self.visitTelephoneStr forKey:@"visitTelephone"];
        }else{
            [dic setValue:@1 forKey:@"slesman"];
            [dic setValue:@"null:null" forKey:@"visitTelephone"];
        }
        [dic setValue:self.addressStr forKey:@"outAddress"];
        [dic setValue:[self.startTime substringToIndex:10] forKey:@"outStartTimeStr"];
        [dic setValue:[self.endTime substringToIndex:10] forKey:@"outEndTimeStr"];
        [dic setValue:[self.startTime substringFromIndex:10] forKey:@"outStartHourMin"];
        [dic setValue:[self.endTime substringFromIndex:10] forKey:@"outEndHourMin"];
    }
    DLog(@"======%@",dic);
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,addFlowData] isNeedCache:NO parameters:dic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] integerValue] == 1) {
            for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                if ([viewController isKindOfClass:[YSAttendanceNewPageController class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"complaintNotice" object:nil];
                    [self.navigationController popToViewController:viewController animated:YES];
                }
            }
        }
    } failureBlock:^(NSError *error) {
        DLog(@"%@",error.localizedDescription);
    } progress:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
