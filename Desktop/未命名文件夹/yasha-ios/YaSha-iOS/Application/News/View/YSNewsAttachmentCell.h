//
//  YSNewsAttachmentCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/30.
//

#import <UIKit/UIKit.h>
#import "YSNewsAttachmentModel.h"

@interface YSNewsAttachmentCell : UITableViewCell

@property (nonatomic, strong) YSNewsAttachmentModel *cellModel;

- (void)setElectronicData:(NSArray *)array;

- (void)setAttachmentData:(NSArray *)array;

@end
