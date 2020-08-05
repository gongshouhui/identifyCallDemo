//
//  YSWorkProveRemoveViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2020/2/10.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSWorkProveRemoveViewController.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSCRMYXBaseModel.h"
#import "YSCRMEnumChoseGView.h"
#import "YSProvePhotoRemoveViewController.h"

@interface YSWorkProveRemoveViewController ()<CRMYXTextFieldDelegate>
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, strong) NSMutableArray *unitArray;
@property (nonatomic, strong) UIButton *cloverBtn;

@end

@implementation YSWorkProveRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复工证明申请";
    
    [self loadInitData];
}


- (void)loadInitData {
    NSArray *dataArray = @[@{@"nameStr":@"申请人", @"holderStr":@"请输入", @"accessoryView":@0, @"isMustWrite":@(YES), @"textTF":[YSUtility getName], @"isTFEnabled":@(YES)},@{@"nameStr":@"工号", @"holderStr":@"请输入", @"accessoryView":@0, @"isMustWrite":@(YES), @"textTF":[YSUtility getUID], @"isTFEnabled":@(YES)},@{@"nameStr":@"身份证号码", @"holderStr":@"请输入", @"accessoryView":@0, @"isMustWrite":@(YES)},@{@"nameStr":@"单位名称", @"holderStr":@"请选择", @"isMustWrite":@(YES), @"accessoryView":@1, @"isTFEnabled":@(YES)}];
    [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]];
    [self.paramDic setObject:[YSUtility getName] forKey:@"name"];
    [self.paramDic setObject:[YSUtility getUID] forKey:@"uid"];
    
    //工作单位
    [self.unitArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:@[@{@"name":@"亚厦集团"}, @{@"name":@"亚厦装饰"}, @{@"name":@"亚厦幕墙"}, @{@"name":@"亚厦机电"}, @{@"name":@"蘑菇加"}]]];
}

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7FF"];
    [self.tableView registerClass:[YSCRMYXAddTableViewCell class] forCellReuseIdentifier:@"workCellProce"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}


#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 95*kHeightScale;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor colorWithHexString:@"#fffff9e5"];
    [sectionView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60*kHeightScale);
    }];
    
    UILabel *alertLab = [UILabel new];
    alertLab.text = @"注：本次复工申请范围(集团、装饰、幕墙、机电、蘑菇加),若您所在的单位不在本次申请范围内，请联系所在单位的人力资源部";
    alertLab.textColor = [UIColor colorWithHexString:@"#F08250"];
    alertLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(12)];
    alertLab.numberOfLines = 0;
    [alertView addSubview:alertLab];
    [alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView *titleView = [UIView new];
    [sectionView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.mas_bottom);
        make.bottom.left.right.mas_equalTo(0);
    }];
    UILabel *lab = [UILabel new];
    lab.text = @"申请信息";
    lab.textColor = [UIColor colorWithHexString:@"#FF999999"];
    lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(12)];
    [titleView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionFooterView = [UIView new];
    UIButton *commitBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [commitBtn setTitle:@"生成证明" forState:(UIControlStateNormal)];
    [commitBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFFFF"] forState:(UIControlStateNormal)];
    commitBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2A8BDC"];
    commitBtn.layer.cornerRadius = 4;
    commitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
    [sectionFooterView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(345*kWidthScale, 47*kHeightScale));
    }];
    @weakify(self);
    [[commitBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        for (YSCRMYXBaseModel *model in self.dataSourceArray) {
            if ([YSUtility judgeIsEmpty:model.textTF]) {
                [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1.5];
                return ;
            }
        }

        if (![YSUtility isIDCode:[self.paramDic objectForKey:@"idCard"]]) {
            [QMUITips showInfo:@"身份证号不正确" inView:self.view hideAfterDelay:2];
            return;
        }
        YSProvePhotoRemoveViewController *photoVC = [YSProvePhotoRemoveViewController new];
        photoVC.paramDic = [NSDictionary dictionaryWithDictionary:self.paramDic];
        [self.navigationController pushViewController:photoVC animated:YES];
    }];
    return sectionFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workCellProce" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.workProveModel = self.dataSourceArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark--CRMYXTextFieldDelegate
- (void)textField:(UITextField*)textField inputTextFieldChangeModel:(YSCRMYXBaseModel *)model {
    YSWeak;
    NSInteger index = [weakSelf.dataSourceArray indexOfObject:model];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.inputAccessoryView = nil;
    textField.inputView = nil;
    model.textTF = textField.text;
    switch (index) {
        case 2:
            {
                [self.paramDic setObject:textField.text forKey:@"idCard"];
            }
            break;
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.row == 3) {
        YSWeak;
        [self.view addSubview:self.cloverBtn];
        YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:(CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale, kSCREEN_WIDTH, 325*kHeightScale))];
        [self.view addSubview:enumView];
        enumView.dataArray = self.unitArray;
        @weakify(self);
        [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self);
            [self clickedCloverBtnAction:self.cloverBtn];
        }];
        enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
            @strongify(self);
            [self clickedCloverBtnAction:self.cloverBtn];
            model.textTF = choseModel.name;
            cell.rightTF.text = choseModel.name;
            [weakSelf.paramDic setObject:choseModel.name forKey:@"company"];
        };
    }
}


#pragma mark--setter&&getter
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (NSMutableArray *)unitArray {
    if (!_unitArray) {
        _unitArray = [NSMutableArray new];
    }
    return _unitArray;
}
- (UIButton *)cloverBtn {
    if (!_cloverBtn) {
        _cloverBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _cloverBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _cloverBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        [_cloverBtn addTarget:self action:@selector(clickedCloverBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _cloverBtn;
}

- (void)clickedCloverBtnAction:(UIButton*)sender {
    
    YSWeak;
    [self.view endEditing:YES];
    UIView *superView = sender.superview;
    UIView *outsideView = [superView.subviews lastObject];
    UIView *keyboard = [self.view viewWithTag:10001];
    [UIView animateWithDuration:1 animations:^{
        [outsideView removeFromSuperview];
        [keyboard removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.cloverBtn];
    } completion:^(BOOL finished) {
        [weakSelf.cloverBtn removeFromSuperview];
        weakSelf.cloverBtn = nil;
    }];
    
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
