//
//  YSMangEntryPosityTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTeamCompilePostModel.h"//编制/离职model
NS_ASSUME_NONNULL_BEGIN

@interface YSMangEntryPosityTableViewCell : UITableViewCell
@property (nonatomic, strong) YSTeamCompilePostModel *compileModel;//编制
@property (nonatomic, strong) YSTeamCompilePostModel *postEntyModel;//入/离职
@property (nonatomic, strong) YSTeamCompilePostModel *postLeaveModel;


@property (nonatomic, strong) YSTeamCompilePostModel *workModel;//在岗


@end

NS_ASSUME_NONNULL_END
