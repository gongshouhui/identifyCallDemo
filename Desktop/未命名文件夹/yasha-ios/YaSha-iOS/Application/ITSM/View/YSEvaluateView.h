//
//  YSEvaluateView.h
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import <UIKit/UIKit.h>
#import "StarRateView.h"

typedef void  (^myBlock)(NSString *classStr , NSString *linkCode , NSString *classCode ,NSString * str);

@interface YSEvaluateView : UIView

@property (nonatomic,strong) StarRateView *starRateView1;

@property (nonatomic,strong) StarRateView *starRateView2;

@property (nonatomic,strong) StarRateView *starRateView3;

@property (nonatomic,copy) myBlock block;

@property (nonatomic,strong) NSString *respondSpeed;

@property (nonatomic,strong) NSString *solveSpeed;

@property (nonatomic,strong) NSString *serviceAttitude;


@end
