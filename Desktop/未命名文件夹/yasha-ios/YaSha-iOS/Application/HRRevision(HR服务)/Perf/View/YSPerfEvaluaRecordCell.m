//
//  YSPerfEvaluaRecordCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/21.
//

#import "YSPerfEvaluaRecordCell.h"

@interface YSPerfEvaluaRecordCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *reasonLabel;

@end

@implementation YSPerfEvaluaRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:20];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.backgroundColor = kThemeColor;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.cornerRadius = 18*kWidthScale;
    [self.contentView addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(36*kWidthScale, 36*kHeightScale));
    }];
    
    _reasonLabel = [[UILabel alloc] init];
    _reasonLabel.text = @"原因说明";
    _reasonLabel.font = [UIFont systemFontOfSize:13];
    _reasonLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_reasonLabel];
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_typeLabel.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 14*kHeightScale));
    }];
    
    _remarkLabel = [[UILabel alloc] init];
    _remarkLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_remarkLabel];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_typeLabel.mas_top);
        make.left.mas_equalTo(_typeLabel.mas_right).offset(9);
        make.right.mas_equalTo(_reasonLabel.mas_left).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    _createTimeLabel = [[UILabel alloc] init];
    _createTimeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_createTimeLabel];
    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_typeLabel.mas_bottom);
        make.left.mas_equalTo(_remarkLabel.mas_left).offset(6);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)setCellModel:(YSPerfEvaluaRecordModel *)cellModel {
    _cellModel = cellModel;
    _remarkLabel.text = _cellModel.remark;
    _createTimeLabel.text = _cellModel.createTime;
    NSArray *typeArray = @[@"", @"制", @"审", @"评", @"评", @"退", @"申", @"确", @"退", @"改", @"评", @"拒"];
    _typeLabel.text = typeArray[_cellModel.type/10];
    DLog(@"=============%ld",(long)_cellModel.type);
    if (!_cellModel.rebackReason) {
        [_reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_typeLabel.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
}

@end
