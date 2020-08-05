//
//  YSHRYearSelectedView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRYearSelectedView.h"
@interface YSHRYearSelectedView()
@property (nonatomic,strong) QMUIButton *yearButton;
@property (nonatomic,strong) QMUIPopupMenuView *rightPopupMenuView;
@end
@implementation YSHRYearSelectedView
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
                if (strongSelf.selectBlock) {
                    strongSelf.selectBlock([NSString stringWithFormat:@"%zd", i]);
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
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.yearButton = [[QMUIButton alloc]init];
    self.yearButton.titleLabel.font = [UIFont systemFontOfSize:18];
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
        make.edges.mas_equalTo(0);
    }];
    [self.yearButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickSelect:(UIButton *)button {
    [self.rightPopupMenuView showWithAnimated:YES];
    [self.rightPopupMenuView layoutWithTargetView:self.yearButton];
}

@end
