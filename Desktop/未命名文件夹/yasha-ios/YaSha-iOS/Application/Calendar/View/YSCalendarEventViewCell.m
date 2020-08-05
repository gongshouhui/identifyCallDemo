//
//  YSCalendarEventViewCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/9.
//

#import "YSCalendarEventViewCell.h"

@interface YSCalendarEventViewCell()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YSCalendarEventViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(2);
        make.left.mas_equalTo(self.contentView.mas_left).offset(2);
        make.height.mas_equalTo(12*kHeightScale);
        make.width.mas_equalTo(30*kWidthScale);
    }];
}

- (void)setTimeWithIndexPath:(NSIndexPath *)indexPath withLine:(BOOL)line {
    _timeLabel.text = indexPath.row == 0 ? @"全天" : [NSString stringWithFormat:@"%.2zd:00", indexPath.row - 1];
    if (line) {
        for (int i = 0; i < 8; i ++) {
            UILabel *lineLabel = [[UILabel alloc] init];
            lineLabel.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00];
            [self.contentView addSubview:lineLabel];
            [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView);
                make.left.mas_equalTo(2+30*kWidthScale+(kSCREEN_WIDTH-4-60*kWidthScale)/7*i);
                make.bottom.mas_equalTo(self.contentView);
                make.width.mas_equalTo(0.5);
            }];
        }
    }
}

@end
