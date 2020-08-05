//
//  YSNewsAttachmentModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/30.
//

#import <Foundation/Foundation.h>

@interface YSNewsAttachmentModel : NSObject

@property (nonatomic, strong) NSString *fileName;    // 附件名称
@property (nonatomic, assign) CGFloat fileSize;    //  附件大小
@property (nonatomic, assign) NSInteger fileType;    // 附件类型
@property (nonatomic, strong) NSString *viewPath;    // 预览地址
@property (nonatomic, strong) NSString *filePath;    // 下载地址
@property (nonatomic,strong) NSString *createTime;//上传时间

// CRM选择文件
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;//文件名


@property (nonatomic, strong) UIImage *choseImg;
@property (nonatomic, strong) NSDictionary *crmProFilesListDic;//上传服务器 返回的文件信息

/*文件类型
 0 word
 1 ppt
 2 excel
 3 txt
 4 img
 5 mp3
 6 pdf
 7 zip
 */


@end
