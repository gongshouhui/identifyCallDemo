//
//  YSAttendanceRecordGWTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceRecordGWTableViewCell.h"

//组合分割字符串的 标志
#define SeparatedStr @" / "

@interface YSAttendanceRecordGWTableViewCell ()

@property (nonatomic, strong) UILabel *dayLab;//日期:天
@property (nonatomic, strong) UILabel *weekLab;//日期:周几
@property (nonatomic, strong) UILabel *titleLab;//标题:异常
@property (nonatomic, strong) UILabel *workTimeLab;//上班时间
@property (nonatomic, strong) UILabel *workLeaveLab;//下班时间
@property (nonatomic, strong) UIView *backContentView;





@end


@implementation YSAttendanceRecordGWTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FCFCFC"];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    _weekLab = [[UILabel alloc] init];
    _weekLab.textColor = [UIColor colorWithHexString:@"#858B9C"];
    _weekLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:Multiply(12)];
    [self.contentView addSubview:_weekLab];
    [_weekLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38*kHeightScale);
        make.left.mas_equalTo(21*kWidthScale);
    }];
    _dayLab = [[UILabel alloc] init];
    _dayLab.textColor = [UIColor colorWithHexString:@"#111A34"];
    _dayLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(20)];
    _dayLab.text = @" ";
    [self.contentView addSubview:_dayLab];
    [_dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_weekLab.mas_centerX);
        make.bottom.mas_equalTo(_weekLab.mas_top);
    }];
    
    
    
    //竖直灰线
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = [UIColor colorWithHexString:@"#C5CAD5"];
    verticalLine.alpha = 0.2;
    [self.contentView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58*kWidthScale);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1*kWidthScale);
    }];
    
    _backContentView = [[UIView alloc] init];
    _backContentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _backContentView.layer.cornerRadius = 4;
    _backContentView.layer.shadowColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:0.1].CGColor;
    _backContentView.layer.shadowOffset = CGSizeMake(0,2);
    _backContentView.layer.shadowOpacity = 1;
    _backContentView.layer.shadowRadius = 8;
    [self.contentView addSubview:_backContentView];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10*kHeightScale);
        make.left.mas_equalTo(68*kWidthScale);
        make.bottom.mas_equalTo(-10*kHeightScale);
        make.right.mas_equalTo(-20*kWidthScale);
    }];
    //标题
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor colorWithHexString:@"#FF41485D"];
    _titleLab.text = @" ";
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(92*kWidthScale);
        make.top.mas_equalTo(22*kHeightScale);
//        make.height.mas_equalTo(20*kHeightScale);
    }];
    
    // 上班时间
    UILabel *workLabel = [[UILabel alloc] init];
    workLabel.text = @"上班时间:";
    workLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:Multiply(12)];
    workLabel.textColor = [UIColor colorWithHexString:@"#858B9C"];
    [self.contentView addSubview:workLabel];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab.mas_left);
//        make.height.mas_offset(16*kHeightScale);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(4*kHeightScale);
        
    }];
    
    // 上/下班 中间竖线
    UIView *middleVerticalLine = [[UIView alloc] init];
    middleVerticalLine.backgroundColor = [UIColor colorWithHexString:@"#C5CAD5"];
    middleVerticalLine.alpha = 0.2;
    [self.contentView addSubview:middleVerticalLine];
    [middleVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(190*kWidthScale);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_equalTo(1*kWidthScale);
        make.centerY.mas_equalTo(workLabel.mas_centerY);
    }];
    
    _workTimeLab = [[UILabel alloc] init];
    _workTimeLab.text = @" ";
    _workTimeLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:Multiply(12)];
    _workTimeLab.textColor = [UIColor colorWithHexString:@"#858B9C"];
    [self.contentView addSubview:_workTimeLab];
    [_workTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(workLabel.mas_right).offset(4*kWidthScale);
        make.top.mas_equalTo(workLabel.mas_top);
        make.right.mas_equalTo(middleVerticalLine.mas_left).offset(4*kWidthScale);
//        make.height.mas_offset(16*kHeightScale);
        make.bottom.mas_equalTo(-22*kHeightScale);
    }];
    
    
    
    
    // 下班时间
    UILabel *workLeaveLabel = [[UILabel alloc] init];
    workLeaveLabel.text = @"下班时间:";
    workLeaveLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:Multiply(12)];
    workLeaveLabel.textColor = [UIColor colorWithHexString:@"#858B9C"];
    [self.contentView addSubview:workLeaveLabel];
    [workLeaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(middleVerticalLine.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(workLabel.mas_top);
    }];
    
    _workLeaveLab = [[UILabel alloc] init];
    _workLeaveLab.text = @" ";
    _workLeaveLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:Multiply(12)];
    _workLeaveLab.textColor = [UIColor colorWithHexString:@"#858B9C"];
    [self.contentView addSubview:_workLeaveLab];
    [_workLeaveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(workLeaveLabel.mas_right).offset(4*kWidthScale);
        make.centerY.mas_equalTo(workLeaveLabel.mas_centerY);
    }];
    
    //申诉按钮
    _complaintBtn = [[QMUIButton alloc] init];
    _complaintBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    _complaintBtn.backgroundColor = [UIColor colorWithHexString:@"#F6F8F9"];
    [_complaintBtn setTitleColor:[UIColor colorWithHexString:@"#FFC5CAD5"] forState:(UIControlStateNormal)];
    _complaintBtn.layer.cornerRadius = 2;
    _complaintBtn.hidden = YES;
//    _complaintBtn.enabled = NO;
    [self.contentView addSubview:_complaintBtn];
    [_complaintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(workLabel.mas_bottom).offset(10*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(243*kWidthScale, 32*kHeightScale));
        make.left.mas_equalTo(92*kHeightScale);
    }];

    
}

- (void)setRecordTimeData:(NSDictionary*)dic {
    if ([[dic objectForKey:@"type"] intValue] == 2) {
        _complaintBtn.hidden = NO;
        [_workTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-64*kHeightScale);
        }];
    }else {
        _complaintBtn.hidden = YES;
        [_workTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-22*kHeightScale);
        }];
    }
    _titleLab.text = [dic objectForKey:@"title"];
    _dayLab.text = [dic objectForKey:@"day"];
    _weekLab.text = [dic objectForKey:@"week"];
    _workTimeLab.text = [dic objectForKey:@"workTime"];
    _workLeaveLab.text = [dic objectForKey:@"workLeaveTime"];
    [_backContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *typeArray = [dic objectForKey:@"arrayType"];
    NSArray *colorArray = @[@"#E02020", @"#0091FF",@"#F7B500", @"#6DD400"];
    [self layoutIfNeeded];
    DLog(@"位置大小:%@", NSStringFromCGRect(_backContentView.frame));
    
    for (int i = 0; i < typeArray.count; i++) {
        CGRect frameLine = CGRectMake(0, i*(CGRectGetHeight(_backContentView.frame)/typeArray.count), 4*kWidthScale, CGRectGetHeight(_backContentView.frame)/typeArray.count);
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = frameLine;
        if (i !=0 && i != typeArray.count-1) {
            lineView.backgroundColor = [UIColor colorWithHexString:colorArray[i]];
        }
        [_backContentView addSubview:lineView];
        
        if (typeArray.count == 1) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            //起始点
            [path moveToPoint:(CGPointMake(4*kWidthScale, 0))];
            //顶部左侧曲线段
            [path addQuadCurveToPoint:(CGPointMake(0, 4*kWidthScale)) controlPoint:(CGPointMake(2, 2))];
            //左侧直线
            [path addLineToPoint:(CGPointMake(0, CGRectGetHeight(lineView.frame)-4))];
            //底部左侧曲线
            [path addQuadCurveToPoint:(CGPointMake(4*kWidthScale, CGRectGetHeight(lineView.frame))) controlPoint:(CGPointMake(2, CGRectGetHeight(lineView.frame)-2))];

            CAShapeLayer *shapeLayer=[CAShapeLayer layer];
            shapeLayer.frame = lineView.frame;
            shapeLayer.path = path.CGPath;
            lineView.layer.backgroundColor = [UIColor colorWithHexString:colorArray[i]].CGColor;
            lineView.layer.mask = shapeLayer;
            
        }else{
            if (i == 0) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                
                [path moveToPoint:(CGPointMake(4*kWidthScale, 0))];
                [path addQuadCurveToPoint:(CGPointMake(0, 4*kWidthScale)) controlPoint:(CGPointMake(2, 2))];
                [path addLineToPoint:(CGPointMake(0, CGRectGetHeight(lineView.frame)))];
                [path addLineToPoint:(CGPointMake(4*kWidthScale, CGRectGetHeight(lineView.frame)))];

                CAShapeLayer *shapeLayer=[CAShapeLayer layer];
                shapeLayer.frame = lineView.frame;
                shapeLayer.path = path.CGPath;
                lineView.layer.backgroundColor = [UIColor colorWithHexString:colorArray[i]].CGColor;
                lineView.layer.mask = shapeLayer;
                
            }
            if (i == typeArray.count-1){
                UIBezierPath *path = [UIBezierPath bezierPath];
                
                //左侧开始画弧的点(坐下)
                [path moveToPoint:(CGPointMake(0, CGRectGetHeight(lineView.frame)-4))];
                //左下侧弧度
                [path addQuadCurveToPoint:(CGPointMake(4*kWidthScale, CGRectGetHeight(lineView.frame))) controlPoint:(CGPointMake(2, CGRectGetHeight(lineView.frame)-2))];
                //右上角
                [path addLineToPoint:(CGPointMake(4*kWidthScale, 0))];
                //左上角
                [path addLineToPoint:(CGPointMake(0, 0))];


                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                //使用lineView.frame的话 会超出视图 不显示
//                shapeLayer.frame = lineView.frame;
                shapeLayer.path = path.CGPath;
                //描边颜色
//                shapeLayer.strokeColor = [UIColor colorWithHexString:colorArray[i]].CGColor;
                //背景色
                shapeLayer.fillColor = [UIColor colorWithHexString:colorArray[i]].CGColor;
                [lineView.layer addSublayer:shapeLayer];
                
            }
        }
    }


    
}


- (void)setComplaintModel:(YSComplaintListModel *)complaintModel {
    NSDictionary *colorDict = @{@"shj":@"#FF6236FF", @"bj":@"#FF6236FF", @"hj":@"#FF6236FF", @"cj":@"#FF6236FF", @"cjj":@"#FF6236FF", @"phj":@"#FF6236FF", @"sj":@"#FF6236FF", @"gsj":@"#FF6236FF", @"tj":@"#FF6236FF", @"brj":@"#FF6236FF", @"xsj":@"#FF6236FF", @"ygwc":@"#FFF7B500", @"cc":@"#FFF7B500", @"jb":@"#FFFA6400", @"YC":@"#FFE02020", @"CD":@"#FFE02020", @"ZT":@"#FFE02020",  @"XXR":@"#FF0091FF", @"FDJJR":@"#FF0091FF", @"ZC":@"#FF6DD400", @"xmtx":@"#FF6236FF"};//@"KG1":@"#FFE02020", @"KG2":@"#FFE02020",旷工没有
    _complaintModel = complaintModel;
    _dayLab.text = complaintModel.day;
    _weekLab.text = [complaintModel.weekStr stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    _weekLab.text = [_weekLab.text stringByReplacingOccurrencesOfString:@"天" withString:@"日"];
    //上班打卡时间
    _workTimeLab.textColor = [UIColor colorWithHexString:@"#FF858B9C"];
    if ([YSUtility judgeIsEmpty:complaintModel.startTimeStr]) {
        _workTimeLab.text = @"-";
        //[complaintModel.dayType isEqualToString:@"GZR"] && ![complaintModel.flowType isEqualToString:@"tj"] && ![complaintModel.flowType isEqualToString:@"xmtx"] && ![complaintModel.applyType isEqualToString:@"ycl"]还有因公外出
        if (![complaintModel.resultType isEqualToString:@"ZC"]) {
            //工作日且没有调休 没有打卡时间
            _workTimeLab.text = @"未打卡";
            _workTimeLab.textColor = [UIColor colorWithHexString:@"#FFE02020"];
        }
    }else {
        _workTimeLab.text = complaintModel.startTimeStr;
    }

    //下班打卡时间
    _workLeaveLab.textColor = [UIColor colorWithHexString:@"#FF858B9C"];
    if ([YSUtility judgeIsEmpty:complaintModel.endTimeStr]) {
        _workLeaveLab.text = @"-";
        //[complaintModel.dayType isEqualToString:@"GZR"] && ![complaintModel.flowType isEqualToString:@"tj"] && ![complaintModel.flowType isEqualToString:@"xmtx"] && ![complaintModel.applyType isEqualToString:@"ycl"]还有因公外出
        if (![complaintModel.resultType isEqualToString:@"ZC"]) {
            //工作日 没有打卡时间
            _workLeaveLab.text = @"未打卡";
            _workLeaveLab.textColor = [UIColor colorWithHexString:@"#FFE02020"];
        }
    }else {
        _workLeaveLab.text = complaintModel.endTimeStr;
    }
    //显示的 状态/标题 颜色的 key;
    NSMutableArray *nameColorKeyArray = [NSMutableArray new];
    if ([YSUtility judgeIsEmpty:complaintModel.flowTypeMsg]) {
        // 流程类型为空 显示考勤结果
        _titleLab.text = complaintModel.resultTypeMsg;
        nameColorKeyArray = @[complaintModel.resultType].mutableCopy;

        if ([complaintModel.day isEqualToString:@"TX"] && [complaintModel.resultType isEqualToString:@"ZC"]) {
            _titleLab.text = @"调班";
            nameColorKeyArray = @[@"ZC"].mutableCopy;
        }
    }else {
        //流程类型不为空 此判断已包含 调休流程(当flowType返回tj)时
        if (![complaintModel.resultType isEqualToString:@"ZC"]) {
            // 考勤结果 不正常的情况
            NSString *flowStr = complaintModel.flowTypeMsg;
            if ([complaintModel.flowTypeMsg containsString:@","]) {
                //流程状态 多个的情况
                flowStr = [complaintModel.flowTypeMsg stringByReplacingOccurrencesOfString:@"," withString:SeparatedStr];
            }
            [nameColorKeyArray addObject:complaintModel.resultType];
            [nameColorKeyArray addObjectsFromArray:[complaintModel.flowType componentsSeparatedByString:@","]];
            _titleLab.text = [NSString stringWithFormat:@"%@ / %@", complaintModel.resultTypeMsg, flowStr];
        }else {
            // 考勤结果 正常 只显示流程状态
            _titleLab.text = [complaintModel.flowTypeMsg stringByReplacingOccurrencesOfString:@"," withString:SeparatedStr];
            nameColorKeyArray = [NSMutableArray arrayWithArray:[complaintModel.flowType componentsSeparatedByString:@","]];
        }
    }
    
    // 是否为休息日的 放最后面判断
    if ([complaintModel.dayType isEqualToString:@"FDJJR"] ) {
        _titleLab.text = @"休假";
        nameColorKeyArray = @[@"FDJJR"].mutableCopy;
    }
    if ([complaintModel.dayType isEqualToString:@"XXR"]) {
        _titleLab.text = @"休息";
        nameColorKeyArray = @[@"XXR"].mutableCopy;
    }
    if ([complaintModel.flowType isEqualToString:@"jb"]) {
        _titleLab.text = @"加班";
        nameColorKeyArray = @[@"jb"].mutableCopy;
    }
    
    _complaintBtn.backgroundColor = [UIColor colorWithHexString:@"#F6F8F9"];
    [_complaintBtn setTitleColor:[UIColor colorWithHexString:@"#FFC5CAD5"] forState:(UIControlStateNormal)];
    [_complaintBtn setImage:nil forState:(UIControlStateNormal)];
    _complaintBtn.hidden = NO;
    [_workTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-64*kHeightScale);
    }];
    if ([complaintModel.resultType isEqualToString:@"ZC"]) {
        _complaintBtn.hidden = YES;
        [_workTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-22*kHeightScale);
        }];
    }
    else if ([complaintModel.applyType isEqualToString:@"wss"]) {
        [_complaintBtn setTitle:@"请去企业微信发起异常申诉流程" forState:(UIControlStateNormal)];
//        [_complaintBtn setImage:[UIImage imageNamed:@"complaintBtnIcon"] forState:(UIControlStateNormal)];
//        [_complaintBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2.0f)];
//
//        _complaintBtn.backgroundColor = [UIColor colorWithHexString:@"#1A007AFF"];
//        [_complaintBtn setTitleColor:[UIColor colorWithHexString:@"#FF007AFF"] forState:(UIControlStateNormal)];

    }
    else if ([complaintModel.applyType isEqualToString:@"ysd"]) {
        [_complaintBtn setTitle:@"考勤已锁定, 不予处理" forState:(UIControlStateNormal)];

    }
    else if ([complaintModel.applyType isEqualToString:@"clz"]) {
        [_complaintBtn setTitle:@"处理中" forState:(UIControlStateNormal)];

    }
    else if ([complaintModel.applyType isEqualToString:@"ycl"]) {
        [_complaintBtn setTitle:@"已处理" forState:(UIControlStateNormal)];

    }
   
    [_backContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self layoutIfNeeded];
    
    //标题的颜色
    NSMutableArray *nameColorArray = [NSMutableArray new];
   
    //左侧颜色条
    for (int i = 0; i < nameColorKeyArray.count; i++) {
            CGRect frameLine = CGRectMake(0, i*(CGRectGetHeight(_backContentView.frame)/nameColorKeyArray.count), 4*kWidthScale, CGRectGetHeight(_backContentView.frame)/nameColorKeyArray.count);
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = frameLine;
            if (i !=0 && i != nameColorKeyArray.count-1) {
                lineView.backgroundColor = [UIColor colorWithHexString:[colorDict objectForKey:nameColorKeyArray[i]]];
              
                [nameColorArray addObject:[colorDict objectForKey:nameColorKeyArray[i]]];
            }
            [_backContentView addSubview:lineView];
            
            if (nameColorKeyArray.count == 1) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                //起始点
                [path moveToPoint:(CGPointMake(4*kWidthScale, 0))];
                //顶部左侧曲线段
                [path addQuadCurveToPoint:(CGPointMake(0, 4*kWidthScale)) controlPoint:(CGPointMake(2, 2))];
                //左侧直线
                [path addLineToPoint:(CGPointMake(0, CGRectGetHeight(lineView.frame)-4))];
                //底部左侧曲线
                [path addQuadCurveToPoint:(CGPointMake(4*kWidthScale, CGRectGetHeight(lineView.frame))) controlPoint:(CGPointMake(2, CGRectGetHeight(lineView.frame)-2))];

                CAShapeLayer *shapeLayer=[CAShapeLayer layer];
                shapeLayer.frame = lineView.frame;
                shapeLayer.path = path.CGPath;
                lineView.layer.backgroundColor = [UIColor colorWithHexString:[colorDict objectForKey:nameColorKeyArray[i]]].CGColor;
                lineView.layer.mask = shapeLayer;
               
                [nameColorArray addObject:[colorDict objectForKey:nameColorKeyArray[i]]];

            }else{
                if (i == 0) {
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    
                    [path moveToPoint:(CGPointMake(4*kWidthScale, 0))];
                    [path addQuadCurveToPoint:(CGPointMake(0, 4*kWidthScale)) controlPoint:(CGPointMake(2, 2))];
                    [path addLineToPoint:(CGPointMake(0, CGRectGetHeight(lineView.frame)))];
                    [path addLineToPoint:(CGPointMake(4*kWidthScale, CGRectGetHeight(lineView.frame)))];

                    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
                    shapeLayer.frame = lineView.frame;
                    shapeLayer.path = path.CGPath;
                    lineView.layer.backgroundColor = [UIColor colorWithHexString:[colorDict objectForKey:nameColorKeyArray[i]]].CGColor;
                    lineView.layer.mask = shapeLayer;
                    
                    [nameColorArray addObject:[colorDict objectForKey:nameColorKeyArray[i]]];
                }
                if (i == nameColorKeyArray.count-1){
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    
                    //左侧开始画弧的点(坐下)
                    [path moveToPoint:(CGPointMake(0, CGRectGetHeight(lineView.frame)-4))];
                    //左下侧弧度
                    [path addQuadCurveToPoint:(CGPointMake(4*kWidthScale, CGRectGetHeight(lineView.frame))) controlPoint:(CGPointMake(2, CGRectGetHeight(lineView.frame)-2))];
                    //右上角
                    [path addLineToPoint:(CGPointMake(4*kWidthScale, 0))];
                    //左上角
                    [path addLineToPoint:(CGPointMake(0, 0))];


                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    //使用lineView.frame的话 会超出视图 不显示
    //                shapeLayer.frame = lineView.frame;
                    shapeLayer.path = path.CGPath;
                    //描边颜色
    //                shapeLayer.strokeColor = [UIColor colorWithHexString:colorArray[i]].CGColor;
                    //背景色
                    shapeLayer.fillColor = [UIColor colorWithHexString:[colorDict objectForKey:nameColorKeyArray[i]]].CGColor;
                    [lineView.layer addSublayer:shapeLayer];
                    
                    [nameColorArray addObject:[colorDict objectForKey:nameColorKeyArray[i]]];

                }
            }
        }
    
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:_titleLab.text];
    NSArray *traverseNameArray = [_titleLab.text componentsSeparatedByString:SeparatedStr];
    [traverseNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:traverseNameArray[idx]].location, [[contentStr string] rangeOfString:traverseNameArray[idx]].length);
        //修改特定字符的颜色
        if (nameColorArray.count >= idx+1 && ![YSUtility judgeIsEmpty:nameColorArray[idx]]) {
            [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:nameColorArray[idx]] range:redRange];

        }else {
            DLog(@"崩溃标题:%@--线条:%ld--颜色:%@--day:%@---week:%@", _titleLab.text, idx, nameColorKeyArray, _dayLab.text, _weekLab.text);
        }
//        [contentStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)] range:redRange];
    }];
    _titleLab.attributedText = contentStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
