//
//  YSFormRowModel.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormRowModel.h"

@implementation YSFormRowModel
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    YSFormRowModel *model  = [[[self class]allocWithZone:zone]init];
    model.isHidde = self.isHidde;
    model.disable = self.disable;
    model.type = self.type;
    model.fieldName = self.fieldName;
    model.key = self.key;
    model.imageName = self.imageName;
    model.title = self.title;
    model.detailTitle = self.detailTitle;
    model.indexPath = self.indexPath;
    model.accessoryType = self.accessoryType;
        model.selectedItemIndexes = self.selectedItemIndexes;
        model.keyboardType = self.keyboardType;
        model.formRowType = self.formRowType;
        model.rowName = self.rowName;
        model.placeholder = self.placeholder;
        model.maximumTextLength = self.maximumTextLength;
        model.necessary = self.necessary;
        model.pushClassName = self.pushClassName;
        model.jumpViewController = self.jumpViewController;
        model.optionsDataArray = self.optionsDataArray;
        model.optionsReturnType = self.optionsReturnType;
        model.areaPickerType = self.areaPickerType;
        model.datePickerMode = self.datePickerMode;
        model.minimumDate = self.minimumDate;
        model.maximumDate = self.maximumDate;
        model.switchStatus = self.switchStatus;
        model.switchStatusStr = self.switchStatusStr;
    
    
    model.checkoutType = self.checkoutType;
    model.countLimited = self.countLimited;
    model.proListModel = self.proListModel;
    model.addressModel = self.addressModel;
    model.remark = self.remark;
    model.jumpClass = self.jumpClass;
    
    
    return model;
}

@end
