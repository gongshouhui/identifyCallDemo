//
//  YSEMSAddTripViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/20.
//

#import "YSCommonViewController.h"
#import "YSEMSProListModel.h"
#import "YSPersonalInformationModel.h"

@interface YSEMSAddTripViewController : YSCommonViewController
/**出差详情*/
@property (nonatomic, weak) NSMutableArray *emsArr;
/**行程 数据源*/
@property (nonatomic, strong) NSMutableArray *tripInfoArray;
/**是否是编辑模式*/
@property (nonatomic, assign) BOOL isEditing;
/**编辑所在的indexPath*/
@property (nonatomic, strong) NSIndexPath *editingIndexPath;

/**添加流程orderNo = self.configArray.count，编辑时好像是1，1或2*/
@property (nonatomic, strong) NSString *orderNo;
/**是否有项目*/
@property (nonatomic, strong) YSEMSProListModel *proListModel;
/**个人信息*/
@property (nonatomic,strong) YSPersonalInformationModel *personmModel;
/**后台参数*/
@property (nonatomic, strong) NSMutableDictionary *payload;
@end
