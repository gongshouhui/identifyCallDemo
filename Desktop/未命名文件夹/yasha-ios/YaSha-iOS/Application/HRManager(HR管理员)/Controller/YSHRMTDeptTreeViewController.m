//
//  YSHRMTDeptTreeViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTDeptTreeViewController.h"
#import "YSHRMTDeptTreeTableViewCell.h"

@interface YSHRMTDeptTreeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *choseIndexArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *allDataArray;


@end

@implementation YSHRMTDeptTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviView];
    [self.view addSubview:self.tableView];
    [self loadBottomSubViews];
    [QMUITips showLoadingInView:self.view];
	if (_deptArray.count) {
		[self handelAllData];
		[QMUITips hideAllToastInView:self.view animated:NO];
		[self.tableView reloadData];
	}else{
		[YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDeptTreeApi] isNeedCache:NO parameters:nil successBlock:^(id response) {
           
            if (1==[[response objectForKey:@"code"] integerValue]) {
                self.deptArray = [NSArray arrayWithArray:[response objectForKey:@"data"]];
				[self handelAllData];
				[QMUITips hideAllToastInView:self.view animated:NO];
				[self.tableView reloadData];
            }
        } failureBlock:^(NSError *error) {
           [QMUITips hideAllToastInView:self.view animated:NO];
		} progress:nil];
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setNaviView {
    _navView = [[UIView alloc]initWithFrame:CGRectMake(75*kWidthScale, 0, kSCREEN_WIDTH-75*kWidthScale, kTopHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
//    [_navView setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10*kWidthScale, 2*kHeightScale+kStatusBarHeight, 28*kWidthScale, 38*kHeightScale);
    [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
    [btn addTarget:self action:@selector(temaBack) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:btn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-75*kWidthScale-100*kWidthScale)/2, kStatusBarHeight+11*kHeightScale, 100*kWidthScale, 22*kHeightScale)];
    titleLabel.text = @"请选择";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#111518"];
    [_navView addSubview:titleLabel];
    [self.view addSubview:_navView];
}

- (void)loadBottomSubViews {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRectMake(75*kWidthScale, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), 75*kHeightScale))];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(18)];
    [confirmBtn addTarget:self action:@selector(clickedConfirmBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#1890FF"];
    [bottomView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(268*kWidthScale, 46*kHeightScale));
    }];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:(CGRectMake(CGRectGetMinX(bottomView.frame), CGRectGetMaxY(bottomView.frame), CGRectGetWidth(bottomView.frame), kBottomHeight))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
}

#pragma mark--初始化显示的数据源
- (void)handelAllData {
    NSMutableArray *ponitArray = [NSMutableArray new];
    [self.deptArray enumerateObjectsUsingBlock:^(NSDictionary *pointDic, NSUInteger idx, BOOL * _Nonnull stop) {
        YSDeptTreePointModel *point = [[YSDeptTreePointModel alloc]initWithPointDic:pointDic];
        point.point_depth = @"0";
        point.point_expand = YES;
        [ponitArray addObject:point];
    }];
    [self recursiveAllPoints:ponitArray];
    [self.allDataArray enumerateObjectsUsingBlock:^(YSDeptTreePointModel *point, NSUInteger idx, BOOL * _Nonnull stop) {
        if (point.point_expand) {
            [self.dataArray addObject:point];
        }
    }];
}

- (void)recursiveAllPoints:(NSMutableArray*)point_arrM {
    __block int i = 0;
    [point_arrM enumerateObjectsUsingBlock:^(YSDeptTreePointModel *point, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.allDataArray addObject:point];
        i = [point.point_depth intValue];
        if ([[NSString stringWithFormat:@"%@",point.point_son] isEqual:@"1"]) {
            i = i + 1;
            NSMutableArray *sonPoints = [NSMutableArray array];
            [point.point_son1 enumerateObjectsUsingBlock:^(NSDictionary *pointDic, NSUInteger idx, BOOL * _Nonnull stop) {
                YSDeptTreePointModel *point = [[YSDeptTreePointModel alloc]initWithPointDic:pointDic];
                point.point_depth = [NSString stringWithFormat:@"%d",i];
                point.point_expand = NO;
                [sonPoints addObject:point];
            }];
            [self recursiveAllPoints:sonPoints];
        }else{
            i = 0 ;
        }
    }];
}

#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRMTDeptTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deptTreeCEID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YSDeptTreePointModel *model = self.dataArray[indexPath.row];
    [cell.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(([model.point_depth integerValue]+1)*18*kWidthScale);
    }];
    if ([self.choseIndexArray containsObject:indexPath]) {
        cell.leftLineImg.hidden = NO;
        cell.titleLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
    }else {
        cell.leftLineImg.hidden = YES;
        cell.titleLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];

    }
    cell.titleLab.text = model.point_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.choseIndexArray.count) {
        YSHRMTDeptTreeTableViewCell *cell = [tableView cellForRowAtIndexPath:self.choseIndexArray[0]];
        cell.leftLineImg.hidden = YES;
        cell.titleLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
        [self.choseIndexArray removeAllObjects];
    }
    [self.choseIndexArray addObject:indexPath];
    YSHRMTDeptTreeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.leftLineImg.hidden = NO;
    cell.titleLab.textColor = [UIColor colorWithHexString:@"#1890FF"];

    YSDeptTreePointModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i = 0 ; i < self.allDataArray.count; i++) {
        YSDeptTreePointModel *node = [self.allDataArray objectAtIndex:i];
        if ([node.point_pid isEqualToString:model.point_id]) {
            node.point_expand = !node.point_expand;
            if (node.point_expand) {
                [self.dataArray insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:model];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i = startPosition; i < endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    //插入或者删除相关节点
    if (expand) {
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
//        [self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }

}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
- (NSUInteger)removeAllNodesAtParentNode:(YSDeptTreePointModel *)parentNode {
    NSUInteger startPosition = [self.dataArray indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i = startPosition+1; i < self.dataArray.count; i++) {
        YSDeptTreePointModel *node = [self.dataArray objectAtIndex:i];
        endPosition = endPosition+1;
        if ([node.point_depth integerValue] <= [parentNode.point_depth integerValue]) {
            break;
        }
        if(endPosition == self.dataArray.count-1){
            endPosition = endPosition+1;
            node.point_expand = NO;
            break;
        }
        node.point_expand = NO;
    }
    // 当为子级时 有可能长度为0 做一下非空处理
    if (endPosition > startPosition) {
        [self.dataArray removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1 == 0 ? 1 : endPosition-startPosition-1)];
    }
    return endPosition;
}

#pragma mark--选中部门
- (void)clickedConfirmBtnAction {
    if (!self.choseIndexArray.count) {
        [QMUITips showInfo:@"请先选择部门" inView:self.view hideAfterDelay:0.5];
        return;
    }
    [self temaBack];
    if (self.choseDeptTreeBlock) {
       YSDeptTreePointModel *model = self.dataArray[[self.choseIndexArray[0] row]];
        self.choseDeptTreeBlock(model);
    }
}

- (void)temaBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--setter&&getter
- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray new];
    }
    return _allDataArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(75*kWidthScale, kTopHeight, kSCREEN_WIDTH-75*kWidthScale, kSCREEN_HEIGHT-kBottomHeight-75*kHeightScale-kTopHeight)) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[YSHRMTDeptTreeTableViewCell class] forCellReuseIdentifier:@"deptTreeCEID"];
    }
    return _tableView;
}

- (NSMutableArray *)choseIndexArray {
    if (!_choseIndexArray) {
        _choseIndexArray = [NSMutableArray new];
    }
    return _choseIndexArray;
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
