//
//  YSDeptTreePointModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/23.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSDeptTreePointModel : NSObject

@property (copy,nonatomic) NSString  *point_depth;  //节点深度
@property (assign, nonatomic) BOOL point_expand;  //节点展开与否
@property (copy, nonatomic) NSString  *point_id;//自身节点
@property (copy, nonatomic) NSString  *point_name;  //部门名称
@property (strong, nonatomic) NSString  *point_pid;  //父节点
@property (copy, nonatomic) NSString  *point_pidA;
@property (copy, nonatomic) NSString  *point_qNum;
@property (copy, nonatomic) NSString  *point_url;
@property (copy, nonatomic) NSString  *point_son;  //作为判断是否有子节点的条件
@property (strong, nonatomic) NSArray *point_son1; //子节点

- (instancetype)initWithPointDic:(NSDictionary *)pointDic;

@end

NS_ASSUME_NONNULL_END
