//
//  YSChoosePeopleView.m
//  YaSha-iOS
//
//  Created by mHome on 2016/12/2.
//
//

#import "YSChoosePeopleView.h"

@implementation YSChoosePeopleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
        [self initUi];
    }
    return self;
}
-(void) initUi
{
    self.numLabel  = [[UILabel alloc]init];
    self.numLabel.font = [UIFont systemFontOfSize:15];
    self.numLabel.textColor = [UIColor blackColor];
    self.numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel.text = @"共选择0人";
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(13);
        make.left.mas_equalTo(self.mas_left).offset(182*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 14*kHeightScale));
    }];
    
    self.chooseButton = [[UIButton alloc]init];
    [self.chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    self.chooseButton.backgroundColor = [UIColor blueColor];
    self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.chooseButton];
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.numLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 30*kHeightScale));
    }];
    
    
    self.allChooseButton = [[QMUIButton alloc]init];
    [self.allChooseButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self.allChooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.allChooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.allChooseButton.selected = NO;
    self.allChooseButton.imagePosition = QMUIButtonImagePositionLeft;
    self.allChooseButton.spacingBetweenImageAndTitle = 5;
    [self.allChooseButton setTitle:@"全选" forState:UIControlStateNormal];
    [self addSubview:self.allChooseButton];
    [self.allChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(80*kWidthScale, 28*kHeightScale));
    }];
   
}
@end
