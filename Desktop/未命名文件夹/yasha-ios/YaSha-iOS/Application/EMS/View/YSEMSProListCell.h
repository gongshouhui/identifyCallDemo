//
//  YSEMSProListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/21.
//

#import "YSCommonTableViewCell.h"
#import "YSEMSProListModel.h"

@interface YSEMSProListCell : YSCommonTableViewCell

@property (nonatomic, strong) YSEMSProListModel *cellModel;
@property (nonatomic, strong) RACSubject *sendSelectedSubject;
@end
