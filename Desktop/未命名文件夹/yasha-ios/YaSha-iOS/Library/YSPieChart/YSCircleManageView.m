//
//  YSCircleManageView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/4.
//

#import "YSCircleManageView.h"

@interface YSCircleManageView()

@property (nonatomic,assign) CGFloat Radius;
@property (nonatomic,assign) CGFloat PIE_HEIGHT;
@property (nonatomic,strong) YSCircleView *circleView;
@property (nonatomic,strong) id delegate;
@end

@implementation YSCircleManageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (kSCREEN_WIDTH==320&&kSCREEN_HEIGHT == 480) {
            self.Radius = 60.5;
            self.PIE_HEIGHT = frame.size.height;
        }else if (kSCREEN_WIDTH == 320 && kSCREEN_HEIGHT == 568){
            self.Radius = 60.5;
            self.PIE_HEIGHT = frame.size.height;
        }else if (kSCREEN_HEIGHT == 667 && kSCREEN_WIDTH == 375){
            self.Radius = 65.5;
            self.PIE_HEIGHT = frame.size.height;
        }else if (kSCREEN_HEIGHT == 736 && kSCREEN_WIDTH == 414){
            self.Radius = 70.5;
            self.PIE_HEIGHT = frame.size.height;
        }else{
            self.Radius = 70.5;
            self.PIE_HEIGHT = frame.size.height;
        }
    }
    return self;
}
-(void)loadDataArray:(NSArray *)dataArray withType:(MYHCircleManageViewType)type
{
    [_circleView removeFromSuperview];
    _circleView = nil;
    _circleView = [[YSCircleView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.PIE_HEIGHT) andWithDataArray:dataArray andWithCircleRadius:self.Radius type:type];
    _circleView.backgroundColor = [UIColor clearColor];
    [self addSubview:_circleView];
}


@end
