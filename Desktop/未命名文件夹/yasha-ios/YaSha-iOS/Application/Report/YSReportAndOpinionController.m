//
//  YSReportAndOpinionController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/7/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReportAndOpinionController.h"
#import "YSMQImageSelectCellCell.h"
#import "YSReportHeaderView.h"
#import "YSReportInfoCell.h"
@interface YSReportAndOpinionController ()
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,strong) YSReportHeaderView *headerView;
@end

@implementation YSReportAndOpinionController
- (NSMutableArray *)imageArr{
	if (!_imageArr) {
		_imageArr = [NSMutableArray arrayWithCapacity:10];
		[_imageArr addObject:[UIImage imageNamed:@"添加照片"]];
	}
	return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"举报申请";
	UIButton *subitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	subitBtn.backgroundColor = [UIColor colorWithHexString:@"#2F86F6"];
	[subitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[subitBtn setTitle:@"提交" forState:UIControlStateNormal];
	[self.view addSubview:subitBtn];
	[subitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.right.mas_equalTo(-20);
		make.bottom.mas_equalTo(-kBottomHeight - 20);
		make.height.mas_equalTo(50*kHeightScale);
	}];
	YSWeak;
	[[subitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[weakSelf submit];
	}];
}
- (void)initTableView {
	[super initTableView];
	self.tableView.tableFooterView = [UIView new];
	self.tableView.tableFooterView.frame = CGRectMake(0, 0, 0, 60);
	YSReportHeaderView *headerView = [[YSReportHeaderView alloc]init];
	self.headerView = headerView;
	headerView.frame = CGRectMake(0, 0, 0, 150);
	//self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.tableHeaderView = headerView;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}else{
		return 3;
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		YSMQImageSelectCellCell *imageCell = [[YSMQImageSelectCellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		imageCell.dataArray = self.imageArr;
		YSWeak;
		imageCell.selectedImageBlock = ^(NSMutableArray * _Nonnull imageArray) {
			weakSelf.imageArr = imageArray;
			[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			
		};
		return imageCell;
	}else{
		YSReportInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
		if (infoCell  == nil) {
			infoCell = [[NSBundle mainBundle] loadNibNamed:@"YSReportInfoCell" owner:self options:nil].firstObject;
		}
		switch (indexPath.row) {
			case 0:
				infoCell.titleLb.text = @"举报提交人";
				infoCell.infoLb.text = [YSUtility getName];
				break;
			case 1:
				infoCell.titleLb.text = @"工号";
				infoCell.infoLb.text = [YSUtility getUID];
				break;
				
			default:
				infoCell.titleLb.text = @"手机号码";
				infoCell.infoLb.text = [YSUtility getMobile];
				break;
		}
		return infoCell;
	}
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 0.0;
	}
	return 15;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}
- (void)submit {
	NSString *complaint = self.headerView.textView.text;
	if (!complaint.length) {
		[QMUITips showInfo:@"请填写投诉意见" inView:self.view hideAfterDelay:2.0];
		
		return;
	}
	NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:5];
	[paraDic setObject:complaint forKey:@"complaint"];
	[paraDic setObject:[YSUtility getMobile] forKey:@"userPhone"];
	NSMutableArray *imageArr;
	if (self.imageArr.count > 1) {
		imageArr = [NSMutableArray arrayWithArray:self.imageArr];
		[imageArr removeLastObject];//去掉加号
	}
	
	[QMUITips showLoadingInView:self.view];
	[YSNetManager ys_uploadImageWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,submitComplaint] parameters:paraDic imageArray:imageArr file:@"images" successBlock:^(id response) {
		[QMUITips hideAllTipsInView:self.view];
		if ([response[@"code"] integerValue] == 1) {
			[QMUITips showInfo:@"提交成功" inView:self.view hideAfterDelay:2.0];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.navigationController popViewControllerAnimated:YES];
			});
			
		}else{
			[QMUITips showInfo:response[@"msg"] inView:self.view hideAfterDelay:2.0];
		}
	} failurBlock:^(NSError *error) {
		
	} upLoadProgress:nil];
	
}
@end
