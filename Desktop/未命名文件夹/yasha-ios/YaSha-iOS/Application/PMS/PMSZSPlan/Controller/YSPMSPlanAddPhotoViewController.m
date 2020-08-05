//
//  YSPMSPlanAddPhotoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/29.
//

#import "YSPMSPlanAddPhotoViewController.h"
#import "YSPMSPlanBigPhotoViewController.h"
#import "YSPMSPlanAddPhotoTableViewCell.h"
#import "YSPMSPlanPhotoViewCell.h"
#import "YSTextField.h"

@interface YSPMSPlanAddPhotoViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,QMUITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) QMUITextField *textNameFiled;
@property (nonatomic, strong) QMUITextField *textFiled;
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thisCompletions;
@property (nonatomic, strong) NSString *addCompletions;
@property (nonatomic, strong) NSString *proportion;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *lineNameLabel;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation YSPMSPlanAddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加照片";
    self.payload = [NSMutableDictionary dictionary];
    self.navigationController.delegate = self;
    self.addCompletions = self.model.actualComplet;
    self.proportion = self.model.completRatio;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSourceArray = [NSMutableArray array];
    [_dataSourceArray addObject:@"添加照片"];
    switch (self.planType) {
        case YSPMSPlanTypeStarts:
            self.titleArray = @[@"名称"];
            break;
        case YSPMSPlanTypeTracking:
            self.titleArray = @[@"名称",@"本次完工量(㎡)",@"累计完工量(㎡)",@"完工比例(%)"];
        default:
            break;
    }
    [self creatTableView];
    [self creatCollectionView];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
//}

- (void)creatTableView {
    
    if (self.planType == YSPMSPlanTypeStarts) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 165*kHeightScale) style:UITableViewStyleGrouped];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kHeightScale) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 120*kHeightScale)];
    view.backgroundColor = [UIColor whiteColor];
    QMUITextView *textView = [[QMUITextView alloc]initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 120*kHeightScale)];
    textView.delegate = self;
    textView.autoResizable = YES;
    textView.maximumTextLength = 200;
    textView.font = [UIFont systemFontOfSize:16];
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    if (self.remark.length > 0) {
        textView.text = self.remark;
    }else{
        textView.placeholder = @"备注";
    }
    [view addSubview:textView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    YSPMSPlanAddPhotoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSPMSPlanAddPhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    [cell.inputTextFiled addTarget:self action:@selector(inputStr:) forControlEvents:UIControlEventEditingDidEnd];
    cell.inputTextFiled.tag = indexPath.row;
    [cell setAddPhotoCellData:self.addCompletions andProportion:self.proportion andIndexPath:indexPath];
    return cell;
}
- (void)inputStr:(UITextField *)textFiled {
    if (textFiled.tag == 0) {
        self.name = textFiled.text;
    }
    if (textFiled.tag == 1) {
        self.thisCompletions = textFiled.text;
        self.addCompletions = [NSString stringWithFormat:@"%d",[self.thisCompletions intValue] + [self.addCompletions intValue]];
        if ([self.model.quantity intValue] > 0) {
            self.proportion =[NSString stringWithFormat:@"%.2lf", ([self.addCompletions floatValue]/[self.model.quantity floatValue])*100];
        }else{
            self.proportion =@"0";
        }
        
        DLog(@"=========%@------%@",self.addCompletions,self.model.quantity);
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
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



- (void)creatCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
     layout.minimumInteritemSpacing = 5;// 垂直方向的间距
     layout.minimumLineSpacing = 5; // 水平方向的间距
    layout.itemSize = CGSizeMake(110*kWidthScale, 110*kHeightScale);
    if (self.planType == YSPMSPlanTypeStarts) {
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 240*kHeightScale, kSCREEN_WIDTH-20*kHeightScale, 340*kHeightScale) collectionViewLayout:layout];
    }else{
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 310*kHeightScale, kSCREEN_WIDTH-20*kHeightScale, 340*kHeightScale) collectionViewLayout:layout];
    }
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionView registerClass:[YSPMSPlanPhotoViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSourceArray.count > 9 ? 9 : _dataSourceArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCollectionViewCell:_dataSourceArray andIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataSourceArray.count -1) {
        [self authorizationPresentAlbumViewController];
    }else{
        YSPMSPlanBigPhotoViewController *PMSPlanBigPhotoViewController = [[YSPMSPlanBigPhotoViewController alloc]init];
        DLog(@"=======%@",_dataSourceArray);
        PMSPlanBigPhotoViewController.data = _dataSourceArray ;
        PMSPlanBigPhotoViewController.index = indexPath.row;
         [self presentViewController:PMSPlanBigPhotoViewController animated:YES completion:nil];
    }
    
}

- (void)authorizationPresentAlbumViewController {
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewController];
            });
        }];
    } else {
        [self presentAlbumViewController];
    }
}

- (void)presentAlbumViewController {
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeAll;
    albumViewController.title = @"选择多张图片";
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:YES];
        
    }
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - QMUIAlbumViewControllerDelegate

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 9;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.allowsMultipleSelection = YES;
    
    return imagePickerViewController;
}

#pragma mark - QMUIImagePickerViewControllerDelegate

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:QMUIAlbumContentTypeAll userIdentify:nil];
    [self.dataSourceArray removeLastObject];
    [imagePickerViewController dismissViewControllerAnimated:YES completion:^{
        for (QMUIAsset *asset in imagesAssetArray) {
            [self.dataSourceArray addObject:asset.originImage];
        }
        [self.dataSourceArray addObject:@"添加照片"];
        DLog(@"========%@",self.dataSourceArray);
        [self.collectionView reloadData];
    }];
}

// 预览相册
- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    QMUIImagePickerPreviewViewController *imagePickerPreviewViewController = [[QMUIImagePickerPreviewViewController alloc] init];
    imagePickerViewController.maximumSelectImageCount = 9;
    return imagePickerPreviewViewController;
}

- (void)submit {
    [QMUITips showLoadingInView:self.view];
    [self.payload setValue:self.name forKey:@"progressName"];
    [self.payload setValue:self.remark forKey:@"progressRemark"];
    
    if ([self.type isEqual:@"1"]) {
        [self.payload setValue:self.taskStatus forKey:@"taskStatus"];
        [self.payload setValue:self.model.id forKey:@"id"];
    }else{
        self.type = @"2";
        [self.payload setValue:self.model.code forKey:@"planTaskCode"];
        [self.payload setValue:self.proportion forKey:@"completRatio"];
        [self.payload setValue:self.addCompletions forKey:@"grandTotalCompletion"];
        [self.payload setValue:self.thisCompletions forKey:@"thisTimeCompletion"];
        [self.payload setValue:self.status forKey:@"status"];  //1跟踪/2完工)
    }
    DLog(@"=========%@",self.dataSourceArray);
    [self.dataSourceArray removeLastObject];
    [YSNetManager ys_uploadImageWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, updatePlanTaskMQ, self.type] parameters:self.payload imageArray:[self.dataSourceArray copy] file:@"files" successBlock:^(id response) {
        DLog(@"=======%@",response);
        DLog(@"=======%@",response[@"msg"]);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"data"] isEqual: @1]) {
            if (self.refreshPlanStart) {
                self.refreshPlanStart();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.dataSourceArray addObject:@"添加照片"];
        }
    } failurBlock:^(NSError *error) {
         [QMUITips hideAllToastInView:self.view animated:YES];
        DLog(@"-------%@",error);
    } upLoadProgress:nil];
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
