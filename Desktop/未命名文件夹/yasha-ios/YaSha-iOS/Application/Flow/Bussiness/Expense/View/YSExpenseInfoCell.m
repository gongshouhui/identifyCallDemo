//
//  YSExpenseInfoCell.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseInfoCell.h"
#import "YSHRPersonalInfoCell.h"
@implementation YSExpenseInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
//    YSDetailItemView *lastView = nil;
//    for (int i = 0; i < 9; i++) {
//        YSDetailItemView *itemView = [[YSDetailItemView alloc]init];
//        [self.contentView addSubview:itemView];
//        itemView.titleLb.text = @"fjdhfhdhfhdhfhdhfhdhf";
//        itemView.detailLb.text = @"dfsrrrwrwewewewewe";
//        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (i == 0) {
//                make.top.mas_equalTo(15);
//            }else {
//                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
//            }
//            make.left.right.mas_equalTo(0);
//            if (i == 9) {
//                make.bottom.mas_equalTo(-15);
//            }
//        }];
//        lastView = itemView;
//        
//    }
}
- (void)setInfoModel:(YSCostInfoModelDetail *)infoModel {
    _infoModel = infoModel;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@{@"name":@"货物或应税劳务、服务名称",@"value":infoModel.name}];
    [array addObject:@{@"name":@"规格型号",@"value":infoModel.specModel}];
    [array addObject:@{@"name":@"单位",@"value":infoModel.unit}];
    if (infoModel.amount > 0) {
        [array addObject:@{@"name":@"数量",@"value":[NSString stringWithFormat:@"%ld",infoModel.amount]}];
    }else{
        [array addObject:@{@"name":@"数量",@"value":@"-   "}];
    }
    
    if (infoModel.unitPrice > 0) {
       [array addObject:@{@"name":@"单价",@"value":[NSString stringWithFormat:@"￥%.2f",infoModel.unitPrice]}];
    }else{
        [array addObject:@{@"name":@"单价",@"value":@"-   "}];
    }
    if (infoModel.exTaxAmount > 0) {
        [array addObject:@{@"name":@"不含税金额",@"value":[NSString stringWithFormat:@"￥%.2f",infoModel.exTaxAmount]}];
    }else{
        [array addObject:@{@"name":@"不含税金额",@"value":@"-   "}];
    }
    [array addObject:@{@"name":@"税率",@"value":infoModel.taxRate}];
    if (infoModel.actualTax > 0) {
        [array addObject:@{@"name":@"税额",@"value":[NSString stringWithFormat:@"￥%.2f",infoModel.actualTax]}];
    }else{
        [array addObject:@{@"name":@"税额",@"value":@"-   "}];
    }
    if (infoModel.taxAmountTatol > 0) {
        [array addObject:@{@"name":@"价税金额",@"value":[NSString stringWithFormat:@"￥%.2f",infoModel.taxAmountTatol]}];
    }else{
        [array addObject:@{@"name":@"价税金额",@"value":@"-   "}];
    }
    YSDetailItemView *lastView = nil;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        YSDetailItemView *itemView = [[YSDetailItemView alloc]init];
        [self.contentView addSubview:itemView];
        itemView.titleLb.text = dic[@"name"];
        itemView.detailLb.text = dic[@"value"];
        if (itemView.detailLb.text.length == 0) {
            itemView.detailLb.text = @"-   ";
        }
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.mas_equalTo(15);
            }else {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
            }
            make.left.right.mas_equalTo(0);
            if (i == array.count - 1) {
                make.bottom.mas_equalTo(-15);
            }
        }];
        lastView = itemView;
        
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@implementation YSDetailItemView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.numberOfLines = 0;
    self.titleLb.font = [UIFont systemFontOfSize:14];
    self.titleLb.textColor = kUIColor(153, 153, 153, 1);
    [self addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100*kWidthScale);
        make.left.mas_equalTo(15);
        
    }];
    
    self.detailLb = [[UILabel alloc]init];
    self.detailLb.font = [UIFont systemFontOfSize:14];
    self.detailLb.textColor = kUIColor(51, 51, 51, 1);
    self.detailLb.numberOfLines = 0;
    [self addSubview:self.detailLb];
    
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_titleLb.mas_right).mas_equalTo(30*kWidthScale);
        make.right.mas_equalTo(-15);
    }];
}
@end

