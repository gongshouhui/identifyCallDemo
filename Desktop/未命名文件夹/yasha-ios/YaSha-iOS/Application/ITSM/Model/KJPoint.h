//
//  KJPoint.h
//  TreeTableView
//
//  Created by mHome on 2017/7/4.
//  Copyright © 2017年 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJPoint : NSObject

@property (copy,nonatomic)NSString  *point_depth;  //知识点深度
@property (assign,nonatomic)BOOL    point_expand;  //知识点展开与否

@property (copy,nonatomic)NSString  *point_id;   //判断是否有问题描述
@property (copy,nonatomic)NSString  *point_knowid; //子节点
@property (copy,nonatomic)NSString  *point_name;  //问题名称
@property (strong,nonatomic)NSString  *point_pid;  //父节点
@property (copy,nonatomic)NSString  *point_pidA;
@property (copy,nonatomic)NSString  *point_qNum;
@property (copy,nonatomic)NSString  *point_url;
@property (copy,nonatomic)NSString  *point_son;  //作为判断是否有子节点的条件
@property (strong,nonatomic)NSArray *point_son1; //子知识点

-(instancetype)initWithPointDic:(NSDictionary *)pointDic;

@end
