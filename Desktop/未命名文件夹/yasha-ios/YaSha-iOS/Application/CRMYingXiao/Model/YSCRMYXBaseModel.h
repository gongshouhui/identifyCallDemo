//
//  YSCRMYXBaseModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AccessoryViewType) {
    AccessoryViewTypeNone,//没有辅助视图
    AccessoryViewTypeDisclosureIndicator,//箭头btn
    AccessoryViewTypeDetailDisclosureButton,//点击按钮btn 人员选择
    AccessoryViewTypeDetailSwitchOFF,//Switch按钮 未选中
    AccessoryViewTypeDetailSwitchON,// Switch按钮选中
    AccessoryViewTypeMoney,//仅用作金额
};

NS_ASSUME_NONNULL_BEGIN

@interface YSCRMYXBaseModel : NSObject

@property (nonatomic, copy) NSString *nameStr;//左侧文字
@property (nonatomic, copy) NSString *holderStr;//右侧提示文字
@property (nonatomic, copy) NSString *textTF;

@property (nonatomic, assign) BOOL isTFEnabled;//输入框是否可以输入 默认是NO(可以输入)

@property (nonatomic, assign) AccessoryViewType accessoryView;//右侧按钮的样式
@property (nonatomic, assign) BOOL isMustWrite;//是否必填
@property (nonatomic, copy) NSString *currentyStr;//币种



@end


@interface YSCRMYXGEnumModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *code;//字典值
@property (nonatomic, copy) NSString *ifJson;///字典备注类型 0为文本，1为json
@property (nonatomic, copy) NSString *jsonRemark;//json格式文本
@property (nonatomic, copy) NSString *name;// 字典名称
@property (nonatomic, copy) NSString *remark;//备注
@property (nonatomic, copy) NSString *sortNo;//排序
@property (nonatomic, copy) NSString *typeCode;///字典所属分类
@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *flowCode;//流程编码

@property (nonatomic, copy) NSString *projectNo;//项目编号
@property (nonatomic, copy) NSString *projectName;//项目名称
@property (nonatomic, copy) NSString *staffNo;//项目经理工号






@end


NS_ASSUME_NONNULL_END
