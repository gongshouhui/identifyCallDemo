//
//  YSNewsListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import <Foundation/Foundation.h>

@interface YSNewsListModel : NSObject

@property (nonatomic, strong) NSString *id;    // 新闻id
@property (nonatomic, strong) NSString *thumbImg;    // 图片地址
@property (nonatomic, strong) NSString *title;    // 标题
@property (nonatomic, strong) NSString *creatorName;    // 发布者
@property (nonatomic, strong) NSString *publicTimeStr;    // 新闻发布时间
@property (nonatomic, assign) BOOL hasAttachment;    // 是否有附件
@property (nonatomic, assign) BOOL alreadyRead;    // 是否已读
@property (nonatomic, assign) NSInteger visitCount;    // 阅读量
@property (nonatomic, strong) NSString *bannerId;    // 新闻id
@property (nonatomic, assign) NSInteger bannerType;    // banner类型
@property (nonatomic, strong) NSString *sourceUrl;    // 外链地址s

@end
