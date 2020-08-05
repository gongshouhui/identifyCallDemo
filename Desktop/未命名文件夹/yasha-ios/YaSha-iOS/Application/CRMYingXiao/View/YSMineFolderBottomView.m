//
//  YSMineFolderBottomView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMineFolderBottomView.h"

@interface YSMineFolderBottomView ()
@property (nonatomic, strong) UIImageView *choseImg;
@property (nonatomic, assign) BOOL isChose;

@end

@implementation YSMineFolderBottomView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    // 全选按钮
    self.choseBtn = [[QMUIButton alloc]init];
    self.choseBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self.choseBtn addTarget:self action:@selector(clickedAllChoseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.choseBtn setTitle:@"全选" forState:(UIControlStateNormal)];
    [self.choseBtn setTitleColor:[UIColor colorWithHexString:@"#858B9C"] forState:UIControlStateNormal];
    [self.choseBtn setImage:[UIImage imageNamed:@"unselected+normal"] forState:UIControlStateNormal];
    self.choseBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.choseBtn.spacingBetweenImageAndTitle = 8;
    [self addSubview:self.choseBtn];
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    // 删除按钮
    self.deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.deleteBtn setTitle:@"删除(0)" forState:(UIControlStateNormal)];
    [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
    self.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#F73035" alpha:0.3];
    self.deleteBtn.layer.cornerRadius = 2;
    self.deleteBtn.enabled = NO;
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(141*kWidthScale, 50*kHeightScale));
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
    }];
}

- (void)clickedAllChoseAction:(UIButton*)sender {

    if ([sender.currentImage isEqual:[UIImage imageNamed:@"unselected+normal"]]) {
        [sender setImage:[UIImage imageNamed:@"selected+normal"] forState:(UIControlStateNormal)];
        self.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#F73035"];
        self.isChose = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"unselected+normal"] forState:(UIControlStateNormal)];
        self.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#F73035" alpha:0.3];
        self.isChose = NO;
    }
    self.deleteBtn.enabled  = self.isChose;
    if (self.clickdeChoseBtnBlock) {
        self.clickdeChoseBtnBlock(self.isChose);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
