//
//  YSApplicationCycleView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/23.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSApplicationCycleView.h"

@interface YSApplicationCycleView ()<SDCycleScrollViewDelegate>

@end

@implementation YSApplicationCycleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {

    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 147*(kSCREEN_WIDTH/375.0)) delegate:self placeholderImage:[UIImage imageNamed:@"benner"]];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cycleScrollView];
}

@end
