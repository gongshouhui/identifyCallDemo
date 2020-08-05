//
//  YSReportFolderAddViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSNewsAttachmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSReportFolderAddViewController : YSCommonTableViewController
@property (nonatomic, strong) NSMutableArray *addFolderArray;//以前选中的文件
@property(nonatomic,copy) void (^addFolderBlock)(NSMutableArray *addFolderArray);//选中的文件回调(包含以前选中的)
@property (nonatomic, strong) NSMutableArray *fileNetworkArray;//上级网络请求返回的文件 (只做删除跟预览 没有下载跟上传)

@end

NS_ASSUME_NONNULL_END
