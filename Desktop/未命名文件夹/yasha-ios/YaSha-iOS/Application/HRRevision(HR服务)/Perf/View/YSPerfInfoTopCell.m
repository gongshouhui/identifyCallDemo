//
//  YSPerfInfoTopCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfInfoTopCell.h"

@interface YSPerfInfoTopCell ()

@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *workItemLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YSPerfInfoTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _weightLabel = [[UILabel alloc] init];
    _weightLabel.textColor = [UIColor whiteColor];
    _weightLabel.textAlignment = NSTextAlignmentCenter;
    _weightLabel.font = [UIFont systemFontOfSize:20];
    _weightLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.76 blue:0.30 alpha:1.00];
    _weightLabel.layer.masksToBounds = YES;
    _weightLabel.layer.cornerRadius = 20*kWidthScale;
    [self.contentView addSubview:_weightLabel];
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 40*kHeightScale));
    }];
    
    _workItemLabel = [[UILabel alloc] init];
    _workItemLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:_workItemLabel];
    [_workItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.left.mas_equalTo(_weightLabel.mas_right).offset(10);
        make.height.mas_equalTo(18*kHeightScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_workItemLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_weightLabel.mas_right).offset(10);
        make.height.mas_equalTo(18*kHeightScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)setCellModel:(YSPerfInfoModel *)cellModel{
    _cellModel = cellModel;
    if (self.index == 2 ) {
        _weightLabel.text = _cellModel.contentWeight;
        _nameLabel.text = _cellModel.personName;
    }else if (self.index == 1){
        _weightLabel.text = _cellModel.weight;
        _nameLabel.text = _cellModel.examContentForPortal[@"personName"];
    }else if(self.index == 3){
        _weightLabel.text = _cellModel.weight;
        _nameLabel.text = _cellModel.planPerson[@"personName"];
    }else{
         _weightLabel.text = _cellModel.weight;
         _nameLabel.text = _cellModel.examContentForPortal[@"personName"];
    }
    _cellModel.workItem = [_cellModel.workItem stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
    _cellModel.workItem = [_cellModel.workItem stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    _workItemLabel.text = _cellModel.workItem;
    
}

@end
