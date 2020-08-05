//
//  YSFormMultipleSelectCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/19.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormMultipleSelectCell.h"

@interface YSFormMultipleSelectCell ()

@property (nonatomic, strong) QMUIDialogSelectionViewController *dialogViewController;

@end

@implementation YSFormMultipleSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    [self addDetailLabel];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
    YSWeak;
    _dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    _dialogViewController.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    _dialogViewController.title = @"";
    _dialogViewController.titleView.subtitle = @"";
    _dialogViewController.allowsMultipleSelection = YES;
    if (cellModel.selectedItemIndexes.count) {//已有选择
        _dialogViewController.selectedItemIndexes = cellModel.selectedItemIndexes;
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in cellModel.optionsDataArray) {
        [mutableArray addObject:[dic allValues][0]];
    }
    _dialogViewController.items = [mutableArray copy];
    _dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
    };
    
    [_dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [_dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *dialogViewController = (QMUIDialogSelectionViewController *)aDialogViewController;
        [dialogViewController hide];
        NSMutableString *mutableValueString = [NSMutableString string];
        NSMutableString *mutableKeyString = [NSMutableString string];
        NSMutableArray *selectedItemIndexes = [NSMutableArray array];
        for (NSNumber *i in dialogViewController.selectedItemIndexes) {
            int index = [i intValue];
            [selectedItemIndexes addObject:[NSString stringWithFormat:@"%d", index]];
        }
        
        for (int i = 0; i < selectedItemIndexes.count; i ++) {
            NSInteger index = [selectedItemIndexes[i] integerValue];
            NSDictionary *dic = cellModel.optionsDataArray[index];
            [mutableKeyString appendString:[NSString stringWithFormat:i == 0 ? @"%@" : @",%@", [dic allKeys][0]]];
            [mutableValueString appendString:[NSString stringWithFormat:i == 0 ? @"%@" : @",%@", [dic allValues][0]]];
            [mutableArray addObject:dic];
        }
		[weakSelf.sendValueSubject sendNext:mutableKeyString];//参数回调
        weakSelf.detailLabel.text = mutableValueString;
		
        cellModel.detailTitle = mutableValueString;
        YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
        formCellModel.key = mutableKeyString;
        formCellModel.value = mutableValueString;
        formCellModel.indexPath = weakSelf.cellModel.indexPath;
        [weakSelf.sendFormCellModelSubject sendNext:formCellModel];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) return;
    [super setSelected:selected animated:animated];
    if (selected) {
        if (!self.cellModel.disable) {
            [_dialogViewController show];
        }
        self.selected = NO;
    }
}

@end
