//
//  YSHRManagerSelectYear.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerSelectYear.h"

@interface YSHRManagerSelectYear ()
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic,strong) QMUIButton *yearButton;

@end


@implementation YSHRManagerSelectYear


- (instancetype)initWithFrame:(CGRect)frame withTitle:(nonnull NSString *)titleStr {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViewsWith:titleStr];
    }
    return self;
}

- (void)loadSubViewsWith:(NSString*)titleStr {
    self.yearButton = [[QMUIButton alloc]init];
    self.yearButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.yearButton setTitleColor:[UIColor colorWithHexString:@"#191F25" alpha:0.8] forState:UIControlStateNormal];
    [self.yearButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    self.currentSelectedYear = [NSString stringWithFormat:@"%ld",comp.year];
    [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",comp.year] forState:UIControlStateNormal];
    self.yearButton.imagePosition = QMUIButtonImagePositionRight;
    self.yearButton.spacingBetweenImageAndTitle = 8;
    [self addSubview:self.yearButton];
    [self.yearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(22*kHeightScale);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    [self.yearButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.yearButton];
    
    self.titlLab = [[UILabel alloc] init];
    self.titlLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    self.titlLab.text = titleStr;
    [self addSubview:self.titlLab];
    [self.titlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22*kHeightScale);
        make.right.mas_equalTo(-16*kWidthScale);
    }];
}

- (void)clickSelect:(UIButton *)button {
    [self.rightPopupMenuView showWithAnimated:YES];
    [self.rightPopupMenuView layoutWithTargetView:self.yearButton];
}

- (QMUIPopupMenuView *)rightPopupMenuView {
    if (!_rightPopupMenuView) {
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 80*kWidthScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        YSWeak;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSInteger i = [[[NSDate date] dateByAddingHours:8] year]; i >= 2016 ; i --) {
            QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:[NSString stringWithFormat:@"%zd", i] handler:^{
                YSStrong;
                [strongSelf.yearButton setTitle:[NSString stringWithFormat:@"%zd", i] forState:UIControlStateNormal];
                if (strongSelf.selectYearBlock) {
                    strongSelf.selectYearBlock([NSString stringWithFormat:@"%zd", i]);
                }
                [strongSelf.rightPopupMenuView hideWithAnimated:YES];
            }];
            [mutableArray addObject:popupMenuItem];
        }
        _rightPopupMenuView.items = [mutableArray copy];
        _rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
    return _rightPopupMenuView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
