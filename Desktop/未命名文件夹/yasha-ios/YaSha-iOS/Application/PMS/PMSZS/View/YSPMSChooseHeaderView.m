//
//  YSPMSChooseHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/9.
//
//

#import "YSPMSChooseHeaderView.h"

@implementation YSPMSChooseHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setFilterTitle:(NSString *)title andIndex:(NSInteger)index{
    _titleLab = [[UILabel alloc]init];
    _titleLab.backgroundColor = [UIColor whiteColor];
    _titleLab.userInteractionEnabled = YES;
    _titleLab.frame = CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height);
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.numberOfLines = 0;
    _titleLab.text = title;
    _titleLab.tag = index;
    _titleLab.textColor = kUIColor(85, 85, 85, 1.0);
    _titleLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLab];
}

@end
