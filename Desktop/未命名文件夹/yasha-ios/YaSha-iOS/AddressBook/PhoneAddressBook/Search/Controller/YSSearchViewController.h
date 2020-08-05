//
//  YSSearchViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSChoosePeopleView.h"

@interface YSSearchViewController : YSCommonViewController

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,assign) int searchNumber;
@property (nonatomic,strong) YSChoosePeopleView *chooseView;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
