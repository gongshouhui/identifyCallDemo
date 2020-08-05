//
//  YSPerfEvaluaRecordListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/21.
//

#import "YSPerfEvaluaRecordListViewController.h"
#import "YSPerfEvaluaRecordModel.h"
#import "YSPerfEvaluaRecordCell.h"

@interface YSPerfEvaluaRecordListViewController ()

@end

@implementation YSPerfEvaluaRecordListViewController

static NSString *cellIdentifier = @"PerfEvaluaRecordCell";

- (void)initTableView {
    [super initTableView];
    self.title = @"审批记录";
    [self.tableView registerClass:[YSPerfEvaluaRecordCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

//获取绩效的审批记录
- (void)doNetworking {
    DLog(@"------%@",_cellModel.id);
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%zd", YSDomain, getOptRecordsAppApi, _cellModel.id, self.pageNumber];
    DLog(@"========%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"绩效列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getPerfEvalueRecordListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getPerfEvalueRecordListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfEvaluaRecordCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPerfEvaluaRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSPerfEvaluaRecordModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfEvaluaRecordModel *cellModel = self.dataSourceArray[indexPath.row];
    if (cellModel.rebackReason) {
        [self showReason:cellModel];
    }
}

/** 显示原因说明遮罩 */
- (void)showReason:(YSPerfEvaluaRecordModel *)cellModel {
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300*kWidthScale, 350*kHeightScale)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UITextView *label = [[UITextView alloc] init];
//    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原因说明:\n%@", cellModel.rebackReason] attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 300*kHeightScale);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 presentViewController 的形式展示
    [self presentViewController:modalViewController animated:NO completion:nil];
}

@end
