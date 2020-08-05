//
//  YSEMSProListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/21.
//

#import <Foundation/Foundation.h>

@interface YSEMSProListModel : NSObject

@property (nonatomic, strong) NSString *name;//项目名称
@property (nonatomic, strong) NSString *proManName;//项目经理
@property (nonatomic, strong) NSString *id;//项目id
@property (nonatomic, strong) NSString *code;//项目编码
@property (nonatomic, strong) NSString *proCompId;//公司
@property (nonatomic, strong) NSString *proManId;//项目人员工号
@property (nonatomic, strong) NSString *proNatureCode;
@property (nonatomic,strong) NSString *proNature;

@property (nonatomic, assign) BOOL isSelected;

@end
