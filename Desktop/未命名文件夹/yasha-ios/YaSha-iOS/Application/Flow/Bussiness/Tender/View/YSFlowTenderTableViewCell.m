//
//  YSFlowTenderTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/20.
//

#import "YSFlowTenderTableViewCell.h"

@interface YSFlowTenderTableViewCell ()

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIImageView *pointImage;
@property (nonatomic, strong) UILabel *lineLbale;
@property (nonatomic, strong) UILabel *priceLbale;
@property (nonatomic, strong) UILabel *threeLevelLbale;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic,strong) UILabel *contractNum;

@end

@implementation YSFlowTenderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _scrollview = [[UIScrollView alloc]init];
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scrollview];
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 40*kHeightScale));
    }];
	
	_contractNum = [[UILabel alloc]init];
	_contractNum.numberOfLines = 0;
	_contractNum.font = [UIFont systemFontOfSize:13];
	[self.contentView addSubview:_contractNum];
	[_contractNum mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(_scrollview.mas_bottom).offset(10);
		make.left.mas_equalTo(self.contentView.mas_left).offset(15);
		make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
	}];
	
	_remarkLabel = [[UILabel alloc]init];
	_remarkLabel.numberOfLines = 0;
	_remarkLabel.font = [UIFont systemFontOfSize:13];
	_remarkLabel.text = @"备注：如果你无法简洁的表达你的想法，那只说明你还不够了解它。";
	[self.contentView addSubview:_remarkLabel];
	[_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(_contractNum.mas_bottom).offset(10);
		make.left.mas_equalTo(self.contentView.mas_left).offset(15);
		make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
		make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
	}];
	
	
	
}

- (void)setFlowTenderData:(NSDictionary *)dic  {
    DLog(@"=======%@",dic);
    NSArray *arr = @[@"onePrice",@"twoPrice",@"threePrice",@"fourPrice",@"fivePrice",@"sixPrice",@"sevenPrice",@"eightPrice",@"ninePrice",@"tenPrice",@"elevenPrice",@"twelvePrice",@"thirteenPrice",@"fourteenPrice",@"fifteenPrice",@"sixteenPrice",@"seventeenPrice",@"eighteenPrice",@"nineteenPrice",@"twentyPrice"];
    _scrollview.contentSize = CGSizeMake((83*[dic[@"count"] intValue]+70)*kWidthScale, 0);
    if ([dic[@"count"] intValue] - 4 > 0) {
        [_scrollview setContentOffset:CGPointMake((([dic[@"count"] intValue] -4)*65)*kWidthScale,0) animated:YES];
    }else {
        [_scrollview setContentOffset:CGPointMake(0,0) animated:YES];
    }
    
    
    for (id view in _scrollview.subviews) {
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < [dic[@"count"] intValue]; i ++) {
        
        _pointImage = [[UIImageView alloc]init];
        _pointImage.image = [UIImage imageNamed:@"椭圆4"];
        [_scrollview addSubview:_pointImage];
        [_pointImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_scrollview.mas_top).offset(5);
            make.left.mas_equalTo(_scrollview.mas_left).offset((35 + 90*i)*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(11*kWidthScale, 11*kHeightScale));
        }];
        
        
        _lineLbale = [[UILabel alloc] init];
        _lineLbale.backgroundColor = kUIColor(42, 138, 219, 1);
        [_scrollview addSubview:_lineLbale];
        [_lineLbale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_scrollview.mas_top).offset(10);
            make.left.mas_equalTo(_scrollview.mas_left).offset((48+90 * (i > 5?(i-1):i))*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(75*kWidthScale, 1*kHeightScale));
        }];
        
        _priceLbale = [[UILabel alloc] init];
        if (![dic[arr[i]] isEqual:[NSNull null]]) {
            if ([dic[arr[i]] intValue] != -1) {
                _priceLbale.text = [NSString stringWithFormat:@"%@",dic[arr[i]]] ;
            }else{
                _priceLbale.text = @"/";
            }
        }
        _priceLbale.textAlignment = NSTextAlignmentCenter;
        _priceLbale.textColor = kUIColor(42, 138, 219, 1.0);
        _priceLbale.font = [UIFont systemFontOfSize:10.5];
        _priceLbale.adjustsFontSizeToFitWidth = YES;
        [_scrollview addSubview:_priceLbale];
        [_priceLbale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_pointImage.mas_bottom).offset(8);
            make.left.mas_equalTo(_scrollview.mas_left).offset((15 + 83*i)*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(85*kWidthScale, 12*kHeightScale));
        }];
    }
    [_lineLbale removeFromSuperview];
	_contractNum.text = [NSString stringWithFormat:@"合同编码：%@",[dic[@"contractNum"] length] > 0 ? dic[@"contractNum"] : @"   "];
    _remarkLabel.text = [NSString stringWithFormat:@"备注:%@",dic[@"remark"]] ;
    
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

