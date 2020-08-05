//
//  YSMineFloderTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "SWTableViewCell.h"
#import "YSNewsAttachmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSMineFloderTableViewCell : SWTableViewCell

@property (nonatomic, strong) UIButton *choseBtn;
@property (nonatomic, strong) UIImageView *holderImg;
@property (nonatomic, strong) YSNewsAttachmentModel *folderModel;
@property (nonatomic, strong) YSNewsAttachmentModel *folderNetworkModel;


@end

NS_ASSUME_NONNULL_END
