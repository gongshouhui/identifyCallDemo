//
//  YSFlowAssetsApplyFormModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/13.
//

#import "YSFlowAssetsApplyFormModel.h"
#import "YSNewsAttachmentModel.h"
@implementation YSFlowAssetsApplyFormModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baseInfo": YSFlowFormHeaderModel.class,
             @"info": YSFlowAssetsApplyFormListModel.class,
             @"apply": YSFlowAssetsApplyFormListModel.class
             };
}

@end


@implementation YSFlowAssetsApplyFormListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"applyInfos" : [YSFlowAssetsApplyFormApplyInfosModel class],
             @"accounts" : [YSFlowAssetsApplyFormApplyInfosModel class],
             @"handleDetails" : [YSFlowAssetsApplyFormApplyInfosModel class],
             @"admitPersons":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"scores":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"admitElectrons":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"represents":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"operates":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"categorys":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"admitScoreCounts":[YSFlowAssetsApplyFormApplyInfosModel class],
           
             @"personApplyRequire":[YSFlowAssetsApplyFormApplyInfosModel class],
             @"mqPersonApply":[YSFlowAssetsApplyFormListModel class],
             @"ObaseInfo":[YSFlowAssetsApplyFormListModel class],
             @"IbaseInfo":[YSFlowAssetsApplyFormListModel class],
             @"mqPersonAllot":[YSFlowAssetsApplyFormListModel class],
             @"baseInfo":[YSFlowAssetsApplyFormListModel class],
             @"mobileFiles":[YSNewsAttachmentModel class],
             @"mobileFilesList":[YSNewsAttachmentModel class],
             @"zsjyfj":[YSNewsAttachmentModel class],
             @"mobileFilesQpList":[YSNewsAttachmentModel class],
             @"franCategoryString":[NSString class],
             @"pexpShareList":[YSFlowExpensePexpShareModel class],
             @"marketPexpShareList":[YSFlowExpensePexpShareModel class]
             };
    
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"companyDept" : @"copyDept",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"ownProject"] isEqual:[NSNull null]]) {
        _ownProject = @"";
    }
    if ([dic[@"managerName"] isEqual:[NSNull null]]) {
        _managerName = @"";
    }
    if ([dic[@"proNature"] isEqual:[NSNull null]]) {
        _proNature = @"";
    }
    return YES;
}

@end


@implementation YSFlowAssetsApplyFormApplyInfosModel

- (void)setValue:(id)value forKey:(NSString *)key{
    
    //手动处理description
    if ([key isEqualToString: @"description"]) {
        _desc = value;
    }else{
        //调用父类方法，保证其他属性正常加载
        [super setValue:value forKey:key];
    }
 
}

@end

