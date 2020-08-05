//
//  YSFormDatePickerCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormDatePickerCell.h"

@interface YSFormDatePickerCell ()<PGDatePickerDelegate>
@property (nonatomic,assign) BOOL isShow;
@end

@implementation YSFormDatePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
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

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
}
- (void)tapAction {
	if (self.cellModel.disable) {
        return;
    }
	if (!self.isShow) {
		PGDatePicker *datePicker = [[PGDatePicker alloc] init];
			   datePicker.delegate = self;
			   [datePicker showWithShadeBackgroud];
			   datePicker.minimumDate = self.cellModel.minimumDate;
			   datePicker.maximumDate = self.cellModel.maximumDate;
			   datePicker.datePickerMode = self.cellModel.datePickerMode;
			   self.isShow = NO;
	}
}


#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    switch (datePicker.datePickerMode) {
        case PGDatePickerModeYear:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%zd", dateComponents.year];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%zd", dateComponents.year]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%zd", dateComponents.year];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeYearAndMonth:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%zd-%zd", dateComponents.year, dateComponents.month];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%zd-%zd", dateComponents.year, dateComponents.month]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%zd-%zd", dateComponents.year, dateComponents.month];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeDate:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeDateHourMinute:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeDateHourMinuteSecond:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd:%.2zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd:%.2zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd:%.2zd", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeTime:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%.2zd:%.2zd", dateComponents.hour, dateComponents.minute];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%.2zd:%.2zd", dateComponents.hour, dateComponents.minute]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%.2zd:%.2zd", dateComponents.hour, dateComponents.minute];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeTimeAndSecond:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%.2zd:%.2zd:%.2zd", dateComponents.hour, dateComponents.minute, dateComponents.second];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%.2zd:%.2zd:%.2zd", dateComponents.hour, dateComponents.minute, dateComponents.second]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%.2zd:%.2zd:%.2zd", dateComponents.hour, dateComponents.minute, dateComponents.second];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        case PGDatePickerModeDateAndTime:
        {
            self.detailLabel.text = [NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd", dateComponents.month, dateComponents.day, dateComponents.weekday, dateComponents.hour, dateComponents.minute];
            [self.sendValueSubject sendNext:[NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd", dateComponents.month, dateComponents.day, dateComponents.weekday, dateComponents.hour, dateComponents.minute]];
            YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
            formCellModel.value = [NSString stringWithFormat:@"%zd-%zd-%zd %.2zd:%.2zd", dateComponents.month, dateComponents.day, dateComponents.weekday, dateComponents.hour, dateComponents.minute];
            formCellModel.indexPath = self.cellModel.indexPath;
            [self.sendFormCellModelSubject sendNext:formCellModel];
            break;
        }
        default:
        {
            self.detailLabel.text = @"";
            break;
        }
    }
    self.cellModel.detailTitle = self.detailLabel.text;
}

@end
