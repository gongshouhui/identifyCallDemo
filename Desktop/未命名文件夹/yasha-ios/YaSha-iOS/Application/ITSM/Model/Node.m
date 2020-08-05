//
//  Node.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)initWithParentId : (NSString *)parentId nodeId : (NSString *)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand sonFlag :(NSString *)sonFlag classCode :(NSString *)classCode linkCode :(NSString *)linkCode{
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        self.sonFlag = sonFlag;
        self.classCode = classCode;
        self.linkCode = linkCode;
    }
    return self;
}

@end
