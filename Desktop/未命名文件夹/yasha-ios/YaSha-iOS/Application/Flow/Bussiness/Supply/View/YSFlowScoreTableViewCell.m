//
//  YSFlowScoreTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/23.
//

#import "YSFlowScoreTableViewCell.h"

@interface YSFlowScoreTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation YSFlowScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 20*kHeightScale));
    }];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(25);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = kGrayColor(224);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    self.lineView.hidden = YES;
    
}

- (void)setFlowScoreData:(NSArray *)contentArray andIndexPath:(NSIndexPath *)indexPath{
    NSArray * arr = @[@"考评模板",@"权重",@"考评日期",@"综合评估",@"考评评分"];
    _titleLabel.text = arr[indexPath.row%5];
    
    _contentLabel.text = contentArray[indexPath.row];
    if (indexPath.row%5==0) {
        _contentLabel.textColor = kUIColor(42, 138, 219, 1.0);
    }
}
- (void)setFlowScoreDataWithLine:(NSArray *)contentArray andIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * arr = @[@"考评模板",@"权重",@"复察日期",@"综合评估",@"复察评分"];
    _titleLabel.text = arr[indexPath.row%5];
    
    _contentLabel.text = contentArray[indexPath.row];
    if (indexPath.row%5==0) {
        _contentLabel.textColor = kUIColor(42, 138, 219, 1.0);
    }
    //
    if (indexPath.row%5 == 4&&indexPath.row != contentArray.count - 1) {
        self.lineView.hidden = NO;
    }else{
        self.lineView.hidden = YES;
    }
    if (_contentLabel.text.length == 0) {
        _contentLabel.text = @"    ";
    }
    
}
- (void)setExpenseDetailWithData:(NSArray *)contentArray andIndexPath:(NSIndexPath *)indexPath {
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 20*kHeightScale));
    }];
    //字典无序
    NSDictionary *contentDic = contentArray[indexPath.row];
    NSString *title = contentDic[@"name"];
    NSString *content = contentDic[@"content"];
    if ([title isEqualToString:@"发票号码"]) {
        self.contentLabel.textColor = kUIColor(42, 138, 219, 1);
    }else if ([title isEqualToString:@"警告"]) {
        self.contentLabel.textColor = kUIColor(239, 60, 60, 1);
    }else{
        self.contentLabel.textColor =  kGrayColor(153);
    }
    
    if (content.length == 0) {
        content = @"-   ";
    }
    if ([content containsString:@"￥"]) {
        content = [YSUtility positiveFormat:[content stringByReplacingOccurrencesOfString:@"￥" withString:@""]];
        content = [NSString stringWithFormat:@"￥%@",content];
    }
    self.titleLabel.text = title;
    self.contentLabel.text  = content;
    //
    if ([contentDic[@"end"] integerValue] && indexPath.row != contentArray.count - 1) {
        self.lineView.hidden = NO;
    }else{
        self.lineView.hidden = YES;
    }
}

- (void)setInvoiceDic:(NSDictionary *)invoiceDic {
    _invoiceDic = invoiceDic;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(70*kWidthScale);
        make.bottom.mas_equalTo(-10);
    }];

    self.titleLabel.text = invoiceDic[@"name"];
    self.contentLabel.text = invoiceDic[@"content"];
    if (self.contentLabel.text.length == 0) {
        self.contentLabel.text = @"    ";
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
