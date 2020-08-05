//
//  YSPMSClickCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import "YSPMSClickCell.h"

@interface YSPMSClickCell ()



@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation YSPMSClickCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.chooseBtn = [[UIButton alloc]init];
        self.chooseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.chooseBtn.backgroundColor = kUIColor(240, 240, 240, 1.0);
//        //设置button文字的位置
//        self.chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        //调整与边距的距离
//        self.chooseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -25);
        
        [self.chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.chooseBtn];
        [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 30*kHeightScale));
        }];
        
        _textLabel =[[UILabel alloc]init];
        _textLabel.backgroundColor = kUIColor(240, 240, 240, 1.0);
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:12];
        [self.chooseBtn addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(45*kWidthScale, 20*kHeightScale));
        }];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"下拉"];
        [self.chooseBtn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
            make.left.mas_equalTo(_textLabel.mas_right).offset(3);
            make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 8*kWidthScale));
        }];
    }
    return self;
}
-(void)setFilterIndexPath:(NSIndexPath *)indexPath andFilter:(BOOL)isFilter andTitleAry:(NSArray *)titleAry{
    _textLabel.text = titleAry[indexPath.section][indexPath.row] ;

}

@end
