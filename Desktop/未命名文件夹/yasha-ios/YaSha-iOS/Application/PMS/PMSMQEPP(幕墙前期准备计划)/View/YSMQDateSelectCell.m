//
//  YSMQDateSelectCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQDateSelectCell.h"
@interface YSMQDateSelectCell()<PGDatePickerDelegate>
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detaillb;
@property (nonatomic,strong) PGDatePicker *datePicker;
@end
@implementation YSMQDateSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
-(void)initUI {
    self.titleLb = [[UILabel alloc] init];
    self.titleLb .font = [UIFont systemFontOfSize:15];
    self.titleLb .textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.titleLb .textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
    }];
    self.detaillb = [UILabel new];
    self.detaillb .font = [UIFont systemFontOfSize:15];
    self.detaillb .textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.detaillb .textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.detaillb];
    [self.detaillb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    YSWeak;
  
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        PGDatePicker *datePicker = [[PGDatePicker alloc] init];
        datePicker.delegate = weakSelf;
        datePicker.datePickerMode = PGDatePickerModeDate;
        [datePicker showWithShadeBackgroud];
    }];
  
}


#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    switch (datePicker.datePickerMode) {
  
        case PGDatePickerModeDate:
        {
            NSString *text = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
            self.detaillb.text = text;
            if (self.dateBlock) {
                self.dateBlock(text);
            }
            
            break;
        }
        default:
        {
            self.detaillb.text = @"";
            if (self.dateBlock) {
                self.dateBlock(@"");
            }
            break;
        }
    }
}
- (void)setDataForCell:(YSMQCellModel *)model {
    if ([model.title containsString:@"*"]) {
        NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:model.title];
        [attiStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[model.title rangeOfString:@"*"]];
        self.titleLb.attributedText = attiStr;
    }else{
       self.titleLb.text = model.title;
    }
  
    self.detaillb.text = model.content;
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
