//
//  YSBaseBussinessFlowViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/2/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSFlowListModel.h"
#import "YSFlowFormModel.h"
#import "YSNewsAttachmentModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^fetchDataCompleteBlock)();
typedef void(^fetchDataFailueBlock)(NSString *message);
@interface YSBaseBussinessFlowViewModel : NSObject
/**网络请求提示语*/
@property (nonatomic,strong) NSString *toast;
/**待办类型*/
@property (nonatomic, assign) YSFlowType flowType;
@property (nonatomic,strong)  YSFlowListModel *flowModel;
@property (nonatomic,strong) YSFlowFormModel *flowFormModel;
/**附件列表,包含关联文档*/
@property (nonatomic, strong) NSMutableArray *attachArray;
/**审批记录列表*/
@property (nonatomic,strong) NSMutableArray *handleRecordArray;
/**转阅记录列表*/
@property (nonatomic,strong) NSMutableArray *turnReadArray;
/**附言记录列表*/
@property (nonatomic,strong) NSMutableArray *postscriptArray;
/**表单数据列表*/
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
/**关联流程列表*/
@property (nonatomic,copy) NSArray *associaterArr; //
/**关联文档列表*/
@property (nonatomic,strong) NSMutableArray *documentAr;   //关联文档
/**文档title*/
@property (nonatomic,strong) NSString *documentBtnTitle;
/**关联文档title*/
@property (nonatomic,strong) NSString *associateBtnTitle;
/**附言附件*/
@property (nonatomic,strong) NSMutableArray *fileArray;//目前附言附件是和关联文档附件分开放的
- (id)initWithFlowTpe:(YSFlowType) flowType andflowInfo:(YSFlowListModel *)flowModel;
/**处理流程状态改变,转阅类型和知会节点类型 手动调用节后，相当于流程处理操作*/
- (void)checkTrans;
/**获取提交者附言*/
- (void)fetchPostscriptList:(fetchDataCompleteBlock)comleteBlock;
/**获取审批记录*/
- (void)fetchCommentsByProcess:(fetchDataCompleteBlock)comleteBlock;
/**获取转阅记录*/
- (void)fetchTurnReadList:(fetchDataCompleteBlock)comleteBlock;
/**获取关联流程信息*/
- (void)fetchAssociaterFlowList:(fetchDataCompleteBlock)comleteBlock;
/**获取全部的关联文档*/
- (void)fetchAssociaterDocumentList:(fetchDataCompleteBlock)comleteBlock;

- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock;
- (void)callPhone:(NSString *)userId withFailueBlock:(fetchDataFailueBlock)failBlock;
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
