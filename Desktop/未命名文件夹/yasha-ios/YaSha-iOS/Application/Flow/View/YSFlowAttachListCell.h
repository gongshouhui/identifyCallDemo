//
//  YSFlowAttachListCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import <UIKit/UIKit.h>
#import "YSFlowAttachListModel.h"
#import "YSNewsAttachmentModel.h"
@interface YSFlowAttachListCell : UITableViewCell

@end


@interface YSFlowAttachPSListCell : UITableViewCell

@property (nonatomic, strong) YSFlowAttachPSListModel *cellModel;

@end


@interface YSFlowAttachFileListCell : UITableViewCell

@property (nonatomic, strong) YSNewsAttachmentModel *cellModel;

@end


@interface YSFlowAttachFlowListCell : UITableViewCell

@property (nonatomic, strong) YSFlowAttachFlowListModel *cellModel;

@end
