//
//  YSBaseBussinessFlowViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/2/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"
#import "YSContactModel.h"
@implementation YSBaseBussinessFlowViewModel

# pragma mark -- 懒加载
- (NSMutableArray *)fileArray {
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}
- (NSMutableArray *)attachArray {
    if (!_attachArray) {
        _attachArray = [NSMutableArray array];
    }
    return _attachArray;
}
- (NSMutableArray *)documentAr {
    if (!_documentAr) {
        _documentAr = [NSMutableArray array];
    }
    return _documentAr;
}
- (NSMutableArray *)postscriptArray {
    if (!_postscriptArray) {
        _postscriptArray = [NSMutableArray array];
    }
    return _postscriptArray;
}
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
- (NSString *)documentBtnTitle {
	return [NSString stringWithFormat:@"关联文档(%ld)",self.attachArray.count];
}
- (id)initWithFlowTpe:(YSFlowType)flowType andflowInfo:(id)flowModel {
    if (self = [super init]) {
        self.flowType = flowType;
        self.flowModel = flowModel;
        self.documentBtnTitle = @"关联文档(0)";
        self.associateBtnTitle = @"关联流程(0)";
    }
    return self;
}

#pragma mark - 获取提交者附言l
- (void)fetchPostscriptList:(fetchDataCompleteBlock)comleteBlock {
    NSString *urlStringPS = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPostscriptListApi, self.flowModel.businessKey];
    
    [YSNetManager ys_request_GETWithUrlString:urlStringPS isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1){
            for (NSDictionary *postscriptDic in response[@"data"]) {
                [self.postscriptArray addObject:@{@"content":postscriptDic[@"massage"],@"special":@(BussinessFlowCellText)}];
                [self.fileArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:postscriptDic[@"mobileFileVos"]]];
            }
            
            [self.attachArray addObjectsFromArray:self.fileArray];
            
            if (self.attachArray.count > 0 || self.fileArray.count > 0 ||self.documentAr.count > 0) {
                self.documentBtnTitle = [NSString stringWithFormat:@"关联文档(%lu)",self.attachArray.count];
               
            }
            if (comleteBlock) {
                comleteBlock();
            }
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
}
  //审批记录
- (void)fetchCommentsByProcess:(fetchDataCompleteBlock)comleteBlock{
  
    NSString *urlStringRecord = [NSString stringWithFormat:@"%@%@/%@/1", YSDomain, getCommentsByProcessInstanceIdApi, self.flowModel.processInstanceId];
    [YSNetManager ys_request_GETWithUrlString:urlStringRecord isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
              self.handleRecordArray = [[YSDataManager getFlowRecordListData:response] mutableCopy];
            if (comleteBlock) {
                comleteBlock();
            }
        }
      
        
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
- (void)fetchTurnReadList:(fetchDataCompleteBlock)comleteBlock{
    //转阅记录列表
    NSString *urlStringTurn = [NSString stringWithFormat:@"%@%@/%@/2", YSDomain, getCommentsByProcessInstanceIdApi, self.flowModel.processInstanceId];
  
    [YSNetManager ys_request_GETWithUrlString:urlStringTurn isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"转阅记录列表:%@", response);
        if ([response[@"code"] integerValue] == 1) {
             self.turnReadArray = [[YSDataManager getFlowRecordListData:response] mutableCopy];
            if (comleteBlock) {
                comleteBlock();
            }
        }
       
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
- (void)fetchAssociaterFlowList:(fetchDataCompleteBlock)comleteBlock{
    //关联流程
    NSString *urlStringAssociated = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getRelateFlowVo,self.flowModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlStringAssociated isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"关联流程列表:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.associaterArr = [NSArray yy_modelArrayWithClass:[YSFlowListModel class] json:response[@"data"]];
            self.associateBtnTitle = [NSString stringWithFormat:@"关联流程(%lu)",(unsigned long)self.associaterArr.count];
            if (comleteBlock) {
                comleteBlock();
            }
        }
       
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
#pragma mark - 获取放在单独接口的附件信息
- (void)fetchAssociaterDocumentList:(fetchDataCompleteBlock)comleteBlock
{
	//关联文档
	NSString *urlStringDocument = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getAttachmentApi, self.flowModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlStringDocument isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] integerValue] == 1) {
			self.documentAr = [[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:response[@"data"]] copy];
			if (self.documentAr.count > 0) {
				[self.attachArray addObjectsFromArray:self.documentAr];
				if (comleteBlock) {
					comleteBlock();
				}
			}
		}
	} failureBlock:^(NSError *error) {
	} progress:nil];
}
/** 处理流程状态改变,转阅类型和知会节点类型 手动调用节后，相当于流程处理操作
 如果是他人转阅的流程，查看时不可操作，并且调用流程处理接口返回时并删除该条数据，知会节点时，点击待办进入详情页会调用流程处理<做审批处理>接口，待办列表消失
 */
- (void)checkTrans {
    if (_flowType == YSFlowTypeTodo) {
        if (_flowModel.turnRead) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@/%lu", YSDomain, flowProcessApi, FlowHandleTypeTurnRead+1];
            NSDictionary *payload = @{
                                      @"message": @"",
                                      @"taskId": _flowModel.taskId,
                                      @"userIds": @[],
                                      @"processInstanceId": _flowModel.processInstanceId
                                      };
            [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
                if ([response[@"code"] intValue] == 1) {
                    NSDictionary *handleDic = @{
                                                @"flowType": [NSString stringWithFormat:@"%zd", _flowType],
                                                @"flowHandleType": [NSString stringWithFormat:@"%zd", FlowHandleTypeTurnRead],
                                                @"model": _flowModel
                                                };
                    //转阅已读  发通知改变状态
                    _flowModel.turnRead ? [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowStatus" object:nil userInfo:handleDic] : nil;
                }
            } failureBlock:^(NSError *error) {
                
            } progress:nil];
        }
        if ([_flowModel.taskType isEqualToString:FlowTaskZH]) {
         
            NSString *urlString = [NSString stringWithFormat:@"%@%@/%lu", YSDomain, flowProcessApi, FlowHandleTypeApproval+1];
            NSDictionary *payload = @{
                                      @"message": @"",
                                      @"taskId": _flowModel.taskId,
                                      @"userIds": @[],
                                      @"processInstanceId": _flowModel.processInstanceId
                                      };
            [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
                if ([response[@"code"] intValue] == 1) {
                    NSDictionary *handleDic = @{
                                                @"flowType": [NSString stringWithFormat:@"%zd", _flowType],
                                                @"flowHandleType": [NSString stringWithFormat:@"%zd", FlowHandleTypeApproval],
                                                @"model": _flowModel
                                                };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowStatus" object:nil userInfo:handleDic];
                }
            } failureBlock:^(NSError *error) {
                
            } progress:nil];
        }
    }
    
}
- (void)callPhone:(NSString *)userId withFailueBlock:(fetchDataFailueBlock)failBlock{
    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", userId]];
    //点击立即联系，直接拨打人员信息中的手机字段号码，不需确认，点击一次即呼出。
    //若人员的手机字段号码为空，则默认拨打座机号码字段内容，不需确认，点击一次即呼出。
    //若上述两个字段内容均为空，则提示暂无可用号码（参考设计样式）
    if (results.count != 0) {
        YSContactModel *contactModel = results[0];
        if (contactModel.mobile.length) {
            [YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.mobile];
        }else if (contactModel.phone.length) {
            [YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.phone];
        }else{
            if (failBlock) {
                failBlock(@"暂无可用号码");
            }
        }
    } else {
        if (failBlock) {
            failBlock(@"暂无可用号码");
        }
       
    }
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{
	
}
@end
