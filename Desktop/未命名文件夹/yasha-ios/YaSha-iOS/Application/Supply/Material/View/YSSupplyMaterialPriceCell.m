//
//  YSSupplyMaterialPriceCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/14.
//

#import "YSSupplyMaterialPriceCell.h"
#import "YSBezierCurveView.h"
#import <PNPieChart.h>
#import <PNLineChart.h>
#import <PNLineChartData.h>
#import <PNLineChartDataItem.h>
@interface YSSupplyMaterialPriceCell ()<PNChartDelegate>

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PNLineChart * lineChart;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) YSBezierCurveView *bezierView;
@property (nonatomic, strong) NSMutableArray *x_names;
@property (nonatomic, strong) NSMutableArray *targets;
@property (nonatomic, strong) NSMutableArray *y_numerical;
@property (nonatomic, strong) NSMutableArray *timeArray;


@end

@implementation YSSupplyMaterialPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //1.初始化
    _bezierView = [YSBezierCurveView initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH-20*kWidthScale, 210*kHeightScale)];
    [self addSubview:_bezierView];
}
//画折线图
-(void)drawLineChart{
    
    //直线
    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets andXcoordinates:self.y_numerical andTimeShow:self.timeArray LineType:LineType_Straight];

}

- (void)setLineChart:(NSArray *)dataArr {
    _x_names = [NSMutableArray array];
   _targets = [NSMutableArray array];
    _y_numerical = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    NSString *str=[NSString stringWithFormat:@"%@",dataArr.lastObject[@"endDate"]] ;//时间戳
    NSTimeInterval time=[[str substringToIndex:10] doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
	
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSDate *date = [dateFormatter dateFromString:currentDateStr];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    for (int i = -1; i<=4; i++) {
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:detaildate];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:-i];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:detaildate options:0];
        NSString *beforDate = [dateFormatter stringFromDate:newdate];
        DLog(@"---前两个月 =%@",beforDate);
        [_x_names addObject:[beforDate substringToIndex:7]];
        DLog(@"-------%@",_x_names);
    }
    _x_names=(NSMutableArray *)[[_x_names reverseObjectEnumerator] allObjects];
    DLog(@"=======%@",_x_names);
    for (NSDictionary *dic in dataArr) {
        NSString *str=[NSString stringWithFormat:@"%@",dic[@"startDate"]] ;//时间戳
        NSTimeInterval time=[[str substringToIndex:10] doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
       
        [_timeArray addObject:[[detaildate description] substringToIndex:10]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString: [NSString stringWithFormat:@"%@-01",_x_names[0]]];
        DLog(@"=======%@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取两个日期的间隔
        NSDateComponents *comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour fromDate:date toDate:detaildate options:NSCalendarWrapComponents];
        [_targets addObject:[NSString stringWithFormat:@"%ld",labs(comp.day)+30]];
        [_y_numerical addObject:[NSString stringWithFormat:@"%@",dic[@"price"]]];
    }
    if (_y_numerical.count > 1) {
        [self drawLineChart];
    }else{
        [QMUITips showWithText:@"限价超出统计范围" inView:_bezierView];
    }
    
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
