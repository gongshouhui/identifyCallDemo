//
//  Node.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  每个节点类型
 */
@interface Node : NSObject

@property (nonatomic , strong) NSString * parentId;//父节点的id，如果为-1表示该节点为根节点

@property (nonatomic , strong) NSString * nodeId;//本节点的id

@property (nonatomic , strong) NSString *name;//本节点的名称

@property (nonatomic , assign) int depth;//该节点的深度

@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态

@property (nonatomic ,strong) NSString * sonFlag;

@property (nonatomic,strong)  NSString *classCode;

@property (nonatomic,strong) NSString *linkCode;

/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId : (NSString *)parentId nodeId : (NSString *)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand sonFlag :(NSString *)sonFlag  classCode :(NSString *)classCode  linkCode :(NSString *)linkCode;

@end
