//
//  YSEvaluationScoreViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/21.
//

#import "YSEvaluationScoreViewController.h"
#import "YSFlowExpressFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"
#import "YSFlowScoreTableViewCell.h"
#import "YSPMSInfoHeaderView.h"
#import "YSFlowTemplateViewController.h"

@interface YSEvaluationScoreViewController ()

@property (nonatomic,strong) YSPMSInfoHeaderView *infoHeaderView;

@end

@implementation YSEvaluationScoreViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考评评分";
}

- (void)initTableView {
    [super initTableView];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.tableView registerClass:[YSFlowScoreTableViewCell class] forCellReuseIdentifier:@"FlowScoreCell"];
    [self doNetworking];
}

- (void)doNetworking {
    [QMUITips hideAllTipsInView:self.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applyInfosArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    NSArray *headlineArray = @[self.name];
    self.infoHeaderView.positionLabel.text = headlineArray[section];
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(310*kWidthScale, 25*kHeightScale, 60*kWidthScale, 15*kHeightScale)];
    scoreLabel.font = [UIFont systemFontOfSize:15];
    scoreLabel.text = [NSString stringWithFormat:@"%.2f分",[self.score floatValue]];
    [backView addSubview:scoreLabel];
   
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"FlowScoreCell" cacheByIndexPath:indexPath configuration:^(YSFlowScoreTableViewCell *cell) {
        if ([self.applyInfosArray[indexPath.row] isEqual:@""]) {
             cell.contentLabel.text = @"设置";
        }else{
            cell.contentLabel.text = self.applyInfosArray[indexPath.row];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowScoreCell"];
    if (cell == nil) {
        cell = [[YSFlowScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowScoreCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setFlowScoreData:self.applyInfosArray andIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%5==0) {
        DLog(@"======%@",self.arrayData);
        YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.arrayData[indexPath.row/5];
        DLog(@"=====%@",applyInfosModel.content);
        YSFlowTemplateViewController *FlowTemplateViewController = [[YSFlowTemplateViewController alloc]init];
        FlowTemplateViewController.urlStr = [NSString stringWithFormat:@"%@%@.do",YSTemplateDomain, applyInfosModel.mobileId];
        [self.navigationController pushViewController:FlowTemplateViewController animated:YES];
    }
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
