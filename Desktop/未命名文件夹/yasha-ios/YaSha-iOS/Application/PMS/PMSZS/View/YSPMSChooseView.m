//
//  YSPMSChooseView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import "YSPMSChooseView.h"
#import <YBPopupMenu.h>
#import "YSPMSChooseHeaderView.h"
#import "YSPMSOrdinaryCell.h"
#import "YSPMSClickCell.h"
#import "YSPMSInputCell.h"
#import <CoreLocation/CoreLocation.h>
#import "YSSingleton.h"


@interface YSPMSChooseView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YBPopupMenuDelegate,UITextViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>{
//    CGPoint pointMake;
//    NSArray *titleAry;
//    NSArray *DateArray;
    NSMutableArray *addressArray;
    NSMutableArray *addressCodeArray;

    
    CLLocationManager * locationManager;
    NSString * currentCity; //当前城市
    NSArray *formalizeArray;//合同形式
    NSString *formalizeType;
    NSString *formalizeStr;//选择的合同形式
    NSArray *stateArrary;//项目状态
    NSString *stateType;
    NSString *stateStr;//选择的项目状态
    
    NSString *code;//地址编码
    
    NSString *textFiledStr;
    
}
@property (nonatomic, assign) CGPoint pointMake;
@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, strong) NSArray *selectDataArray;

//数据字典
@property (nonatomic, strong)NSDictionary *areaDic;
//省级数组
@property (nonatomic, strong)NSArray *provinceArr;
@property (nonatomic, strong)NSString *provinceStr;
//城市数组
@property (nonatomic, strong)NSArray *cityArr;
@property (nonatomic, strong)NSString *cityStr;
//区、县数组
@property (nonatomic, strong)NSArray *districtArr;
@property (nonatomic, strong)NSString *districtStr;

@property (nonatomic, strong)NSString *dateStr;//选择的时间

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)UICollectionView *collection;

@end

@implementation YSPMSChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        addressArray = [NSMutableArray arrayWithCapacity:100];
        addressCodeArray = [NSMutableArray arrayWithCapacity:100];
        formalizeArray = @[@"gddjht",@"gdzjht"];
        stateArrary = @[@"5",@"10",@"20",@"30",@"40",@"55",@"60"];
         self.titleAry = @[@[@"固定单价",@"固定总价"],@[@"年份"],@[@"未开工",@"在建",@"停工",@"退场",@"完工",@"送审",@"审定"],@[@"请输入所属部门"],@[@"省",@"市",@"区/县"]];
        [self addCollectionView];
//        [self locate];
    }
    return self;
}

- (void)locate {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];//iOS8需要加上，不然定位失败
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;  //最精确模式
        locationManager.distanceFilter = 100.0f; //至少10米才请求一次数据
        [locationManager startUpdatingLocation]; //开始定位
    }
}

#pragma mark CoreLocation delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;//市
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            DLog(@"%@",placeMark.administrativeArea);//省
            DLog(@"%@",placeMark.locality); //市
            DLog(@"%@",placeMark.subLocality);//区
            [self.collection reloadData];
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
    
}

- (void)addCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.minimumLineSpacing = 10;
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30*kHeightScale, self.frame.size.width, 667*kHeightScale) collectionViewLayout:self.flowLayout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor whiteColor];
    //注册cell标识
    [self.collection registerClass:[YSPMSClickCell class] forCellWithReuseIdentifier:@"ClickCell"];
    [self.collection registerClass:[YSPMSOrdinaryCell class] forCellWithReuseIdentifier:@"OrdinaryCell"];
    [self.collection registerClass:[YSPMSInputCell class] forCellWithReuseIdentifier:@"InputCell"];
    //注册头标识
    [self.collection registerClass:[YSPMSChooseHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    //注册尾标识
    [self.collection registerClass:[UIView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    [self addSubview:self.collection];
    
    UIButton *resetButton = [[UIButton alloc]init];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    resetButton.tag = 100;
    resetButton.backgroundColor = kUIColor(247, 247, 247, 1.0);
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collection.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2, 40*kHeightScale));
    }];
    
    UIButton *determineButton = [[UIButton alloc]init];
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    determineButton.tag = 200;
    determineButton.backgroundColor = kUIColor(42, 139, 220, 1.0);
    [determineButton addTarget:self action:@selector(confirmEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:determineButton];
    [determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(resetButton.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2, 40*kHeightScale));
    }];
}

#pragma mark --UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.titleAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titleAry[section] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 30*kHeightScale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return CGSizeMake(self.frame.size.width-30*kWidthScale, 30*kHeightScale);
    }else {
        return CGSizeMake(self.frame.size.width/3-15*kWidthScale, 30*kHeightScale);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        YSPMSChooseHeaderView *headerView = [YSPMSChooseHeaderView new];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 30*kHeightScale);
        [headerView setFilterTitle:@[@"合同形式",@"所属年份",@"项目状态",@"所属部门",@"工程地址"][indexPath.section] andIndex:indexPath.section];
        [reusableView addSubview:headerView];
        return reusableView;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

//设置单元格的数据
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        YSPMSInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InputCell" forIndexPath:indexPath];
        cell.textfile.text = nil;
        cell.textfile.delegate = self;
        [cell.textfile addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        return cell;
    }else if (indexPath.section == 0 || indexPath.section == 2){
        YSPMSOrdinaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrdinaryCell" forIndexPath:indexPath];
        cell.titleLabel.backgroundColor = kUIColor(240, 240, 240, 1.0);

        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = kUIColor(240, 240, 240, 1.0).CGColor;
        [cell setFilterIndexPath:indexPath andFilter:YES andTitleAry:self.titleAry];
        return cell;
    }else{
        YSPMSClickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClickCell" forIndexPath:indexPath];
        [cell.chooseBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.chooseBtn.tag = indexPath.section*10 + indexPath.row;
        cell.textLabel.tag = indexPath.section*10 + indexPath.row+100;
        [cell setFilterIndexPath:indexPath andFilter:YES andTitleAry:self.titleAry];
        if (indexPath.section == 1) {
            self.dateStr = cell.textLabel.text;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //获得组标示
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.collection reloadSections:indexSet];
    YSPMSOrdinaryCell *cell = (YSPMSOrdinaryCell *)[self.collection cellForItemAtIndexPath:indexPath];
    DLog(@"=========%@--------%@",cell.titleLabel.text,stateStr);
    if (indexPath.section == 0  ) {
        if (![cell.titleLabel.text isEqual:formalizeStr]) {
            formalizeStr = self.titleAry[indexPath.section][indexPath.row];
            formalizeType = formalizeArray[indexPath.row];
            [cell.titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"筛选"]]];
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = kUIColor(248, 233, 233, 1.0).CGColor;
        }else{
            formalizeStr = nil;
        }
    }
    if (indexPath.section == 2  ) {
        if (![cell.titleLabel.text isEqual:stateStr]) {
            stateStr = self.titleAry[indexPath.section][indexPath.row];
            stateType = stateArrary[indexPath.row];
            [cell.titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"筛选"]]];
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = kUIColor(248, 233, 233, 1.0).CGColor;
        }else{
            stateStr = nil;
        }
    }
}

- (void)clickEvent:(UIButton *)btn{
    if (btn.tag == 10) {
        self.selectDataArray = @[@"2017",@"2016",@"2015",@"2014"];
        self.pointMake = CGPointMake(164*kWidthScale, 150*kHeightScale);
        [self showMenu:btn.tag];
    }
    if (btn.tag == 40) {
        [self doNetworking:nil andIndex:btn.tag];
        self.pointMake = CGPointMake(164*kWidthScale, 435*kHeightScale);
    }
    if (btn.tag == 41) {
        if (self.provinceStr.length > 0) {
            self.pointMake = CGPointMake(248*kWidthScale, 435*kHeightScale);
            [self doNetworking:@{@"pcode":self.provinceStr} andIndex:btn.tag];
        }else{
            [QMUITips showError:@"请选择省" detailText:nil inView:self hideAfterDelay:2];
        }
    }
    if (btn.tag == 42) {
        if (self.cityStr.length > 0) {
             [self doNetworking:@{@"pcode":self.cityStr} andIndex:btn.tag];
            self.pointMake = CGPointMake(330*kWidthScale, 435*kHeightScale);
        }else{
            [QMUITips showError:@"请选择省或市" detailText:nil inView:self hideAfterDelay:2];
        }
    }
}

- (void)showMenu :(NSInteger) num{
        [YBPopupMenu showAtPoint:self.pointMake titles:self.selectDataArray icons:nil menuWidth:70*kWidthScale otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.dismissOnSelected = YES;
            popupMenu.isShowShadow = YES;
            popupMenu.tag = num;
            popupMenu.delegate = self;
            popupMenu.offset = 10;
            popupMenu.maxVisibleCount = 4;
            popupMenu.fontSize = 11;
            popupMenu.itemHeight = 44*kHeightScale;
            popupMenu.arrowWidth = 0;//箭头
            popupMenu.type = YBPopupMenuTypeDefault;
            popupMenu.rectCorner = UIRectCornerBottomRight|UIRectCornerBottomLeft;
        }];
}

#pragma mark -- YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    DLog(@"======%ld",ybPopupMenu.tag/2);
    UILabel *textStrLabel = (UILabel *)[self viewWithTag:ybPopupMenu.tag+100];
    if (ybPopupMenu.tag == 40) {
        self.provinceStr = addressCodeArray[index];
    }else if(ybPopupMenu.tag == 41){
        self.cityStr = addressCodeArray[index];
    }else if(ybPopupMenu.tag == 42){
        self.districtStr = addressCodeArray[index];
    }else if (ybPopupMenu.tag == 10){
        self.dateStr = self.selectDataArray[index];
    }
    textStrLabel.text = self.selectDataArray[index];
}

- (void)resetEvent {
    self.provinceArr = nil;
    self.cityArr = nil;
    self.districtStr = nil;
    stateStr = nil;
    formalizeStr = nil;
    textFiledStr = nil;
    [self.collection reloadData];
}

- (void)textFieldDidChange:(UITextField *)textField {
    textFiledStr = textField.text;
}

- (void)confirmEvent {
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionaryWithCapacity:100];
    [selectDic setValue:self.provinceStr forKey:@"provinceCode"];
    [selectDic setValue:self.cityStr forKey:@"cityCode"];
    [selectDic setValue:self.districtStr forKey:@"areaCode"];
    [selectDic setValue:stateType  forKey:@"proStatus"];
    [selectDic setValue:formalizeType forKey:@"contForm"];
    if (![self.dateStr isEqual:@"年份"]) {
      [selectDic setValue:self.dateStr  forKey:@"belongTimeStr"];
    }
    [selectDic setValue:textFiledStr forKey:@"baseInfoDept"];
    DLog(@"-------%@",selectDic);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnSelectInfo" object:nil userInfo:selectDic];
    

}

- (void)doNetworking :(NSDictionary *)diction andIndex:(NSInteger) integer{
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getArea] isNeedCache:NO parameters:diction successBlock:^(id response) {
        DLog(@"=======%@",response);
        [addressArray removeAllObjects];
        [addressCodeArray removeAllObjects];
        for (NSDictionary *dic in response[@"data"]) {
            [addressArray addObject:dic[@"name"]];
        }
        for (NSDictionary *dic in response[@"data"]) {
            [addressCodeArray addObject:dic[@"code"]];
        }
        self.selectDataArray = addressArray;
        [self showMenu:integer];
    } failureBlock:^(NSError *error) {
        DLog(@"======%@",error);
    } progress:nil];
}

@end
