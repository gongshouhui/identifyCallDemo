//
//  YSPMSPlanTimeChooseView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/11.
//

#import "YSPMSPlanTimeChooseView.h"

@interface YSPMSPlanTimeChooseView ()

@property (nonatomic, strong) NSString *years;
@property (nonatomic, strong) NSMutableArray *yearsArray;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, assign)  long long  TimeStamp;

@end

@implementation YSPMSPlanTimeChooseView

-(id)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
       
        _yearsArray=[[NSMutableArray alloc]init];
        _monthArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 2200; i ++) {
            NSString *string =[NSString stringWithFormat:@"%02d ",i];
            [_yearsArray addObject:string];
        }
        for (int i = 1; i < 13; i ++) {
            NSString *string =[NSString stringWithFormat:@"%02d ",i];
            [_monthArray addObject:string];
        }

        _bigArr =[[NSArray alloc]initWithObjects:_yearsArray,_monthArray, nil];
        [self InterceptionTime];
        UIButton*cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRects(15, 0, 85, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.tag=1;
        [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.51 blue:0.97 alpha:1.00] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRects(100, 0, 175, 40)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:19*BIZ];
        [self addSubview:_timeLabel];
        
        
        UIButton*determineBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        determineBtn.tag=2;
        determineBtn.frame=CGRects(275, 0, 85, 40);
        [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [determineBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [determineBtn setTitleColor:[UIColor colorWithRed:0.00 green:0.51 blue:0.97 alpha:1.00]forState:UIControlStateNormal];
        [determineBtn addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:determineBtn];
        
        //高度 默认值 162
        UIPickerView *pickerView =[[UIPickerView alloc]init];
        pickerView.frame=CGRects(0, 40, 375, 180);
        pickerView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1.0];
        //设置数据源（返回多少区 多少行）
        pickerView.dataSource =self;
        //设置代理
        pickerView.delegate =self;
        [self addSubview:pickerView];
        [pickerView selectRow:[_years intValue] inComponent:0 animated:YES];
        [pickerView selectRow:[_month intValue] inComponent:1 animated:YES];
    }
    return self;
}
#pragma mark- 数据源协议方法
//返回多少区
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //大数组中有几个小数组 就返回几个区
    return _bigArr.count;
}

//每一区返回多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    //  NSLog(@"component==%d",component);
    //1.根据区号component，取出其所对应的小数组
    NSArray *smallArr =_bigArr[component];
    
    //2.小数组中有几个元素 就返回几行
    return smallArr.count;
    
}
#pragma mark-
#pragma mark- 代理协议方法
//设置第component区row行的标题
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //1.根据区号component取出对应的小数组
    NSArray *smallArr =_bigArr[component];
    
    //2.从小数组中取出row行对应的内容
    NSString *str =smallArr[row];
    
    //3.返回要展示的内容
    DLog(@"======%@",str);
    return str;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSInteger rowCount2=[pickerView selectedRowInComponent:0];
    NSString * valuemin = [_yearsArray objectAtIndex:rowCount2];
    NSInteger rowCount3=[pickerView selectedRowInComponent:1];
    NSString * min = [_monthArray objectAtIndex:rowCount3];
    _Taketime=[NSString stringWithFormat:@"%@-%@",[valuemin substringToIndex:4],min];
    DLog(@"===11111===%@",_Taketime);
}

#pragma mark-截取时间
-(void)InterceptionTime{
    //        获取今天的小时
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _years=[formatter stringFromDate:date];
    _years= [NSString stringWithFormat:@"%@" ,[_years substringWithRange:NSMakeRange(0,4)]];
   
    
    //  获取今天的分钟
    NSDate *date1=[NSDate date];
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    _month = [formatter1 stringFromDate:date1];
    _month = [NSString stringWithFormat:@"%@", [_month substringWithRange:NSMakeRange(5,2)]];
    _month = [NSString stringWithFormat:@"%02d",[_month intValue] -1 ];
}
-(void)cancelBtnClick:(UIButton*)btn{
        _Taketime = nil;
    [self.delegate hisPickerView:self];
    
}
-(void)determineClick:(UIButton*)btn{
    DLog(@"=======%@",_Taketime);
//    if (_Taketime != nil) {
//        _Taketime = [NSString stringWithFormat:@"%@-%@",_years,_month];
//    }else{
//        _Taketime = nil;
//    }
    [self.delegate hisPickerView:self];
}

@end
