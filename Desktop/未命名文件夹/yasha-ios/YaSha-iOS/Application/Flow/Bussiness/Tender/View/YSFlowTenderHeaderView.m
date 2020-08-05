//
//  YSFlowTenderHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/23.
//

#import "YSFlowTenderHeaderView.h"

@interface YSFlowTenderHeaderView ()

@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIImageView *companyImageView;
@property (nonatomic, strong) UILabel *moneyLabel;

@end
@implementation YSFlowTenderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _companyImageView = [[UIImageView alloc]init];
    _companyImageView.image = [UIImage imageNamed:@"公司"];
    [self addSubview:_companyImageView];
    [_companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.left.mas_equalTo(self.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(13*kWidthScale, 13*kHeightScale));
    }];
    
    _companyLabel = [[UILabel alloc]init];
    _companyLabel.text = @"杭州丽居木业有限公司";
    _companyLabel.numberOfLines = 0;
    _companyLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_companyLabel];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.left.mas_equalTo(_companyImageView.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(240*kWidthScale, 14*kHeightScale));
    }];
    
//    _moneyLabel = [[UILabel alloc]init];
//    _moneyLabel.text = @"46.5万";
//    _moneyLabel.textAlignment = NSTextAlignmentRight;
//    _moneyLabel.font = [UIFont systemFontOfSize:13];
//    _moneyLabel.textColor = kUIColor(42, 138, 219, 1.0);
//    [self addSubview:_moneyLabel];
//    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(17);
//        make.right.mas_equalTo(self.mas_right).offset(-26);
//        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 13*kHeightScale));
//    }];
    
    _dropDownImageView = [[UIImageView alloc]init];
    _dropDownImageView.image = [UIImage imageNamed:@"向右箭头"];
    [self addSubview:_dropDownImageView];
    [_dropDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(11*kWidthScale, 18*kHeightScale));
    }];
    
    _levelLabel = [[UILabel alloc]init];
    _levelLabel.text = @"A级 CNY";
    _levelLabel.font = [UIFont systemFontOfSize:11];
    _levelLabel.textColor = [UIColor grayColor];
    [self addSubview:_levelLabel];
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_companyLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(_companyImageView.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 11*kHeightScale));
    }];
    
    _unitLabel = [[UILabel alloc]init];
    _unitLabel.font = [UIFont systemFontOfSize:11];
    _unitLabel.textColor = [UIColor grayColor];
    [self addSubview:_unitLabel];
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_companyLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.levelLabel.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(11);
    }];
}

- (void)setFlowTenderHeaderData:(NSDictionary *)dic andIsspread:(NSString *)spreadStr{
    if ([spreadStr isEqual:@"1"]) {
        _dropDownImageView.image = [UIImage imageNamed:@"向下箭头"];
        [_dropDownImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(17);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(18*kWidthScale, 11*kHeightScale));
        }];
        
    }
 
    _companyLabel.text = dic[@"franName"];
    NSString *str = nil;
    if ([dic[@"currency"] isEqual:@"registerCNY"]) {
        str = @"人民币";
    }else if ([dic[@"currency"] isEqual:@"registerUSD"]){
        str = @"美元";
    }
    else if ([dic[@"currency"] isEqual:@"Mark"]){
        str = @"马克";
        
    }else if ([dic[@"currency"] isEqual:@"123"]){
        str = @"港币";
    }else {
        str = @"其他币种";
    }
    _levelLabel.text = [NSString stringWithFormat:@"%@%@   %@",dic[@"admitLevel"],(dic[@"admitLevel"] == nil || [dic[@"admitLevel"] isEqual:@""]|| [dic[@"admitLevel"] isEqual:[NSNull null]])?@"":@"级",str];
    _unitLabel.text = [NSString stringWithFormat:@"推荐单位:%@",dic[@"recommendBy"]];
}


@end
