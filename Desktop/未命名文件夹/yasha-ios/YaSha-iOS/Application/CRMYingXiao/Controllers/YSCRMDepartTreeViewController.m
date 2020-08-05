//
//  YSCRMDepartTreeViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/6/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCRMDepartTreeViewController.h"
#import "YSDeptTreePointModel.h"
#import "YSHRMTDeptTreeTableViewCell.h"
#import "YSContactSelectCell.h"
#import "YSBottomTwoBtnCGView.h"

@interface YSCRMDepartTreeViewController ()

@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *choseIndexArray;
@property (nonatomic, strong) NSMutableArray *resultsBlockArray;//最后选中的数组


@end

@implementation YSCRMDepartTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择部门";
    [self handelAllData];
    [self loadBottomView];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactSelectCell class] forCellReuseIdentifier:@"CRMDepartCell"];
    [self.tableView registerClass:[YSHRMTDeptTreeTableViewCell class] forCellReuseIdentifier:@"deptTreeCEID"];
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-70*kHeightScale);
}

- (void)loadBottomView {
    YSBottomTwoBtnCGView *bottomView = [[YSBottomTwoBtnCGView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView.leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [bottomView.rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    
    [bottomView.rightBtn addTarget:self action:@selector(clickedConfirmBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 70*kHeightScale));
        make.bottom.mas_equalTo(-kBottomHeight);
        make.left.mas_equalTo(0);
    }];
    @weakify(self);
    [[bottomView.leftBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark--初始化显示的数据源
- (void)handelAllData {
    NSMutableArray *ponitArray = [NSMutableArray new];
    [self.departArray enumerateObjectsUsingBlock:^(NSDictionary *pointDic, NSUInteger idx, BOOL * _Nonnull stop) {
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

#pragma mark--选中部门确定
- (void)clickedConfirmBtnAction {
    if (self.choseIndexArray.count == 0) {
        [QMUITips showInfo:@"请先选择部门" inView:self.view hideAfterDelay:1.5];
        return;
    }
    /*
    if (self.resultsBlockArray.count == 0) {
        [QMUITips showInfo:@"请先选择部门" inView:self.view hideAfterDelay:1.5];
        return;
    }
    */
    if (self.choseCRMDeptTreeBlock) {
        /*
        if (self.resultsBlockArray.count > 2) {
            YSDeptTreePointModel *firstModel = [self.resultsBlockArray firstObject];
            YSDepartmentModel *lastModel = [self.resultsBlockArray lastObject];
            [self.resultsBlockArray removeAllObjects];
            [self.resultsBlockArray addObject:firstModel];
            [self.resultsBlockArray addObject:lastModel];
        }else if (self.resultsBlockArray.count == 1) {
            [self.resultsBlockArray addObject:[self.resultsBlockArray lastObject]];
        }
        self.choseCRMDeptTreeBlock(self.resultsBlockArray);
         */
        YSDeptTreePointModel *model = [self.dataArray objectAtIndex:[self.choseIndexArray[0] row]]; self.choseCRMDeptTreeBlock(@[model]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
    /*
    YSContactSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRMDepartCell" forIndexPath:indexPath];
    return cell;
     */
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
    /*
    if (self.resultsBlockArray.count != 0) {
        // 选中的数组中 不包含当前选中的model
        if (![self.resultsBlockArray containsObject:model]) {

            // 遍历选中的数组 取出所有的id
            NSMutableArray *idModelArray = [NSMutableArray new];
            for (YSDeptTreePointModel *oldIDModel in self.resultsBlockArray) {
                [idModelArray addObject:oldIDModel.point_id];
            }
            //用数组中的id 与当前选中molde.pid 判断位置
            if ([YSUtility judgeIsEmpty:model.point_pid]) {
                // 一级的列表的pid全为空
                [self.resultsBlockArray removeAllObjects];
            }else if ([idModelArray containsObject:model.point_pid]) {
                // 当前选中的model的上层父级 已在数组中
                NSInteger lastIDIndex = [idModelArray indexOfObject:model.point_pid];
                if (lastIDIndex != idModelArray.count-1) {
                    // 当前选中的model 不是以前添加的最后一位 id的位置就是model的位置
                    [self.resultsBlockArray removeObjectsInRange:(NSMakeRange(lastIDIndex+1, idModelArray.count-1-lastIDIndex))];
                }
            }else {
                // 当前选中的model的父级 不在数组中 使用深度判断 查找当前选中的model的父级
                [self.resultsBlockArray removeAllObjects];
                [self queryParentModelOfTheRecentWith:indexPath.row-1 withPoint_depth:[model.point_depth integerValue]];
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"point_depth" ascending:YES];
                //数组排序
                self.resultsBlockArray = [NSMutableArray arrayWithArray:[self.resultsBlockArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
            }
            [self.resultsBlockArray addObject:model];
            
            
        }else {
            // 当前model已经在选中数组中了
            NSInteger lastIndex = [self.resultsBlockArray indexOfObject:model];
            if (lastIndex != self.resultsBlockArray.count-1) {
                // 当前选中的model 不是以前添加的最后一位
                [self.resultsBlockArray removeObjectsInRange:(NSMakeRange(lastIndex+1, self.resultsBlockArray.count-1-lastIndex))];
            }
        }
    }else {
        [self.resultsBlockArray addObject:model];
    }
     */
}


/**
 查询离当前位置model 最近的父级

 @param index 当前的model所在数组的 前一个位置
 @param point_depth 当前model的深度
 */
- (void)queryParentModelOfTheRecentWith:(NSInteger)index  withPoint_depth:(NSInteger)point_depth{
    YSDeptTreePointModel *depthModel = [self.dataArray objectAtIndex:index];
    for (;index > 0; index--) {// 初始深度为"0", 依次增加
        if ([depthModel.point_depth integerValue] < point_depth) {
            DLog(@"\n初始的值:%@---%ld", depthModel.point_name, point_depth);
            [self.resultsBlockArray addObject:depthModel];
            // 查询到的 第一个的pid为空 就是选中的model的公司
            if ([YSUtility judgeIsEmpty:depthModel.point_pid]) {
                // 父id为空 完成查询 因现在 一级pid全为空
                return;
            }
        }
        // 更改 判断的深度
        point_depth = [depthModel.point_depth integerValue];
        depthModel = self.dataArray[index == 0 ? 0: index-1];
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

#pragma mark--setter&&getter
- (NSMutableArray *)resultsBlockArray {
    if (!_resultsBlockArray) {
        _resultsBlockArray = [NSMutableArray new];
    }
    return _resultsBlockArray;
}
- (NSMutableArray *)allDataArray {
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray new];
    }
    return _allDataArray;
}

- (NSMutableArray *)choseIndexArray {
    if (!_choseIndexArray) {
        _choseIndexArray = [NSMutableArray new];
    }
    return _choseIndexArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
