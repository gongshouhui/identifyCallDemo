//
//  YSFlowFormListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowFormListCell.h"
@interface YSFlowFormListCell ()
@end

@implementation YSFlowFormListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self initUI];
	}
	return self;
}

- (void)initUI {
	
	_lableNameLabel = [[UILabel alloc] init];
	_lableNameLabel.font = [UIFont systemFontOfSize:14];
	_lableNameLabel.textColor = [UIColor colorWithHexString:@"#191F25"];
	_lableNameLabel.numberOfLines = 0;
	[self.contentView addSubview:_lableNameLabel];
	[_lableNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.contentView.mas_top).offset(12);
		make.left.mas_equalTo(self.contentView.mas_left).offset(15);
		make.width.mas_equalTo(110*kWidthScale);
		make.bottom.mas_equalTo(-12);
	}];
	
	_valueLabel = [[UILabel alloc] init];
	_valueLabel.numberOfLines = 0;
	_valueLabel.font = [UIFont boldSystemFontOfSize:14];
	_valueLabel.textAlignment = NSTextAlignmentRight;
	_valueLabel.textColor = [UIColor colorWithHexString:flowRightColor];
	[self.contentView addSubview:_valueLabel];
	
	[_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(12);
		make.left.mas_equalTo(_lableNameLabel.mas_right).mas_equalTo(12);
		make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
		make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
	}];
	
}


- (void)setCellModel:(YSFlowFormListModel *)cellModel {
	_cellModel = cellModel;
	
	_lableNameLabel.text = _cellModel.lableName;
	// 解决为空字符串时行高问题
	if ([_cellModel.value isEqual:@""] || !_cellModel.value) {
		_cellModel.value = @" ";
	}
	//    _valueLabel.attributedText = [YSUtility setUpLineSpaceWith:_cellModel.value lineSpace:6];
	_valueLabel.text = _cellModel.value;
	if ([_cellModel.fieldType isEqual:@"upload"]) {
		_valueLabel.text = @"请在上方关联文档中进行查看";
	}
	// 子表单箭头显示
	self.accessoryType = [_cellModel.fieldType isEqual:@"subform"] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	if ([_cellModel.fieldType isEqual:@"subform"]) {
		[_valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(8);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
			
			make.right.mas_equalTo(self.contentView.mas_right).offset(0);
			make.size.mas_equalTo(CGSizeMake(26,26));
		}];
		_valueLabel.layer.masksToBounds = YES;
		_valueLabel.layer.cornerRadius = 13;
		_valueLabel.backgroundColor = [UIColor redColor];
		_valueLabel.textColor = [UIColor whiteColor];
		_valueLabel.textAlignment = NSTextAlignmentCenter;
		int k = 1;
		DLog(@"-------%@",_cellModel.values);
		if ( _cellModel.values.count > 0) {
			for (int i = 0; i < _cellModel.values.count; i++) {
				YSFlowFormListModel *model = _cellModel.values[i];
				DLog(@"========%@",model.fieldType);
				if ([model.fieldType isEqual:@"separator"]) {
					k = k+1;
				}
				_valueLabel.text = [NSString stringWithFormat:@"%d",k];
			}
		}else{
			_valueLabel.hidden = YES;
		}
		
	}
	// 分割线处理
	self.backgroundColor = [_cellModel.fieldType isEqual:@"separator"] ? [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00] : UIColorWhite;
	self.lableNameLabel.textColor = [_cellModel.fieldType isEqual:@"separator"] ? [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00] : UIColorBlack;
	if ([_cellModel.fieldType isEqual:@"separator"]) {
		_lableNameLabel.font = [UIFont systemFontOfSize:13];
	} else {
		_lableNameLabel.font = [UIFont systemFontOfSize:14];
		
	}
	
	// url跳转
	if ([_cellModel.fieldType isEqual:@"url"]) {
		_valueLabel.text = @" ";
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	if ([_cellModel.fieldType isEqualToString:@"linkedflow"]) {
		_valueLabel.text = @"请在上方关联流程中进行查看";
	}
}

- (void)setContentDic:(NSDictionary *)contentDic {
	_contentDic = contentDic;
	NSString *key = contentDic.allKeys.firstObject;
	NSString *content = contentDic.allValues.firstObject;
	if ([key isEqualToString:@"供货类别"]) {
		self.valueLabel.textAlignment = NSTextAlignmentLeft;
	}else{
		self.valueLabel.textAlignment = NSTextAlignmentRight;
	}
	
	UIColor *oriColor = self.valueLabel.textColor;
	if ([key isEqualToString:@"复核考察评分"]) {
		self.valueLabel.textColor = kUIColor(42, 138, 219, 1);
	}else{
		self.valueLabel.textColor = oriColor;
	}
	self.lableNameLabel.text = key;
	if (content.length == 0) {
		content = @"    ";
	}
	
	self.valueLabel.attributedText  = [YSUtility setUpLineSpaceWith:content lineSpace:6];
}
//旧业务流程赋值
- (void)setExpenseDetailWithDictionary:(NSDictionary *)contentDic Model:(YSFlowAssetsApplyFormListModel *)model {
	
	NSString *key = contentDic.allKeys.firstObject;
	NSString *content = contentDic.allValues.firstObject;
	
	if ([content containsString:@"￥"]) {
		content = [YSUtility positiveFormat:[content stringByReplacingOccurrencesOfString:@"￥" withString:@""]];
		content = [NSString stringWithFormat:@"￥%@",content];
	}
	self.lableNameLabel.text = key;
	self.valueLabel.attributedText  = [YSUtility setUpLineSpaceWith:content lineSpace:6];
	
	//cell特殊
	if ([key isEqualToString:@"岗位信息"] ||[key isEqualToString:@"任职资格"]) {
		self.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
		self.lableNameLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00];
		_lableNameLabel.font = [UIFont systemFontOfSize:13];
		[_lableNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.mas_equalTo(self.contentView.mas_centerY);
			make.left.mas_equalTo(self.contentView.mas_left).offset(15);
			make.height.mas_equalTo(15*kHeightScale);
		}];
	} else {
		_lableNameLabel.font = [UIFont systemFontOfSize:14];
		self.backgroundColor = UIColorWhite;
		self.lableNameLabel.textColor = UIColorBlack;
	}
	
	
	//特殊颜色
	//申请金额在业务和个人报销单情况是是蓝色
	UIColor *oriColor = self.valueLabel.textColor;
	if (([key isEqualToString:@"申请金额"] && !([model.categoryStr isEqualToString:@"备用金"]) && !([model.categoryStr isEqualToString:@"差旅报销单"]) && !([model.categoryStr isEqualToString:@"付款申请单"])) || [key hasPrefix:@"交通费用"] || [key hasPrefix:@"住宿费用"] || [key hasPrefix:@"补助"]||[key hasPrefix:@"原出差流程"]) {
		self.valueLabel.textColor = [UIColor colorWithHexString:@"007AFF"];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		[_valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(self.contentView.mas_right).offset(-1);
		}];
		
	}else{
		self.valueLabel.textColor = oriColor;
		[_valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
		}];
	}
	
	if ([key hasSuffix:@"(超标)"]) {
		self.lableNameLabel.textColor = kUIColor(239, 60, 60, 1);
	}else{
		self.lableNameLabel.textColor = [UIColor blackColor];
	}
	if (([key hasPrefix:@"附件"] ||[key hasPrefix:@"人员信息详情"] || [key hasPrefix:@"证书信息"]) && ![content isEqualToString:@"0"]) {
		[_valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(8);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
			
			make.right.mas_equalTo(self.contentView.mas_right).offset(0);
			make.size.mas_equalTo(CGSizeMake(26,26));
		}];
		_valueLabel.layer.masksToBounds = YES;
		_valueLabel.layer.cornerRadius = 13;
		_valueLabel.backgroundColor = [UIColor redColor];
		_valueLabel.textColor = [UIColor whiteColor];
		_valueLabel.textAlignment = NSTextAlignmentCenter;
	}
	if ([key hasPrefix:@"附件"] && [content isEqualToString:@"0"]) {
		_valueLabel.text = nil;
	}
	if ([key hasPrefix:@"具体材料"]) {
		UIImageView *image = [[UIImageView alloc]init];
		image.image = [UIImage imageNamed:@"电脑处理_icon"];
		image.layer.masksToBounds = YES;
		image.layer.cornerRadius = 13;
		[self.contentView addSubview:image];
		[image mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(8);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
			
			make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
			make.size.mas_equalTo(CGSizeMake(26,26));
		}];
	}
	if (content.length == 0) {
		content = @"-   ";
	}
}

- (void)setLeftArray:(NSArray *)leftArray indexPath:(NSIndexPath *)indexPath {
	NSDictionary *sectionDic = leftArray[indexPath.section];
	NSArray *titleArray = [sectionDic allValues][0];
	_lableNameLabel.text = titleArray[indexPath.row];
	// 解决为空字符串时行高问题
	if ([titleArray[indexPath.row] isEqual:@""]) {
		_lableNameLabel.text = @" ";
	}
	if ([titleArray[indexPath.row] containsString:@"行程"]) {
		_lableNameLabel.textColor = kThemeColor;
	}
	if ([titleArray[indexPath.row] containsString:@"金额合计"] && indexPath.row == 0) {
		_lableNameLabel.textColor = kThemeColor;
	}
}

- (void)setRightArray:(NSArray *)rightArray indexPath:(NSIndexPath *)indexPath {
	if (!rightArray.count) {
		return;
	}
	NSArray *flowDataArray = rightArray[indexPath.section];
	if (!flowDataArray.count) {
		return;
	}
	
	_valueLabel.attributedText = [YSUtility setUpLineSpaceWith:flowDataArray[indexPath.row] lineSpace:6];
	
	// 解决为空字符串时行高问题
	if ([flowDataArray[indexPath.row] isEqual:@""]) {
		_valueLabel.text = @" ";
	}
	if ([flowDataArray[indexPath.row] isEqual:@"查看详情"]) {
		_valueLabel.textColor = kThemeColor;
	}
	if (indexPath.row == 19) {
		_valueLabel.textColor = kThemeColor;
	}
}

- (void)setLeftDetailArray:(NSArray *)leftDetailArray indexPath:(NSIndexPath *)indexPath {
	_lableNameLabel.text = leftDetailArray[indexPath.row];
}

- (void)setRightDetailArray:(NSArray *)rightDetailArray indexPath:(NSIndexPath *)indexPath {
	if (!rightDetailArray.count) {
		return;
	}
	_valueLabel.attributedText = [YSUtility setUpLineSpaceWith:rightDetailArray[indexPath.row] lineSpace:6];
	if ([rightDetailArray[indexPath.row] isEqual:@""]) {
		_valueLabel.text = @" ";
	}
}
- (void)setExpenseDetailmodel:(YSFlowExpenseShareDetailModel *)expenseDetailmodel {
	[self.lableNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.contentView.mas_top).offset(12);
		make.left.mas_equalTo(self.contentView.mas_left).offset(15);
		make.right.mas_equalTo(_valueLabel.mas_left).offset(-15*kHeightScale);
		make.bottom.mas_equalTo(-12);
	}];
	[self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(12);
		make.width.mas_equalTo(100*kWidthScale);
		make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
		make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
	}];
	_expenseDetailmodel = expenseDetailmodel;
	self.lableNameLabel.textColor = kGrayColor(102);
	NSString *title = [NSString stringWithFormat:@"%@  %@  %@",expenseDetailmodel.costOwnerDept,expenseDetailmodel.company,expenseDetailmodel.costOwnerName];
	NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:title];
	[attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:kGrayColor(198)} range:[title rangeOfString:[NSString stringWithFormat:@" %@",expenseDetailmodel.company]]];
	[attiStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:kGrayColor(198)} range:[title rangeOfString:[NSString stringWithFormat:@" %@",expenseDetailmodel.costOwnerName]]];
	self.lableNameLabel.attributedText = attiStr;
	NSString *content = [YSUtility positiveFormat:[NSString stringWithFormat:@"%f",expenseDetailmodel.money]];
	self.valueLabel.attributedText = [YSUtility setUpLineSpaceWith:[NSString stringWithFormat:@"￥%@",content] lineSpace:6];
}
- (void)setBusinessTripDetailWithDictionary:(NSDictionary *)contentDic {
	self.lableNameLabel.text = contentDic[@"name"];
	self.valueLabel.attributedText = [YSUtility setUpLineSpaceWith:contentDic[@"content"] lineSpace:6];
	if ([contentDic[@"content"] isEqualToString:@"地址"] || [contentDic[@"content"] isEqualToString:@"备注"]) {
		if ([contentDic[@"content"] isEqualToString:@"地址"]) {
			self.lableNameLabel.textColor = kBlueColor;
		}else{
			self.lableNameLabel.textColor = kGrayColor(153);
		}
		
		self.valueLabel.hidden = YES;
		[_lableNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.contentView.mas_top).offset(12);
			make.left.mas_equalTo(self.contentView.mas_left).offset(15);
			make.width.mas_equalTo(SCREEN_WIDTH);
			//make.height.mas_equalTo(15*kHeightScale);
			make.bottom.mas_equalTo(-12);
		}];
	}else{
		_lableNameLabel.textColor = kGrayColor(51);
		self.valueLabel.hidden = NO;
		[_lableNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.contentView.mas_top).offset(12);
			make.left.mas_equalTo(self.contentView.mas_left).offset(15);
			make.width.mas_equalTo(100*kWidthScale);
			//make.height.mas_equalTo(15*kHeightScale);
			make.bottom.mas_equalTo(-12);
		}];
		
	}
}



/**新业务流程通用cell赋值*/
- (void)setCommonBusinessFlowDetailWithDictionary:(NSDictionary *)contentDic {
	
	NSString *title = contentDic[@"title"];
	
	if ([title containsString:@"*"]) {
		NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:contentDic[@"title"]];
		//找出特定字符在整个字符串中的位置
		NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
		NSString* str = NSStringFromRange(redRange);
		NSLog(@"%@", str);
		//修改特定字符的颜色
		[contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
		//修改特定字符的字体大小
		[contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange];
		[self.lableNameLabel setAttributedText:contentStr];
	}else{
		self.lableNameLabel.text = title;
	}
	
	
	NSString *content = contentDic[@"content"];
	if (content.length == 0) {
		content = @"    ";
	}
	
	self.valueLabel.attributedText = [YSUtility getAttributedStringWithString:content lineSpace:7];
	
	//根据类型设置UI
	BussinessFlowCellType cellType = [contentDic[@"special"] integerValue];
	
	if (cellType == BussinessFlowCellExtend) {//可展开cell
		self.extendButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.extendButton.userInteractionEnabled = NO;
		self.extendButton.selected = [contentDic[@"expand"] integerValue];
		[self.contentView addSubview:self.extendButton];
		[self.extendButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.contentView.mas_left).offset(330*kWidthScale);
			make.top.mas_equalTo(self.contentView.mas_top).offset(10);
			make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
			make.size.mas_equalTo(CGSizeMake(20*kWidthScale,20*kHeightScale));
		}];
		[self.extendButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
		[self.extendButton setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateSelected];
		
		
	}else {
		[self.extendButton removeFromSuperview];
		self.extendButton = nil;
	}
	
	
	if (cellType == BussinessFlowCellHead ) {
		
		
		self.lableNameLabel.textColor = [UIColor colorWithRed:25/255 green:31/255 blue:37/255 alpha:0.4];
		[_lableNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.contentView.mas_top).offset(12);
			make.left.mas_equalTo(self.contentView.mas_left).offset(15);
			make.right.mas_equalTo(-15);
			make.bottom.mas_equalTo(-12);
		}];
	}else{
		
		_lableNameLabel.textColor = [UIColor colorWithHexString:@"#191F25"];
		[_lableNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.contentView.mas_top).offset(12);
			make.left.mas_equalTo(self.contentView.mas_left).offset(15);
			make.width.mas_equalTo(110*kWidthScale);
			make.bottom.mas_equalTo(-12);
		}];
	}
	
	
	
	if (cellType == BussinessFlowCellTurn) {
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}else{
		self.accessoryType = UITableViewCellAccessoryNone;
		
	}
	
	//关于_valuelabel的约束变动
	if (cellType == BussinessFlowCellTurn) {
		self.valueLabel.textAlignment = NSTextAlignmentRight;
		self.valueLabel.textColor = [UIColor colorWithHexString:flowRightColor];
		self.valueLabel.font = [UIFont boldSystemFontOfSize:14];
		[self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(12);
			make.left.mas_equalTo(_lableNameLabel.mas_right).mas_equalTo(12);
			make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
		}];
	}else if (cellType == BussinessFlowCellExtend){//隐藏
		self.valueLabel.textAlignment = NSTextAlignmentRight;
		self.valueLabel.textColor = [UIColor colorWithHexString:flowRightColor];
		self.valueLabel.font = [UIFont boldSystemFontOfSize:14];
		[self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(12);
			make.left.mas_equalTo(self.contentView.mas_right).offset(0);
			make.right.mas_equalTo(self.contentView.mas_right).offset(0);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
		}];
	}else if (cellType == BussinessFlowCellText){
		self.lableNameLabel.text = nil;
		self.valueLabel.textColor = kGrayColor(51);
		self.valueLabel.textAlignment = NSTextAlignmentLeft;
		self.valueLabel.font = [UIFont systemFontOfSize:14];
		[self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(12);
			make.left.mas_equalTo(self.contentView.mas_left).offset(14);
			make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
		}];
		
	}else{//正常状态
		self.valueLabel.textAlignment = NSTextAlignmentRight;
		self.valueLabel.textColor = [UIColor colorWithHexString:flowRightColor];
		self.valueLabel.font = [UIFont boldSystemFontOfSize:14];
		[self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(12);
			make.left.mas_equalTo(_lableNameLabel.mas_right).mas_equalTo(12);
			make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
			make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
		}];
	}
	
	//对cell的背景颜色的判断
	if (cellType == BussinessFlowCellText || cellType == BussinessFlowCellNormal) {
		self.backgroundColor = UIColorWhite;
	}else if(cellType == BussinessFlowCellHead){//
		self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
	}else{
		self.backgroundColor = UIColorWhite;
	}
	
	
}
@end
