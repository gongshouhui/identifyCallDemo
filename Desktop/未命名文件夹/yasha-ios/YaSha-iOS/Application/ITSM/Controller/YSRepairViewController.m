//
//  YSRepairViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRepairViewController.h"
#import "YSDingDingHeader.h"
#import "YSInternalPeopleModel.h"
#import "YSITSMViewController.h"
#import "YSClassificationViewController.h"
#import "YSRepairTableViewCell.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"

#import "YSMultipleImagePickerPreviewViewController.h"

#define MaxSelectedImageCount 9
#define NormalImagePickingTag 1045
#define ModifiedImagePickingTag 1046
#define MultipleImagePickingTag 1047
#define SingleImagePickingTag 1048

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;
@interface YSRepairViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QMUIImagePickerViewControllerDelegate, QMUIAlbumViewControllerDelegate, QMUITextViewDelegate,QMUIImagePickerViewControllerDelegate, YSMultipleImagePickerPreviewViewControllerDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIActionSheet * actionSheet;
@property (nonatomic, strong) NSString *name;    //用户名
@property (nonatomic, strong) NSString *phone;  //联系方式
@property (nonatomic, strong) NSString *address; //办公地址
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *chooseClassName;//问题分类名称
@property (nonatomic, strong) NSMutableArray *problemArray; //问题说明数组
@property (nonatomic, strong) NSString *chooseInstructions;//选择的问题说明
@property (nonatomic, strong) NSMutableArray *imgArr; //图片数组
@property (nonatomic, strong) NSString *numStr; //图片张数
@property (nonatomic, strong) NSString *categoryCode;//子节点的code
@property (nonatomic, strong) NSString *categoryName;//子节点的name
@property (nonatomic, strong) NSString *classCode;//节点的code,查询是否有问题说明
@property (nonatomic, strong) NSArray *classArray;//问题分类数组
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) ZYQAssetPickerController *picker;

@end

@implementation YSRepairViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"自助报障"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [QMUITips hideAllToastInView:self.view animated:YES]; //隐藏弹出框
    [TalkingData trackPageEnd:@"自助报障"];
}

- (void)initSubviews {
    [super initSubviews];
    self.title = @"自助报障";
    self.chooseInstructions = @"请选择";
    self.imgArr = [NSMutableArray array];
    self.problemArray = [NSMutableArray array];
    self.titleArray = @[@"故障用户",
                        @"联系方式",
                        @"办公地址",
                        @"问题分类",
                        @"问题说明",
                        @"上传附件"];
    self.view.backgroundColor = [UIColor whiteColor];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getProblemClass] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"------%@",response);
        if ([response[@"code"] isEqual:@1]) {
            self.classArray = response[@"data"][@"problemClass"];
            self.name  = response[@"data"][@"userInfo"][@"name"];
            self.phone = response[@"data"][@"userInfo"][@"mobile"];
            self.address = response[@"data"][@"userInfo"][@"workAddress"];
            self.uid = response[@"data"][@"userInfo"][@"no"];
        }
        [self.table reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"======%@",error);
    } progress:nil];
    [self creatTable];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"历史记录" position:QMUINavigationButtonPositionRight target:self action:@selector(clicked)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:KNotificationPostSelectedPerson object:nil];
}
- (void)receiveNotification:(NSNotification *)noti{
    DLog(@"--------%@",noti.object);
    NSArray *array = noti.userInfo[@"selectedArray"];
    YSContactModel *internalModel = array[0];
    self.name = internalModel.name;
    self.phone = internalModel.mobile;
    self.address = internalModel.workAddress;
    self.uid = internalModel.userId;
    [self.table reloadData];
}



- (void)clicked {
    YSITSMViewController *itsm = [[YSITSMViewController alloc]init];
    [self.navigationController pushViewController:itsm animated:YES];
}

- (void)creatTable {
    self.table = [[UITableView alloc]initWithFrame:kSCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.table];
    
    QMUIButton *submitButton = [YSUIHelper generateDarkFilledButton];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
    }];
    
}
- (void)submitEvent {
    DLog(@"=======%@",self.imgArr);
    if (self.classCode.length > 0 && self.categoryName.length > 0 && self.name.length > 0 && self.phone.length > 0 && self.chooseInstructions.length > 0 && self.address.length > 0 && self.remark.length > 0) {
        [QMUITips showLoadingInView:self.view];
        if ([self.chooseInstructions isEqual:@"请填写问题说明"]) {
            self.chooseInstructions = @"";
        }
        NSDictionary *payload = @{
                                  @"createUserid" : self.uid,
                                  @"categoryCode" : self.classCode,
                                  @"categoryName" : self.chooseClassName,
                                  @"creatorRealName" :self.name,
                                  @"creatorByMobilePhone" : self.phone,
                                  @"description" : [NSString stringWithFormat:@"%@;%@",self.chooseInstructions,self.remark],
                                  @"businessAddress" : self.address
                                  };
        DLog(@"=======%@",payload);
        [YSNetManager ys_uploadImageWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,saveFeedBack] parameters:payload imageArray:self.imgArr file:@"files" successBlock:^(id response) {
            DLog(@"======%@",response);
            [QMUITips hideAllToastInView:self.view animated:YES];
            if (response[@"data"]){
                self.address = nil;
                self.remark = nil;
                self.numStr = nil;
                self.chooseClassName = nil;
                self.chooseInstructions = @"请选择";
                [self.table reloadData];
                YSITSMViewController *itsm = [[YSITSMViewController alloc]init];
                [self.navigationController pushViewController:itsm animated:YES];
            }else{
                [QMUITips showInfo:@"提交操作失败" inView:self.view hideAfterDelay:1];
            }
        } failurBlock:^(NSError *error) {
            
            [QMUITips hideAllToastInView:self.view animated:YES];
            
        } upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        }];
    }else{
        [QMUITips showError:@"请输入完整信息" inView:self.view hideAfterDelay:1];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150*kHeightScale)];
    view.backgroundColor = [UIColor whiteColor];
    _textView = [[QMUITextView alloc]init];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.autoResizable = YES;
    _textView.delegate = self;
    if (self.remark) {
        _textView.text = self.remark;
    }else{
        _textView.placeholder = @"请在此输入问题说明...";
    }
    _textView.maximumTextLength = 200;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(view.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(375*kWidthScale, 145*kHeightScale));
    }];
    return view;
}


#pragma mark - QMUITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    //    self.chooseInstructions = textView.text;
    self.remark = textView.text;
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:1.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *inde = @"cell";
    YSRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[YSRepairTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inde];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.textFiled.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textFiled addTarget:self action:@selector(namemethods:) forControlEvents:UIControlEventEditingChanged];
    switch (indexPath.row) {
        case 0:
            [cell.textFiled removeFromSuperview];
            cell.detailTextLabel.text = self.name;
            break;
        case 1:
            cell.textFiled.text = self.phone;
            cell.textFiled.tag = indexPath.row+5;
            break;
        case 2:
            cell.textFiled.text = self.address;
            cell.textFiled.tag = indexPath.row+5;
            break;
        case 3:
            [cell.textFiled removeFromSuperview];
            if (self.chooseClassName.length > 0) {
                cell.detailTextLabel.text = self.chooseClassName;
            }else{
                cell.detailTextLabel.text = @"请选择";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 4 :
            [cell.textFiled removeFromSuperview];
            if ([self.chooseInstructions isEqual:@"请填写问题说明"]) {
                cell.detailTextLabel.text = self.chooseInstructions;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else if ([self.chooseInstructions isEqual:@"请选择"]) {
                cell.detailTextLabel.text = @"请选择";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.detailTextLabel.text = self.chooseInstructions;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 5:{
            cell.textFiled.text = self.numStr;
            cell.textFiled.textAlignment = NSTextAlignmentCenter;
            cell.textFiled.userInteractionEnabled = NO;
            cell.textFiled.textColor = [UIColor whiteColor];
            [cell.textFiled mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.contentView.mas_right);
                make.top.mas_equalTo(cell.contentView.mas_top).offset(12);
                make.size.mas_equalTo(CGSizeMake(20*kWidthScale, 20*kHeightScale));
            }];
            if (self.numStr != nil) {
                cell.textFiled.backgroundColor = kUIColor(0, 203, 210, 1.0);
            }else{
                cell.textFiled.backgroundColor = [UIColor whiteColor];
            }
            cell.textFiled.layer.masksToBounds = YES;
            cell.textFiled.layer.cornerRadius = 10*kWidthScale;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.jumpSourceStr = @"ITSM";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    }
    if (indexPath.row == 3) {
        if (self.classArray.count>0) {
            YSClassificationViewController *classification = [[YSClassificationViewController alloc]init];
            [classification initPoints:self.classArray];
            classification.block = ^(NSString *classStr, NSString *linkCode, NSString *classCode ,NSString *str) {
                self.classCode = classCode;
                self.chooseClassName = classStr;
                self.categoryCode = linkCode;
                self.categoryName = str;
                self.chooseInstructions = @"请选择";
                [self.table reloadData];
            };
            [self.navigationController pushViewController:classification animated:YES];
        }else{
            [QMUITips showInfo:@"暂无问题分类数据" inView:self.view hideAfterDelay:1];
        }
        
    }
    if (indexPath.row == 4) {
        [self.problemArray removeAllObjects];
        if (self.categoryCode.length > 0) {
            NSDictionary *payload = @{@"classCode" : self.categoryCode };
            
            [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getProblemDesc]  isNeedCache:NO parameters:payload successBlock:^(id response) {
                DLog(@"++++++++%@",response);
                for (NSDictionary *dic in response[@"data"]) {
                    [self.problemArray addObject:dic[@"typename"]];
                }
                if (self.problemArray.count > 0) {
                    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
                    dialogViewController.title = @"问题说明";
                    dialogViewController.items = self.problemArray;
                    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
                    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
                        QMUIDialogSelectionViewController *dialogSelectionViewController = (QMUIDialogSelectionViewController *)aDialogViewController;
                        if (dialogSelectionViewController.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
                            [QMUITips showError:@"请至少选一个" inView:self.view hideAfterDelay:1];
                            return;
                        }
                        NSString *resultString = dialogSelectionViewController.items[dialogSelectionViewController.selectedItemIndex];
                        self.chooseInstructions  = resultString;
                        [_textView removeFromSuperview];
                        [self.table reloadData];
                        [aDialogViewController hideWithAnimated:YES completion:^(BOOL finished) {
                        }];
                    }];
                    [dialogViewController show];
                }else{
                    DLog(@"没有数据，请填写");
                    self.chooseInstructions = @"请在下方填写问题说明";
                    [self.table reloadData];
                }
            } failureBlock:^(NSError *error) {
                
            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        }else{
            DLog(@"请选择问题分类");
            [QMUITips showInfo:@"请先选择问题分类" inView:self.view hideAfterDelay:1];
        }
    }
    if (indexPath.row == 5) {
        [self authorizationPresentAlbumViewControllerWithTitle:@"选择多张图片"];
    }
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
    self.numStr = [NSString stringWithFormat:@"%zd", self.imgArr.count];
    [self.table reloadData];
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
    self.numStr = [NSString stringWithFormat:@"%zd", self.imgArr.count];
    [self.table reloadData];
    
}

- (void)namemethods:(UITextField *)tf {
    if (tf.tag == 6) {
        self.phone = tf.text;
    }else if(tf.tag == 7){
        self.address = tf.text;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

