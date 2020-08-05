//
//  YSPerfInfoMidCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfInfoMidCell.h"

@interface YSPerfInfoMidCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YSPerfInfoMidCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(18*kHeightScale);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.00];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.left.right.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
}

- (void)setCellModel:(YSPerfInfoModel *)cellModel indexPath:(NSIndexPath *)indexPath {
    _cellModel = cellModel;

    NSArray *titleArray = @[@"内容", @"自评", @"评估"];

    _titleLabel.text = titleArray[indexPath.row - 1];
    if (indexPath.row != 3) {
        _cellModel.achieveGoal = [_cellModel.achieveGoal stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        _cellModel.achieveGoal = [_cellModel.achieveGoal stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        _cellModel.selfRating = [_cellModel.selfRating stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        _cellModel.selfRating = [_cellModel.selfRating stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        _contentLabel.text = indexPath.row == 1 ? _cellModel.achieveGoal : _cellModel.selfRating;
    } else {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
        DLog(@"=======%@",_cellModel.examScoreVoList);
        for (YSPerfSubInfoModel *subInfoModel in _cellModel.examScoreVoList) {
            DLog(@"-----%@========%@",subInfoModel.score,subInfoModel.scoreRemark);
            NSMutableAttributedString *text;
            if (self.index == 3 || self.index == 1) {
                text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评估人 %@    权重 %@%%    \n\n", subInfoModel.evaluatorName, subInfoModel.weight]];
            }else{
                
                text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评估人 %@    权重 %@%%    评分 %@\n评分说明\n%@\n\n", subInfoModel.evaluatorName, subInfoModel.weight, subInfoModel.score, subInfoModel.scoreRemark]];
                [text yy_setColor:[UIColor redColor] range:NSMakeRange(18+subInfoModel.evaluatorName.length+subInfoModel.weight.length, subInfoModel.score.length+1)];
            }
            text.yy_font = [UIFont systemFontOfSize:15];
            [text yy_setColor:[UIColor redColor] range:NSMakeRange(4, subInfoModel.evaluatorName.length)];
            [text yy_setColor:[UIColor redColor] range:NSMakeRange(11+subInfoModel.evaluatorName.length, subInfoModel.weight.length+1)];
            
            [mutableAttributedString appendAttributedString:text];
        }
        _contentLabel.attributedText = [mutableAttributedString copy];
    }
}

- (void)setPlanCellModel:(YSPerfInfoModel *)cellModel indexPath:(NSIndexPath *)indexPath {
    _cellModel = cellModel;
    NSArray *titleArray = @[@"内容", @"评估"];
    
    _titleLabel.text = titleArray[indexPath.row - 1];
    if (indexPath.row != 2) {
        _cellModel.achieveGoal = [_cellModel.achieveGoal stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        _cellModel.achieveGoal = [_cellModel.achieveGoal stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        _cellModel.selfRating = [_cellModel.selfRating stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        _cellModel.selfRating = [_cellModel.selfRating stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        _contentLabel.text = indexPath.row == 1 ? _cellModel.achieveGoal :   _cellModel.selfRating;
    } else {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
        for (YSPerfSubInfoModel *subInfoModel in _cellModel.examScoreVoList) {
            NSMutableAttributedString *text;
            if (self.index == 3 || self.index == 1) {
                text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评估人 %@    权重 %@%%    \n\n", subInfoModel.evaluatorName, subInfoModel.weight]];
            }else{
                text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评估人 %@    权重 %@%%    评分 %@\n评分说明\n%@\n\n", subInfoModel.evaluatorName, subInfoModel.weight, subInfoModel.score, subInfoModel.scoreRemark]];
                [text yy_setColor:[UIColor redColor] range:NSMakeRange(18+subInfoModel.evaluatorName.length+subInfoModel.weight.length, subInfoModel.score.length+1)];
            }
            text.yy_font = [UIFont systemFontOfSize:15];
            [text yy_setColor:[UIColor redColor] range:NSMakeRange(4, subInfoModel.evaluatorName.length)];
            [text yy_setColor:[UIColor redColor] range:NSMakeRange(11+subInfoModel.evaluatorName.length, subInfoModel.weight.length+1)];
            
            [mutableAttributedString appendAttributedString:text];
        }
        _contentLabel.attributedText = [mutableAttributedString copy];
    }
}


@end
