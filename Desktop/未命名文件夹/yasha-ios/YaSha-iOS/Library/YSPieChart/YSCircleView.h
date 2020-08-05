//
//  YSCircleView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/4.
//

#import <UIKit/UIKit.h>
#import "YSPMSPlanInfoViewController.h"

typedef NS_OPTIONS(NSUInteger, MYHCircleManageViewType) {
    MYHCircleManageViewTypeArc, //圆弧
    MYHCircleManageViewTypeRound //圆
};

@interface YSCircleView : UIView

@property(nonatomic , assign) CGRect fFrame;
@property(nonatomic , strong) NSMutableArray *dataArray; //数据数组
@property(nonatomic , assign) CGFloat circleRadius;//半径
//初始化
-(instancetype)initWithFrame:(CGRect)frame andWithDataArray:(NSArray *)dataArr andWithCircleRadius:(CGFloat)circleRadius type:(MYHCircleManageViewType)type;
@end




@interface YSRadiusRange : NSObject

@property (nonatomic, assign) CGFloat startRadiu;//度数
@property (nonatomic, assign)  CGFloat endRadiu;
@property(nonatomic,assign) YSConstructionProgressType progressType;
@end


