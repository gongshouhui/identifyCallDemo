//
//  YSSalaryDetailController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSalaryDetailController.h"
#import "YSSalaryCell.h"
#import "YSSalaryHeaderView.h"
#import "YSSalaryRemarkCell.h"
#import "YSImageTitleButton.h"
#import <AVKit/AVKit.h>
@interface YSSalaryDetailController ()

@property (nonatomic,strong)YSSalaryHeaderView *headerView;
@property (nonatomic,strong)NSMutableArray *infoArr;
@property (nonatomic,strong)NSMutableArray *payArr;
@property (nonatomic,strong)NSMutableArray *welfareArr;
@property (nonatomic,strong)NSMutableArray *takeoutArr;
@property (nonatomic,strong)NSMutableArray *remarkArr;
@property (nonatomic,strong) NSMutableArray *deductArr;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong) UIView *footerView;
//@property (nonatomic,strong)NSMutableArray *dataSourceArray;
@property (nonatomic,strong) AVPlayerViewController *playerVC;
@end

@implementation YSSalaryDetailController
- (AVPlayerViewController *)playerVC {
	if (!_playerVC) {
	
	//步骤1：获取视频路径
	NSString *webVideoPath = @"http://file.chinayasha.com/oa/2019/09/10/video.mp4";
	NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
	//步骤2：创建AVPlayer
	AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
	//步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
	_playerVC =[[AVPlayerViewController alloc] init];
		_playerVC.player = avPlayer;
		
		[_playerVC.player addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
	}
	return _playerVC;
}
#pragma mark - 懒加载
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"基本信息",@"应发工资",@"应发福利",@"代扣款项",@"备注",@"专项附加扣除额度（元）",@"税后扣款"];
    }
    return _titleArray;
}
-(UIView *)footerView {
	if (!_footerView) {
		_footerView = [[UIView alloc]init];
		UILabel *explainLb = [[UILabel alloc]init];
		explainLb.numberOfLines = 0;
		explainLb.font = [UIFont systemFontOfSize:12];
		explainLb.textColor = kUIColor(153, 153, 153, 1);
		explainLb.text = @"说明：2019年1月1日起实行综合所得计税,，月度个税=（累计应纳税所得额*税率-速算扣除数）-累计已扣个税；累计应纳税所得额=累计收入-累计免税额度，其中累计收入为本年度截止当前月份在本公司工资总额之和，免税额度包含个税起征点、社保公积金、专项附加扣除等；专项附加扣除额度以每月税务系统数据为准，如有数据延迟的顺延至下月补扣。若想要了解更多个税信息，请戳以下视频";
		CGRect textRect = [explainLb.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
		[_footerView addSubview:explainLb];
		[explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(15);
			make.right.mas_equalTo(-15);
			make.top.mas_equalTo(10);
		}];
		YSImageTitleButton *playBtn = [YSImageTitleButton buttonWithType:UIButtonTypeCustom];
		[playBtn addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
		[playBtn setTitle:@"查看视频" forState:UIControlStateNormal];
		playBtn.space = 10;
		[playBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
		playBtn.titleLabel.font = [UIFont systemFontOfSize:12];
		[playBtn setTitleColor:[UIColor colorWithHexString:@"2A8ADB"] forState:UIControlStateNormal];
		[_footerView addSubview:playBtn];
		[playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(explainLb.mas_bottom);
			make.left.mas_equalTo(explainLb.mas_left);
			make.height.mas_equalTo(40);
		}];
		_footerView.frame = CGRectMake(0, 0, 0, textRect.size.height + 40 + 10);
	}
	return _footerView;
}
- (YSSalaryHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YSSalaryHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
        
    }
    return _headerView;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
     self.title = @"我的薪资条";
}

- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tableView.backgroundColor = kUIColor(229, 229, 229, 1);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.model = self.salaryModel;
    [self.tableView registerClass:[YSSalaryRemarkCell class] forCellReuseIdentifier:@"YSSalaryRemarkCell"];
	self.tableView.tableFooterView = self.footerView;
    [self doNetworking];
    
}
- (void)doNetworking{
    self.infoArr = [NSMutableArray array];
    self.payArr = [NSMutableArray array];
    self.welfareArr = [NSMutableArray array];
    self.takeoutArr = [NSMutableArray array];
    self.remarkArr = [NSMutableArray array];
	self.deductArr = [NSMutableArray array];
	NSMutableArray *debitArr = [NSMutableArray arrayWithCapacity:10];
    
    [self.infoArr addObject:@{@"发放月份":self.salaryModel.smonth}];
    [self.infoArr addObject:@{@"工号":self.salaryModel.icode}];
    [self.infoArr addObject:@{@"姓名":self.salaryModel.iname}];
    [self.infoArr addObject:@{@"发放部门":self.salaryModel.deptName}];
    [self.infoArr addObject:@{@"月基本工资":self.salaryModel.mbasePay}];
    [self.infoArr addObject:@{@"月绩效工资":self.salaryModel.mperfPay}];

    [self.payArr addObject:@{@"基本工资":self.salaryModel.basePay}];
    [self.payArr addObject:@{@"绩效工资":self.salaryModel.perfPay}];
    [self.payArr addObject:@{@"加班工资":self.salaryModel.otPay}];
    [self.payArr addObject:@{@"奖金":self.salaryModel.bonus}];
    [self.payArr addObject:@{@"合计":self.salaryModel.shTotal}];

    [self.welfareArr addObject:@{@"餐补":self.salaryModel.mealAllowance}];
    [self.welfareArr addObject:@{@"住房补贴":self.salaryModel.housingSubsidy}];
    [self.welfareArr addObject:@{@"通讯补贴":self.salaryModel.comtSubsidy}];
    [self.welfareArr addObject:@{@"交通补贴":self.salaryModel.trafficSubsidy}];
    [self.welfareArr addObject:@{@"高温补贴":self.salaryModel.highTemSubsidy}];
    [self.welfareArr addObject:@{@"其他补贴":self.salaryModel.otherSubsidy}];
    [self.welfareArr addObject:@{@"补发/补扣":self.salaryModel.reissueBuckle}];
    [self.welfareArr addObject:@{@"合计":self.salaryModel.subTotal}];

    [self.takeoutArr addObject:@{@"社保":self.salaryModel.socialSecurity}];
    [self.takeoutArr addObject:@{@"公积金":self.salaryModel.acctFund}];
    [self.takeoutArr addObject:@{@"个税":self.salaryModel.pit}];
    [self.takeoutArr addObject:@{@"其他":self.salaryModel.otherBuckle}];
    [self.takeoutArr addObject:@{@"合计":self.salaryModel.pitTotal}];
	//备注
    [self.remarkArr addObject:@{@"remark":self.salaryModel.remark}];
	
	[self.deductArr addObject:@{@"累计子女教育":[NSString stringWithFormat:@"%.2f",self.salaryModel.cumulativeChildEducation]}];
	[self.deductArr addObject:@{@"累积住房贷款利息":[NSString stringWithFormat:@"%.2f",self.salaryModel.cumulativeInterestOnHousingLoans]}];
	[self.deductArr addObject:@{@"累积住房租金":[NSString stringWithFormat:@"%.2f",self.salaryModel.cumulativeHousingRent]}];
	[self.deductArr addObject:@{@"累积赡养老人":[NSString stringWithFormat:@"%.2f",self.salaryModel.cumulativeSupportForTheElderly]}];
	[self.deductArr addObject:@{@"累积继续教育":[NSString stringWithFormat:@"%.2f",self.salaryModel.cumulativeContinuingEducation]}];

	
	[debitArr addObject:@{@"税后扣款金额":[NSString stringWithFormat:@"%.2f",self.salaryModel.afterTaxDebit]}];
	[debitArr addObject:@{@"扣款备注":[NSString stringWithFormat:@"%.2f",self.salaryModel.debitRemark]}];
	
    
    [self.dataSourceArray addObject:_infoArr];
    [self.dataSourceArray addObject:_payArr];
    [self.dataSourceArray addObject:_welfareArr];
    [self.dataSourceArray addObject:_takeoutArr];
    [self.dataSourceArray addObject:_remarkArr];
	[self.dataSourceArray addObject:_deductArr];
	[self.dataSourceArray addObject:debitArr];
    
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *)(self.dataSourceArray[section]) count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //备注分区
    if (indexPath.section == self.dataSourceArray.count - 3) {
         return [tableView fd_heightForCellWithIdentifier:@"YSSalaryRemarkCell" cacheByIndexPath:indexPath configuration:^(YSSalaryRemarkCell *cell) {

        cell.remarkLb.text = self.dataSourceArray[indexPath.section][indexPath.row][@"remark"];

        }];
    }else{
        return 40*kHeightScale;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.dataSourceArray.count - 3) {
        YSSalaryRemarkCell *cell = [[YSSalaryRemarkCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSSalaryRemarkCell"];
        cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
        return cell;
    }else{
       
        YSSalaryCell *cell = [[YSSalaryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSSalaryCell"];
        cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
        [cell setOtherByIndexPath:indexPath withArray:self.dataSourceArray[indexPath.section]];//设置圆角 字体
        return cell;
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kUIColor(229, 229, 229, 1);
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kUIColor(102, 102, 102, 1);
    
    label.text = self.titleArray[section];
    label.frame = CGRectMake(15, (38 - 20)/2, kSCREEN_WIDTH, 20);
    return view;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//	if (section == self.dataSourceArray.count - 1) {
//
//	}
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 播放视频
- (void)clickPlay{
//	//步骤1：获取视频路径
//	NSString *webVideoPath = @"http://file.chinayasha.com/oa/2019/09/10/video.mp4";
//	NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
//	//步骤2：创建AVPlayer
//	AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
//	//步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
//	AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
//	avPlayerVC.player = avPlayer;
//	//步骤4：设置播放器视图大小
//	avPlayerVC.view.frame = CGRectMake(25, kTopHeight, 320, 300);
//	//特别注意:AVPlayerViewController不能作为局部变量被释放，否则无法播放成功
//	//解决1.AVPlayerViewController作为属性
//	//解决2:使用addChildViewController，AVPlayerViewController作为子视图控制器
//	[self addChildViewController:avPlayerVC];
//	[self.view addSubview:avPlayerVC.view];
	
	[self presentViewController:self.playerVC animated:YES completion:nil];
	
		//这里必须监听到准备好开始播放了，才把按钮添加上去（系统控件的懒加载机制，我们才能获取到合适的 view 去添加），不然很突兀！

	
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
	if ([keyPath isEqualToString:@"status"]) {
		AVPlayerStatus status = [change[@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
			[self.playerVC.player play];
		}
	}
	
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc{
	
	[self.playerVC.player removeObserver:self forKeyPath:@"status"];
	self.playerVC = nil;
}
@end
