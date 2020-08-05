//
//  YSExpenseShareCell.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/7.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowExpensePexpShareModel.h"
//1.只用一个tableView应该采用插入cell和删除cell的方法来展开和收起
//2.用两个tableView 用model来记录展开收起的状态，点击时重新刷新数据
@interface YSExpenseShareCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,weak) UITableView *fatherTableView;
@property (nonatomic,strong) NSArray *dataArr;
@end
