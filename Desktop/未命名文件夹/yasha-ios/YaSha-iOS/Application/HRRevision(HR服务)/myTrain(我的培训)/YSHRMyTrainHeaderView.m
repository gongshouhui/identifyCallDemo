//
//  YSHRMyTrainHeaderView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMyTrainHeaderView.h"
#import "ZZGradientProgress.h"
#import "YSHRTrainDataView.h"
#define CircleRadius 85
@interface YSHRMyTrainHeaderView()
@property (nonatomic,strong) ZZGradientProgress *gradientCircle;
@property (nonatomic,strong) UILabel *percentLb;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *titleArray;
@end
@implementation YSHRMyTrainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    //半径CircleRadius
    ZZGradientProgress *gradientCircle = [[ZZGradientProgress alloc]initWithFrame:CGRectMake(self.center.x - CircleRadius, 20, CircleRadius*2, CircleRadius*2 ) startColor:[UIColor colorWithHexString:@"#37E7C0"] endColor:[UIColor colorWithHexString:@"#68B1F5"] startAngle:-225 reduceAngle:90 strokeWidth:10];
    self.gradientCircle = gradientCircle;
    gradientCircle.radius = CircleRadius;
    gradientCircle.showProgressText = NO;
    gradientCircle.showPathBack = YES;
    gradientCircle.pathBackColor = kGrayColor(246);
    gradientCircle.animationDuration = 2;
    gradientCircle.textColor = [UIColor colorWithHexString:@"68B1F5"];
    gradientCircle.textFont = [UIFont systemFontOfSize:59];
    gradientCircle.roundStyle = YES;
    gradientCircle.colorGradient = NO;
    gradientCircle.progress = 0.0;
    [self addSubview:gradientCircle];
    
    UILabel *percentLb = [[UILabel alloc]init];
    self.percentLb = percentLb;
    self.percentLb.font = [UIFont systemFontOfSize:59];
    percentLb.textColor = [UIColor colorWithHexString:@"68B1F5"];
    percentLb.textAlignment = NSTextAlignmentCenter;
    percentLb.text = @"0%";
    percentLb.frame = CGRectMake(0, 0, 150, 150);
    percentLb.center = CGPointMake(self.center.x, CircleRadius + 20);
   
    [self addSubview:percentLb];
    
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textColor = [UIColor blackColor];
    label3.text = @"完成率";
    [label3 sizeToFit];
    [label3 setCenter:CGPointMake(CGRectGetMidX(gradientCircle.frame), CGRectGetMaxY(gradientCircle.frame) - 20)];
    [self addSubview:label3];
    
    //下方滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_offset(-15);
        make.height.mas_equalTo(80);
    }];
    
}
- (void)setSummaryModel:(YSHRTrainSummyModel *)summaryModel
{
    _summaryModel = summaryModel;
    self.gradientCircle.progress = [summaryModel.completionRate floatValue];
    NSString *perSign = @"%";
    NSString *pertentStr = [NSString stringWithFormat:@"%.0f",self.gradientCircle.progress * 100];
    NSString *wholeStr = [NSString stringWithFormat:@"%@%@",pertentStr,perSign];
    NSMutableAttributedString *atti = [[NSMutableAttributedString alloc]initWithString:wholeStr];
    [atti addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:[wholeStr rangeOfString:perSign]];
    self.percentLb.attributedText = atti;
    //下方数据条
    _titleArray = [[NSMutableArray alloc]init];
    [_titleArray addObject:@{@"num":[NSString stringWithFormat:@"%ld",_summaryModel.trainNum],@"name":@"培训次数（次）"}];
    [_titleArray addObject:@{@"num":[NSString stringWithFormat:@"%.1f/%.1f",_summaryModel.planClassHoursObligatory,_summaryModel.realClassHoursObligatory],@"name":@"必修学时：计划/完成（小时）"}];
     [_titleArray addObject:@{@"num":[NSString stringWithFormat:@"%.1f/%.1f",_summaryModel.planClassHoursElective,_summaryModel.realClassHoursElective],@"name":@"选修学时：计划/完成（小时）"}];
     [_titleArray addObject:@{@"num":[NSString stringWithFormat:@"%.1f/%.1f",_summaryModel.planClassHoursShare,_summaryModel.realClassHoursShare],@"name":@"分享学时：计划/完成（小时）"}];
    [self addDetailLabel];
}
- (void)addDetailLabel {
    
    YSHRTrainDataView *lastView = nil;
    for (int i = 0; i < self.titleArray.count; i++) {
        YSHRTrainDataView *dataView = [[YSHRTrainDataView alloc]init];
        dataView.numLb.text = self.titleArray[i][@"num"];
        dataView.numLb.textColor = kUIColor(25, 31, 37, 1);
        dataView.detailLb.text = self.titleArray[i][@"name"];
        dataView.detailLb.textColor = kUIColor(25, 31, 37, 1);
        [self.scrollView addSubview:dataView];
        [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(15);
            make.bottom.mas_offset(-15);
            if (i == 0) {
                make.left.mas_equalTo(15);
            }else{
                make.left.mas_equalTo(lastView.mas_right).mas_equalTo(25);
            }
            
            if (i == self.titleArray.count - 1) {
                make.right.mas_equalTo(-15);
            }
        }];
        
        lastView = dataView;
    }
}
@end
