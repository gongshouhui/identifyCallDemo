//
//  YSFormOptionsCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormOptionsCell.h"

@interface YSFormOptionsCell ()

@property (nonatomic, strong) QMUIAlertController *alertController;
@property (nonatomic,assign) BOOL isShow;
@end

@implementation YSFormOptionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    [self addDetailLabel];
	//为cell添加手势
	UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
	[self addGestureRecognizer:tapGes];
}
- (void)tapAction {
	if (!self.cellModel.disable) {
		QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
			 QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
			 }];
			 [alertController addAction:action0];
			
			 for (int i = 0; i < self.cellModel.optionsDataArray.count; i ++) {
				
				 NSDictionary *dic = self.cellModel.optionsDataArray[i];
				  YSWeak;
				 QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:[dic allValues][0] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
					 //选择后直接为cell复制，并修改了model里面的z值
					 weakSelf.cellModel.detailTitle = [dic allValues][0];
					 weakSelf.detailLabel.text = [dic allValues][0];
					 //将选择的内容传回去
					 [weakSelf.sendOptionsSubject sendNext:@{[dic allKeys][0] : [dic allValues][0]}];
					
					 
					 
				 }];
				 [alertController addAction:action];
			 }
		
		
			   [alertController showWithAnimated:YES];
		   }
}
- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
    self.detailTextLabel.text = self.cellModel.detailTitle;
	
}
//#pragma mark - 用户选中cell时被调用
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    if (self.selected == selected) return;//防止多点
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        if (!self.cellModel.disable) {
//            [self.alertController showWithAnimated:YES];
//        }
//        self.selected = NO;
//    }
//}
- (void)dealloc {
   
}
@end
