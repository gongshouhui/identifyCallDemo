//
//  YSFormRowModel.h
//  Form
//
//  Created by 方鹏俊 on 2017/11/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YSAreaPickerView.h"
#import "YSEMSProListModel.h"
#import "YSAreaPickerView.h"
typedef enum : NSUInteger {
    YSFormRowTypeTextField,    // 输入框
    YSFormRowTypeTextView,  // 输入视图
    YSFormRowTypeText,    // 描述信息
    
    YSFormRowTypeDatePicker,    // 日期选择器
    
    YSFormRowTypeSwitch,    // 选择开关
    YSFormRowTypeOptions,  // 多选项
    YSFormRowTypeSelectPerson,  // 选人，单选
    YSFormRowTypeSelectPeople,  // 选人，多选
    
    YSFormRowTypeLocation,  // 定位
    YSFormRowTypeAlbunm,  // 选择图片
} YSFormRowType;

typedef enum : NSUInteger {
    YSFormOptionsReturnKey,
    YSFormOptionsReturnValue,
} YSFormOptionsReturnType;

typedef enum : NSUInteger {
    YSCheckoutNone,
    YSCheckoutPhoneNumber,
    YSCheckoutEmail,
    YSCheckoutID,
} YSCheckoutType;

@interface YSFormRowModel : NSObject<NSMutableCopying>
/**是否显示,默认显示ishide = no */
@property (nonatomic,assign) BOOL isHidde;
/** 转换前的控件type（后台定义） */
@property (nonatomic, strong) NSString *type;
/** fieldName */
@property (nonatomic, strong) NSString *key;
/** filedId */
@property (nonatomic, strong) NSString *fieldId;
/** 图片名 */
@property (nonatomic, strong) NSString *imageName;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 唯一表示 */
@property (nonatomic, strong) NSString *fieldName;
/** 详情 */
@property (nonatomic, strong) NSString *detailTitle;
/**上传后台服务器对应的参数key值*/
@property (nonatomic,strong) NSString *paraKey;
/** 关联控件*/
@property (nonatomic, strong) NSArray *itemLinkeds;
/// 表示多选模式下已选中的item序号，默认为nil。此属性与 `selectedItemIndex` 互斥。
@property(nonatomic, strong) NSMutableSet<NSNumber *> *selectedItemIndexes;

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 键盘类型
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

@property (nonatomic, assign) YSFormRowType formRowType;

/**
 accessoryType的类型
 */
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

/**
 row的类名
 */
@property (nonatomic, strong) NSString *rowName;

/**
 是否允许编辑，默认NO，允许编辑
 */
@property (nonatomic, assign) BOOL disable;

/**
 textField占位符
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 显示允许输入的最大文字长度，默认为 NSUIntegerMax，也即不限制长度。
 */
@property (nonatomic, assign) NSUInteger maximumTextLength;

/**
 是否必填
 */
@property (nonatomic, assign) BOOL necessary;

/**
 是否有背景颜色
 */
@property (nonatomic, assign) BOOL backgroundColor;
/**
 提供跳转类名进行初始化跳转
 */
@property (nonatomic, strong) NSString *pushClassName;

/**
 跳转页面，给定需要跳转的页面
 */
@property (nonatomic, strong) UIViewController *jumpViewController;
/**需要跳转的页面*/
@property (nonatomic, strong) NSString *jumpClass;

/**
 选人（单选、多选）
*/
//@property (nonatomic, assign) YSFormRowSelectPeopleType selectPeopleType;

/**
 多选项数据源
 */
@property (nonatomic, strong) NSArray *optionsDataArray;

/**
 多选项数据源返回值类型
 */
@property (nonatomic, assign) YSFormOptionsReturnType optionsReturnType;

/**
 地址选择类型
 */
@property (nonatomic, assign) YSAreaPickerType areaPickerType;

/**
 时间格式
 */
@property (nonatomic, assign) PGDatePickerMode datePickerMode;

/**
 最小选择时间
 */
@property (nonatomic, strong) NSDate *minimumDate;

/**
 最大选择时间
 */
@property (nonatomic, strong) NSDate *maximumDate;

/**
 开关状态
 */
@property (nonatomic, assign) BOOL switchStatus;
@property (nonatomic,strong) NSString *switchStatusStr;

/**
 检验格式
 */
@property (nonatomic, assign) YSCheckoutType checkoutType;

/**
 控制小数点后面位数
 */
@property (nonatomic, assign) NSInteger countLimited;
/**项目情况*/
@property (nonatomic, strong) YSEMSProListModel *proListModel;
/**YSAddressModel*/
@property (nonatomic, strong) YSAddressModel *addressModel;
/**备注*/
@property (nonatomic, strong) NSString *remark;
/**图片*/
@property (nonatomic,strong) UIImage *image;
/**是否可以编辑 1可以编辑 0不可以编辑*/
@property (nonatomic, assign) NSInteger editable;

@end
