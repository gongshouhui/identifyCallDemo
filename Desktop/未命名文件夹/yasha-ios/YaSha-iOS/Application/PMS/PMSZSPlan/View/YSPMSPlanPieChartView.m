//
//  YSPMSPlanPieChartView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/28.
//

#import "YSPMSPlanPieChartView.h"
#import <PNPieChart.h>
#import "YSCircleManageView.h"
#import "UIImage+YSImage.h"
#import "YSPMSPlanInfoViewController.h"
#import "YSPMSMQEarilyPrePlanController.h"
@interface YSPMSPlanPieChartView ()



@property (nonatomic, strong) UIView *pieChartView;
@property (nonatomic, strong) YSCircleManageView * circleView1;

@end

@implementation YSPMSPlanPieChartView
{
    //tips
    NSArray *constructionArr;
    NSArray *controlArr;
    NSArray *imageName;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //上方两个switch button
    //施工任务情况
    self.delayButton = [[UIButton alloc]init];
    self.delayButton.selected = YES;//默认选中状态
    [self.delayButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.delayButton setBackgroundImage:[UIImage imageWithColor:kUIColor(42, 138, 219, 1)] forState:UIControlStateSelected];
    self.delayButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.delayButton setTitleColor:kUIColor(42, 138, 219, 1) forState:UIControlStateNormal];
    [self.delayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.delayButton.tag = 1;
    [self.delayButton setTitle:@"施工任务情况" forState:UIControlStateNormal];
    self.delayButton.layer.borderColor = [kUIColor(42, 138, 219, 1) CGColor];
    
    self.delayButton.layer.borderWidth = 1.0f;
    [self addSubview:self.delayButton];
    [self.delayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(16);
        make.left.mas_equalTo(self.mas_left).offset(120*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(78*kWidthScale, 26*kHeightScale));
        
    }];
    [self.delayButton addTarget:self action:@selector(delayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //控制点
    self.controlPointsButton = [[UIButton alloc]init];
    self.controlPointsButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.controlPointsButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.controlPointsButton setBackgroundImage:[UIImage imageWithColor:kUIColor(42, 138, 219, 1)] forState:UIControlStateSelected];
    [self.controlPointsButton setTitleColor:kUIColor(42, 138, 219, 1) forState:UIControlStateNormal];
    [self.controlPointsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.controlPointsButton setTitle:@"控制点情况" forState:UIControlStateNormal];
    self.controlPointsButton.tag = 2;
    self.controlPointsButton.layer.borderColor = [kUIColor(42, 138, 219, 1) CGColor];
    
    self.controlPointsButton.layer.borderWidth = 1.0f;
    [self addSubview:self.controlPointsButton];
    [self.controlPointsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(16);
        make.left.mas_equalTo(self.delayButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(78*kWidthScale, 26*kHeightScale));
    }];
    [self.controlPointsButton addTarget:self action:@selector(controlPointsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   
}
//absolutelyArray传入施工情况（正常，开工延期，完工延期）  传入控制点（正常，延期）
- (void)creatPieChart:(NSArray *)absolutelyArray andDelayTitleArray:(NSArray *)delayTitle {
    //右下标签
    if (absolutelyArray.count == 4) {
        constructionArr = @[@"正常",@"延期0~15%",@"延期15~30%",@"延期30%以上"];
        controlArr = @[@"正常",@"延期0~15%",@"延期15~30%",@"延期30%以上"];
        imageName = @[@"正常",@"延期5-15天",@"延期5-15天1",@"延期大于15天"];
    }else {
        constructionArr = @[@"正常",@"开工延期",@"完工延期"];
        controlArr = @[@"正常",@"延期"];
        imageName = @[@"正常",@"延期小于5天",@"延期大于15天",@"延期5-15天"];
    }
    //tip
    //数据，图片
    for (int i = 0; i < constructionArr.count; i++) {
        UIButton *showMmarkButton = [[UIButton alloc]init];
        showMmarkButton.tag = i + 5;
        showMmarkButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [showMmarkButton setTitleColor:kUIColor(126, 126, 126, 1) forState:UIControlStateNormal];
        [showMmarkButton setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        [showMmarkButton setTitle:constructionArr[i] forState:UIControlStateNormal];
        //设置button文字的位置
        showMmarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //调整与边距的距离
        showMmarkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self addSubview:showMmarkButton];
        [showMmarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset((200+20*i) *kHeightScale);
            make.right.mas_equalTo(self.mas_right).offset(-10*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(95*kWidthScale, 15*kHeightScale));
        }];
    }
    
    //饼图
    if (absolutelyArray.count == 3) {//施工任务情况
        [_circleView1 removeFromSuperview];
        _circleView1 = [[YSCircleManageView alloc] initWithFrame:CGRectMake(0, 50*kHeightScale, [UIScreen mainScreen].bounds.size.width, 260*kHeightScale)];
        NSMutableArray *piecherArray = [NSMutableArray array];
        [piecherArray removeAllObjects];
        if ([absolutelyArray[0] integerValue] != 0) {//正常
            [piecherArray addObject:@{@"number":absolutelyArray[0] ,@"color":kUIColor(41, 171, 145, 1),@"name":@"",@"type":@(YSConstructionProgressNomal)}];
        }
        if ([absolutelyArray[1] integerValue] != 0) {//开工延期
            [piecherArray addObject:@{@"number":absolutelyArray[1] ,@"color":kUIColor(42, 138, 219, 1),@"name":@"",@"type":@(YSConstructionProgressStartDelay)}];
        }
        
       
        if ([absolutelyArray[2] integerValue] != 0) {//完工延期
                [piecherArray addObject:@{@"number":absolutelyArray[2] ,@"color":kUIColor(240, 90, 74, 1),@"name":@"",@"type":@(YSConstructionProgressCompeleteDelay)}];
            }
        DLog(@"=======%@",piecherArray);
        [_circleView1 loadDataArray:piecherArray withType:MYHCircleManageViewTypeRound];
        [self addSubview:_circleView1];
    }
    
    if (absolutelyArray.count == 2) {//控制点
        [_circleView1 removeFromSuperview];
        _circleView1 = [[YSCircleManageView alloc] initWithFrame:CGRectMake(0, 50*kHeightScale, [UIScreen mainScreen].bounds.size.width, 260*kHeightScale)];
        NSMutableArray *piecherArray = [NSMutableArray array];
        [piecherArray removeAllObjects];
        if ([absolutelyArray[0] integerValue] != 0) {//正常
            [piecherArray addObject:@{@"number":absolutelyArray[0] ,@"color":kUIColor(38, 157, 126, 1),@"name":@"正常",@"type":@(YSConstructionProgressNomal)}];
        }
        if ([absolutelyArray[1] integerValue] != 0) {//开工延期
            [piecherArray addObject:@{@"number":absolutelyArray[1] ,@"color":kUIColor(35, 116, 211, 1),@"name":@"延期",@"type":@(YSConstructionProgressControlDelay)}];
        }
        [_circleView1 loadDataArray:piecherArray withType:MYHCircleManageViewTypeRound];
        [self addSubview:_circleView1];
    }
    if (absolutelyArray.count == 4) {
        [_circleView1 removeFromSuperview];
        _circleView1 = [[YSCircleManageView alloc] initWithFrame:CGRectMake(0, 50*kHeightScale, [UIScreen mainScreen].bounds.size.width, 260*kHeightScale)];
        NSMutableArray *piecherArray = [NSMutableArray array];
        [piecherArray removeAllObjects];
        if ([absolutelyArray[0] integerValue] != 0) {//正常
            [piecherArray addObject:@{@"number":absolutelyArray[0] ,@"color":kUIColor(41, 171, 145, 1),@"name":@"",@"type":@(YSConstructionProgressNomal)}];
        }
        if ([absolutelyArray[1] integerValue] != 0) {//延期15
            [piecherArray addObject:@{@"number":absolutelyArray[1] ,@"color":kUIColor(249, 183, 87, 1),@"name":@"",@"type":@(YSConstructionProgressFifteenDelay)}];
        }
        
        
        if ([absolutelyArray[2] integerValue] != 0) {//延期30
            [piecherArray addObject:@{@"number":absolutelyArray[2] ,@"color":kUIColor(193, 128, 254, 1),@"name":@"",@"type":@(YSConstructionProgressThirtyDelay)}];
        }
        if ([absolutelyArray[3] integerValue] != 0) {//完工超过30
            [piecherArray addObject:@{@"number":absolutelyArray[3] ,@"color":kUIColor(237, 47, 40, 1),@"name":@"",@"type":@(YSConstructionProgressMoreThirtyDelay)}];
        }
        DLog(@"=======%@",piecherArray);
        [_circleView1 loadDataArray:piecherArray withType:MYHCircleManageViewTypeRound];
        [self addSubview:_circleView1];
    }
}
- (void)createEarlyPreparePieChart:(NSArray *)dataArray andChartType:(NSString *)title {
    BOOL isStartDelay = [title isEqualToString:@"开工延期"];
    //右下标签
    //第一个按钮选中时标签
        constructionArr = @[@"正常",@"延期0~15%",@"延期15~30%",@"延期30%以上"];
    //第二个按钮选中时标签
        controlArr = @[@"正常",@"延期0~15%",@"延期15~30%",@"延期30%以上"];
        imageName = @[@"正常",@"延期5-15天",@"延期5-15天1",@"延期大于15天"];
    //数据，图片
    for (int i = 0; i < constructionArr.count; i++) {
        UIButton *showMmarkButton = [[UIButton alloc]init];
        showMmarkButton.tag = i + 5;
        showMmarkButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [showMmarkButton setTitleColor:kUIColor(126, 126, 126, 1) forState:UIControlStateNormal];
        [showMmarkButton setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        [showMmarkButton setTitle:constructionArr[i] forState:UIControlStateNormal];
        //设置button文字的位置
        showMmarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //调整与边距的距离
        showMmarkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self addSubview:showMmarkButton];
        [showMmarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset((200+20*i) *kHeightScale);
            make.right.mas_equalTo(self.mas_right).offset(-10*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(95*kWidthScale, 15*kHeightScale));
        }];
    }
    
        [_circleView1 removeFromSuperview];
        _circleView1 = [[YSCircleManageView alloc] initWithFrame:CGRectMake(0, 50*kHeightScale, [UIScreen mainScreen].bounds.size.width, 260*kHeightScale)];
        NSMutableArray *piecherArray = [NSMutableArray array];
        [piecherArray removeAllObjects];
        if ([dataArray[0] integerValue] != 0) {//正常
            [piecherArray addObject:@{@"number":dataArray[0] ,@"color":kUIColor(41, 171, 145, 1),@"name":@"",@"type":isStartDelay?@(MQStartDelayNormalTask):@(MQCompletedDelayNormalTask)}];
        }
        if ([dataArray[1] integerValue] != 0) {//延期15
            [piecherArray addObject:@{@"number":dataArray[1] ,@"color":kUIColor(249, 183, 87, 1),@"name":@"",@"type":isStartDelay?@(MQStartDelayProgressFifteenDelay):@(MQCompletedDelayProgressFifteenDelay)}];
        }
        
        
        if ([dataArray[2] integerValue] != 0) {//延期30
            [piecherArray addObject:@{@"number":dataArray[2] ,@"color":kUIColor(193, 128, 254, 1),@"name":@"",@"type":isStartDelay?@(MQStartDelayProgressThirtyDelay):@(MQCompletedDelayProgressThirtyDelay)}];
        }
        if ([dataArray[3] integerValue] != 0) {//完工超过30
            [piecherArray addObject:@{@"number":dataArray[3] ,@"color":kUIColor(237, 47, 40, 1),@"name":@"",@"type":isStartDelay?@(MQStartDelayProgressMoreThirtyDelay):@(MQCompletedDelayProgressMoreThirtyDelay)}];
        }
    
        [_circleView1 loadDataArray:piecherArray withType:MYHCircleManageViewTypeRound];
        [self addSubview:_circleView1];
  
}
#pragma mark - 按钮点击事件
- (void)delayButtonAction:(UIButton *)button
{
    
    button.selected = YES;
    self.controlPointsButton.selected = NO;
   
    [self setUpTipsViewWithArray:constructionArr];
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(constructionInfoButtonDidClick:)]) {
        [self.delegate constructionInfoButtonDidClick:button];
    }
}
- (void)controlPointsButtonAction:(UIButton *)button
{
    button.selected = YES;
    self.delayButton.selected = NO;
    
    [self setUpTipsViewWithArray:controlArr];
    if ([self.delegate respondsToSelector:@selector(controlPointsButtonDidClick:)]) {
        [self.delegate controlPointsButtonDidClick:button];
    }
}
- (void)setUpTipsViewWithArray:(NSArray *)array
{
    //移除
    for (int i = 0; i < constructionArr.count; i++) {
        UIView *view = [self viewWithTag:i+5];
        [view removeFromSuperview];
    }
//    //添加
//    //tip
//    //数据，图片
//    for (int i = 0; i < array.count; i++) {
//      UIButton *showMmarkButton = [[UIButton alloc]init];
//        showMmarkButton.tag = i + 5;
//        showMmarkButton.backgroundColor = [UIColor whiteColor];
//        showMmarkButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [showMmarkButton setTitleColor:kUIColor(126, 126, 126, 1) forState:UIControlStateNormal];
//        [showMmarkButton setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
//        [showMmarkButton setTitle:array[i] forState:UIControlStateNormal];
//        //设置button文字的位置
//        showMmarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        //调整与边距的距离
//        showMmarkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        [self addSubview:showMmarkButton];
//        [showMmarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_top).offset((200+20*i) *kHeightScale);
////            make.left.mas_equalTo(self.mas_left).offset(280*kWidthScale);
//            make.right.mas_equalTo(self.mas_right).offset(-20*kWidthScale);
//            make.size.mas_equalTo(CGSizeMake(75*kWidthScale, 15*kHeightScale));
//        }];
//    }
}
@end
