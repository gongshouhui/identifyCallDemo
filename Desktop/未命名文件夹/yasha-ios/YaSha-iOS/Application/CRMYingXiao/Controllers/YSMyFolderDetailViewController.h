//
//  YSMyFolderDetailViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSNewsAttachmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSMyFolderDetailViewController : YSCommonViewController
@property (nonatomic, strong) YSNewsAttachmentModel *attachmentModel;
@property (nonatomic, copy) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
