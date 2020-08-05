//
//  YSExpenseShareCell.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/7.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseShareCell.h"
#import "YSFlowFormListCell.h"
#import "YSExpenseShareHeaderView.h"
@interface YSExpenseShareCell()<UITableViewDelegate,UITableViewDataSource,YSExpenseShareHeaderViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end
@implementation YSExpenseShareCell
{
    BOOL isexpand;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[YSFlowFormListCell class] forCellReuseIdentifier:@"YSFlowFormListCell"];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
}
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
    [self layoutIfNeeded];
   //确定内嵌tableView的高度,以便最外层的tableView自适应高度（至上而下）
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.tableView.contentSize.height);
    }];
    DLog(@"tableView.contentSize.height--%f",self.tableView.contentSize.height);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //自适应为什么不能把约束写在这里？
}
#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFlowExpensePexpShareModel *model = self.dataArr[section];
    if (!model.isexpand) {
        return model.dShareDetailList.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowExpensePexpShareModel *model = self.dataArr[indexPath.section];
    YSFlowExpenseShareDetailModel *detailModel = model.dShareDetailList[indexPath.row];
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell" forIndexPath:indexPath];
    cell.expenseDetailmodel = detailModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowExpensePexpShareModel *model = self.dataArr[indexPath.section];
    YSFlowExpenseShareDetailModel *detailModel = model.dShareDetailList[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"YSFlowFormListCell" configuration:^(YSFlowFormListCell *cell) {
        [cell setExpenseDetailmodel:detailModel];
        cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",detailModel.money];
    }];
}
//嵌套tableView时里面和外面都是系统的自适应高度时，有时会计算不准确，也和预估高度有关
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //return UITableViewAutomaticDimension;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YSFlowExpensePexpShareModel *model = self.dataArr[section];
    YSExpenseShareHeaderView *view = [[YSExpenseShareHeaderView alloc]init];
    view.tag = 500 + section;
    view.model = model;
    view.delegate = self;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = kGrayColor(247);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


#pragma mark - YSExpenseShareHeaderViewDelegate
- (void)expandButtonDidClick:(YSExpenseShareHeaderView *)headerView {
    
    YSFlowExpensePexpShareModel *model = self.dataArr[headerView.tag - 500];
    model.isexpand = !model.isexpand;
    NSIndexPath *indexPath = [self.fatherTableView indexPathForCell:self];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    [self.fatherTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
