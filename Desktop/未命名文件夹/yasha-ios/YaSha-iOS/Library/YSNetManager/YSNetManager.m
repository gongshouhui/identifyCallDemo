//
//  YSNetManager.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/6.
//

#import "YSNetManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

/*! 系统相册 */
#import <Photos/Photos.h>
//#import <AssetsLibrary/ALAsset.h>
//#import <AssetsLibrary/ALAssetsLibrary.h>
//#import <AssetsLibrary/ALAssetsGroup.h>
//#import <AssetsLibrary/ALAssetRepresentation.h>


#import "UIImage+CompressImage.h"
#import "YSNetManagerCache.h"
#import "YSDataEntity.h"

#import "AppDelegate.h"
#import "AppDelegate+YSSetupAPP.h"

static NSMutableArray *tasks;

//static void *isNeedCacheKey = @"isNeedCacheKey";

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif

@interface YSNetManager ()



@end

@implementation YSNetManager

+ (instancetype)sharedYSNetManager {
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedYSNetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedYSNetManager = [[super allocWithZone:NULL] init];
    });
    return sharedYSNetManager;
}

+ (void)initialize {
    [self setupYSNetManager];
}

+ (void)setupYSNetManager {
    YSNetManagerShare.sessionManager = [AFHTTPSessionManager manager];
    ////测试
     YSNetManagerShare.sessionManager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:YSDomain]];//URL就是你们服务器的URL前缀
    //ce
    YSNetManagerShare.requestSerializer = YSHttpRequestSerializerJSON;
    YSNetManagerShare.responseSerializer = YSHttpResponseSerializerJSON;
    
    /*! 设置请求超时时间，默认：30秒 */
    YSNetManagerShare.timeoutInterval = 60;
    /*! 打开状态栏的等待菊花 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 设置返回数据类型为 json, 分别设置请求以及相应的序列化器 */
    /*!
     根据服务器的设定不同还可以设置：
     json：[AFJSONResponseSerializer serializer](常用)
     http：[AFHTTPResponseSerializer serializer]
     */
    //    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //    /*! 这里是去掉了键值对里空对象的键值 */
    ////    response.removesKeysWithNullValues = YES;
    //    YSNetManagerShare.sessionManager.responseSerializer = response;
    
    /* 设置请求服务器数类型式为 json */
    /*!
     根据服务器的设定不同还可以设置：
     json：[AFJSONRequestSerializer serializer](常用)
     http：[AFHTTPRequestSerializer serializer]
     */
    //        AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
    //        YSNetManagerShare.sessionManager.requestSerializer = request;
    /*! 设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
    //        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
    
    /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    //       YSNetManagerShare.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [YSNetManagerShare.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*! 设置响应数据的基本类型 */
    YSNetManagerShare.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"image/*", @"image/png", nil];
    // 配置自建证书的Https请求

//    [self ys_setupSecurityPolicy];



}

/**
 配置自建证书的Https请求，只需要将CA证书文件放入根目录就行
 */
+ (void)ys_setupSecurityPolicy {
    //    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    
    if (cerSet.count == 0)
    {
        /*!
         采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
         */
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        YSNetManagerShare.sessionManager.securityPolicy = securityPolicy;
    } else {
        /*! 自定义的CA证书配置如下： */
        /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
        /*!
         https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
        // 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        // 如果需要验证自建证书(无效证书)，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        // 是否需要验证域名，默认为YES
        //    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
        
        YSNetManagerShare.sessionManager.securityPolicy = securityPolicy;
        
        
        /*! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉: */
        //            NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //            AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //            policy.allowInvalidCertificates = YES;
        //            YSNetManagerShare.sessionManager.securityPolicy = policy;
    }
}

/**
 网络请求的实例方法 get
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progress 进度
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_request_GETWithUrlString:(NSString *)urlString
                                      isNeedCache:(BOOL)isNeedCache
                                       parameters:(NSDictionary *)parameters
                                     successBlock:(YSResponseSuccess)successBlock
                                     failureBlock:(YSResponseFail)failureBlock
                                         progress:(YSDownloadProgress)progress {
    return [self ys_requestWithType:YSHttpRequestTypeGet isNeedCache:isNeedCache urlString:urlString parameters:parameters successBlock:successBlock failureBlock:failureBlock progress:progress];
}

/**
 网络请求的实例方法 post
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progress 进度
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_request_POSTWithUrlString:(NSString *)urlString
                                       isNeedCache:(BOOL)isNeedCache
                                        parameters:(NSDictionary *)parameters
                                      successBlock:(YSResponseSuccess)successBlock
                                      failureBlock:(YSResponseFail)failureBlock
                                          progress:(YSDownloadProgress)progress {
    return [self ys_requestWithType:YSHttpRequestTypePost isNeedCache:isNeedCache urlString:urlString parameters:parameters successBlock:successBlock failureBlock:failureBlock progress:progress];
}

/**
 网络请求的实例方法 put
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progress 进度
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_request_PUTWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                     successBlock:(YSResponseSuccess)successBlock
                                     failureBlock:(YSResponseFail)failureBlock
                                         progress:(YSDownloadProgress)progress {
    return [self ys_requestWithType:YSHttpRequestTypePut isNeedCache:NO urlString:urlString parameters:parameters successBlock:successBlock failureBlock:failureBlock progress:progress];
}

/**
 网络请求的实例方法 delete
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progress 进度
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_request_DELETEWithUrlString:(NSString *)urlString
                                          parameters:(NSDictionary *)parameters
                                        successBlock:(YSResponseSuccess)successBlock
                                        failureBlock:(YSResponseFail)failureBlock
                                            progress:(YSDownloadProgress)progress {
    return [self ys_requestWithType:YSHttpRequestTypeDelete isNeedCache:NO urlString:urlString parameters:parameters successBlock:successBlock failureBlock:failureBlock progress:progress];
}

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/*!
 *  网络请求的实例方法
 *
 *  @param type         get / post / put / delete
 *  @param isNeedCache  是否需要缓存，只有 get / post 请求有缓存配置
 *  @param urlString    请求的地址
 *  @param parameters    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
+ (YSURLSessionTask *)ys_requestWithType:(YSHttpRequestType)type
                             isNeedCache:(BOOL)isNeedCache
                               urlString:(NSString *)urlString
                              parameters:(NSDictionary *)parameters
                            successBlock:(YSResponseSuccess)successBlock
                            failureBlock:(YSResponseFail)failureBlock
                                progress:(YSDownloadProgress)progress {
    if (urlString == nil) {
        return nil;
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    YSWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        case 2:
            requestType = @"PUT";
            break;
        case 3:
            requestType = @"DELETE";
            break;
            
        default:
            break;
    }
    
    AFHTTPSessionManager *scc = YSNetManagerShare.sessionManager;
    AFHTTPResponseSerializer *scc2 = scc.responseSerializer;
    AFHTTPRequestSerializer *scc3 = scc.requestSerializer;
    NSTimeInterval timeoutInterval = YSNetManagerShare.timeoutInterval;
    //设置请求头信息
    YSNetManagerShare.httpHeaderFieldDictionary = [YSUtility getHTTPHeaderFieldDictionary];//每一次请求动态设置头信息更新APP后依然可获得最新的版本号（如果放在某处设置---头信息主要在登录后修改，版本更新修改）），
    
    NSString *isCache = isNeedCache ? @"开启":@"关闭";
    CGFloat allCacheSize = [YSNetManagerCache ys_getAllHttpCacheSize];
    
    DLog(@"\n******************** 请求参数 ***************************");
    DLog(@"\n请求头: %@\n超时时间设置：%.1f 秒【默认：30秒】\nAFHTTPResponseSerializer：%@【默认：AFJSONResponseSerializer】\nAFHTTPRequestSerializer：%@【默认：AFJSONRequestSerializer】\n请求方式: %@\n请求URL: %@\n请求param: %@\n是否启用缓存：%@【默认：开启】\n目前总缓存大小：%.6fM\n", YSNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, timeoutInterval, scc2, scc3, requestType, URLString, parameters, isCache, allCacheSize);
    DLog(@"\n------请求URL:%@\n,\n请求param: %@\n",urlString,parameters);
    DLog(@"\n********************************************************");
    
    NSDictionary *infoDic = @{
    @"requestHeader":YSNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders,
        @"urlString":urlString,
        @"param":parameters?parameters:@""
    
    };
    
    YSURLSessionTask *sessionTask = nil;
    
   
    if (isNeedCache) {
        // 读取缓存,如果将来做缓存这里就要写异步读取逻辑
        id responseCacheData = [YSNetManagerCache ys_httpCacheWithUrlString:urlString parameters:parameters];
        
        if (successBlock &&  responseCacheData != nil) {
            successBlock(responseCacheData);
        }
        
        [[weakSelf tasks] removeObject:sessionTask];
        return nil;
    }
    
    if (type == YSHttpRequestTypeGet) {
        sessionTask = [YSNetManagerShare.sessionManager GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
           
            if (successBlock) {
                successBlock(responseObject);
            }
            [self isOverdue:responseObject WithRequestInfo:infoDic];//统一处理code的一些状态
            // 对数据进行异步缓存
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [YSNetManagerCache ys_setHttpCache:responseObject urlString:urlString parameters:parameters];
            });
           
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"请求error---%@",error);
            DLog(@"\n------请求URL:%@\n,\n请求param: %@\n",urlString,parameters);
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
        
    }
    else if (type == YSHttpRequestTypePost) {
        sessionTask = [YSNetManagerShare.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self isOverdue:responseObject WithRequestInfo:infoDic];
            if (successBlock) {
                successBlock(responseObject);
            }
            
            // 对数据进行异步缓存
            // 对数据进行异步缓存
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [YSNetManagerCache ys_setHttpCache:responseObject urlString:urlString parameters:parameters];
            });
           
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock){
                failureBlock(error);
            }
            DLog(@"请求error---%@",error);
            DLog(@"\n------请求URL:%@\n,\n请求param: %@\n",urlString,parameters);
        }];
    } else if (type == YSHttpRequestTypePut) {
        sessionTask = [YSNetManagerShare.sessionManager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self isOverdue:responseObject WithRequestInfo:infoDic];
            if (successBlock) {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    else if (type == YSHttpRequestTypeDelete) {
        sessionTask = [YSNetManagerShare.sessionManager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self isOverdue:responseObject WithRequestInfo:infoDic];
            if (successBlock) {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    
    if (sessionTask) {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}
#pragma mark - 请求失败统一处理
+ (void)isOverdue:(id)responseObject WithRequestInfo:(NSDictionary *)info {
    DLog(@"请求信息-----%@",info);
    //3:解析失败，跳登录, 2授权过期 0：错误 4：强制更新
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([responseObject[@"code"] intValue] == 2 || [responseObject[@"code"] intValue] == 3) {
        [YSUtility logout];
        [delegate setLoginControllerWithAlert:YES];
    } else if ([responseObject[@"code"] intValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *showView = [YSUtility getCurrentViewController].view;
            if (!showView) {
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                showView = window;
            }
            [QMUITips showError:responseObject[@"msg"] ? responseObject[@"msg"] : @"获取数据失败" inView:showView hideAfterDelay:1.5];
            DLog(@"请求失败msg-----%@---请求信息-----%@",responseObject[@"msg"],info);
        });
        
    }else if ([responseObject[@"code"] intValue] == 4) {//强制更新
        DLog(@"---请求信息-----%@",info);
        
        //检查更新
        [delegate updateAPPWithAlert:YES];
    }
}

/**
 上传图片(多图)
 
 @param urlString 上传的url
 @param parameters 上传图片预留参数---视具体情况而定 可移除
 @param imageArray 上传的图片数组
 @param fileName 上传的图片数组fileName
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progress 上传进度
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                       imageArray:(NSArray *)imageArray
                                         file:(NSString *)file
                                     successBlock:(YSResponseSuccess)successBlock
                                      failurBlock:(YSResponseFail)failureBlock
                                   upLoadProgress:(YSUploadProgress)progress {
    if (urlString == nil) {
        return nil;
    }
    
    YSWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    DLog(@"******************** 请求参数 ***************************");
    DLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",YSNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"POST",URLString, parameters);
    DLog(@"******************************************************");
    
    YSURLSessionTask *sessionTask = nil;
    sessionTask = [YSNetManagerShare.sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0 ; i < imageArray.count;i++) {
		NSData *data = [imageArray[i] compressWithMaxLength:500*1024];//压缩图片
//			NSData *data = UIImageJPEGRepresentation(imageArray[i], 1);
//			data = UIImageJPEGRepresentation(imageArray[i], 1024*1024/data.length);
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageName = [NSString stringWithFormat:@"%d%@.png",i,str];
            [formData appendPartWithFileData:data name:file fileName:imageName mimeType:@"image/png"];
        }
        
		
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"上传图片成功 = %@",responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
        
        [[weakSelf tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        [[weakSelf tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask) {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}


/**
 上传文件
 
 @param urlString 上传的url
 @param parameters 上传文件预留参数---视具体情况而定 可移除
 @param fileArray 上传的文件模型
 @param file 上传的文件数组file,服务器接收地址
 @param fileType 上传的文件的类型
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progress 上传进度
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_uploadFileWithUrlString:(NSString *)urlString
                                      parameters:(NSDictionary *)parameters
                                      fileModelArray:(NSArray *)fileArray
                                            file:(NSString *)file
                                        fileType:(NSString *)fileType
                                    successBlock:(YSResponseSuccess)successBlock
                                     failurBlock:(YSResponseFail)failureBlock
                                  upLoadProgress:(YSUploadProgress)progress {
    if (urlString == nil) {
        return nil;
    }
    
    YSWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    DLog(@"******************** 请求参数 ***************************");
    DLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",YSNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"POST",URLString, parameters);
    DLog(@"******************************************************");
        YSURLSessionTask *sessionTask = nil;
        sessionTask = [YSNetManagerShare.sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i = 0 ; i < fileArray.count;i++) {//新的考勤流程
                NSError *newError;
                YSNewsAttachmentModel *fileModel = fileArray[i];
                if (fileModel.fileType == 4) {//为4是图片 压缩下
                    NSData *data = UIImageJPEGRepresentation(fileModel.choseImg, 1.0);//0.5?
                    [formData appendPartWithFileData:data name:file fileName:fileModel.fileName mimeType:@"image/png"];

                }else {//其他文件
                    NSString *filePathStr = [AttachmentFolderPath stringByAppendingPathComponent:fileModel.viewPath];
                    NSURL *pathUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", [self strUTF8Encoding:filePathStr]]];
                    [formData appendPartWithFileURL:pathUrl name:file fileName:fileModel.fileName mimeType:@"application/octet-stream" error:&newError];
                }
            NSLog(@"文件上传错误信息:%@", newError);
                
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            //NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            
            if (progress) {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
        }];
        
        if (sessionTask) {
            [[weakSelf tasks] addObject:sessionTask];
        }
        
        return sessionTask;
}
/*
// 清除因上传缓存的视频
+ (void)clearMovieFromDoucmentsWithFilePath:(NSString*)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        DLog(@"%@",filename);
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"mov"]) {
            DLog(@"删除%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
*/
/**
 视频上传
 
 @param urlString 上传的url
 @param parameters 上传视频预留参数---视具体情况而定 可移除
 @param videoPath 上传视频的本地沙河路径
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param progress 上传的进度
 */
+ (void)ys_uploadVideoWithUrlString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                          videoPath:(NSString *)videoPath
                       successBlock:(YSResponseSuccess)successBlock
                       failureBlock:(YSResponseFail)failureBlock
                     uploadProgress:(YSUploadProgress)progress {
    /*! 获得视频资源 */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoPath]  options:nil];
    
    /*! 压缩 */
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    /*! 创建日期格式化器 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /*! 转化后直接写入Library---caches */
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted:
            {
                [YSNetManagerShare.sessionManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", outfilePath]];
                    // 获得沙盒中的视频内容
                    [formData appendPartWithFileURL:filePathURL2 name:@"video" fileName:outfilePath mimeType:@"application/octet-stream" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    //NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                    if (progress)
                    {
                        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    NSLog(@"上传视频成功 = %@",responseObject);
                    if (successBlock)
                    {
                        successBlock(responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"上传视频失败 = %@", error);
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - ***** 文件下载
/**
 文件下载
 
 @param urlString 请求的url
 @param parameters 文件下载预留参数---视具体情况而定 可移除
 @param savePath 下载文件保存路径
 @param successBlock 下载文件成功的回调
 @param failureBlock 下载文件失败的回调
 @param progress 下载文件的进度显示
 @return YSURLSessionTask
 */
+ (YSURLSessionTask *)ys_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                          savaPath:(NSString *)savePath
                                      successBlock:(YSResponseSuccess)successBlock
                                      failureBlock:(YSResponseFail)failureBlock
                                  downLoadProgress:(YSDownloadProgress)progress {
    if (urlString == nil) {
        return nil;
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    DLog(@"******************** 请求参数 ***************************");
    DLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",YSNetManagerShare.sessionManager.requestSerializer.HTTPRequestHeaders, @"download",urlString, parameters);
    DLog(@"******************************************************");
    
    
    YSURLSessionTask *sessionTask = nil;
    
    sessionTask = [YSNetManagerShare.sessionManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        DLog(@"下载进度：%.2lld%%",100 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progress)
            {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!savePath) {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        } else {
            return [NSURL fileURLWithPath:savePath];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self tasks] removeObject:sessionTask];
        
        NSLog(@"下载文件成功");
        if (error == nil) {
            if (successBlock) {
                /*! 返回完整路径 */
                successBlock([filePath path]);
            }
        }else {
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

#pragma mark - 网络状态监测
/*!
 *  开启网络监测
 */
+ (void)ys_startNetWorkMonitoringWithBlock:(YSNetworkStatusBlock)networkStatus {
    /*! 1.获得网络监控的管理者 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*! 当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 2.设置网络状态改变后的处理 */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*! 当网络状态改变了, 就会调用这个block */
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                networkStatus ? networkStatus(YSNetworkStatusUnknown) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                networkStatus ? networkStatus(YSNetworkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                networkStatus ? networkStatus(YSNetworkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi 网络");
                networkStatus ? networkStatus(YSNetworkStatusReachableViaWiFi) : nil;
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ys_cancelAllRequest {
    // 锁操作
    @synchronized(self)
    {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ys_cancelRequestWithURL:(NSString *)URL {
    if (!URL) {
        return;
    }
    @synchronized (self) {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL])
            {
                [task cancel];
                [[self tasks] removeObject:task];
                *stop = YES;
            }
        }];
    }
}


#pragma mark - 压缩图片尺寸
/*! 对图片尺寸进行压缩 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    if (newSize.height > 375/newSize.width*newSize.height) {
        newSize.height = 375/newSize.width*newSize.height;
    }
    
    if (newSize.width > 375) {
        newSize.width = 375;
    }
    
    UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    
    return newImage;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str {
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    } else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

#pragma mark - setter / getter
/**
 存储着所有的请求task数组
 
 @return 存储着所有的请求task数组
 */
+ (NSMutableArray *)tasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
    YSNetManagerShare.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setRequestSerializer:(YSHttpRequestSerializer)requestSerializer {
    _requestSerializer = requestSerializer;
    switch (requestSerializer) {
        case YSHttpRequestSerializerJSON:
        {
            YSNetManagerShare.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer] ;
        }
            break;
        case YSHttpRequestSerializerHTTP:
        {
            YSNetManagerShare.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
        }
            break;
            
        default:
            break;
    }
}

- (void)setResponseSerializer:(YSHttpResponseSerializer)responseSerializer {
    _responseSerializer = responseSerializer;
    switch (responseSerializer) {
        case YSHttpResponseSerializerJSON:
        {
            YSNetManagerShare.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer] ;
            // AFNetworking 将DELETE与GET同样处理
            YSNetManagerShare.sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        }
            break;
        case YSHttpResponseSerializerHTTP:
        {
            YSNetManagerShare.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
        }
            break;
            
        default:
            break;
    }
}

- (void)setHttpHeaderFieldDictionary:(NSDictionary *)httpHeaderFieldDictionary {
    
    if (![httpHeaderFieldDictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    NSArray *keyArray = httpHeaderFieldDictionary.allKeys;
    
    if (keyArray.count <= 0) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    _httpHeaderFieldDictionary = httpHeaderFieldDictionary;

    for (NSInteger i = 0; i < keyArray.count; i ++) {
        NSString *keyString = keyArray[i];
        NSString *valueString = httpHeaderFieldDictionary[keyString];
        
        [YSNetManager ys_setValue:valueString forHTTPHeaderKey:keyString];
    }
}

/**
 *  自定义请求头
 */
+ (void)ys_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey {
    [YSNetManagerShare.sessionManager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderKey];
}

/**
 删除所有请求头
 */
+ (void)ys_clearAuthorizationHeader {
    [YSNetManagerShare.sessionManager.requestSerializer clearAuthorizationHeader];
}

+ (void)ys_uploadImageWithFormData:(id<AFMultipartFormData>  _Nonnull )formData
                      resizedImage:(UIImage *)resizedImage
                         imageType:(NSString *)imageType
                        imageScale:(CGFloat)imageScale
                         fileNames:(NSArray <NSString *> *)fileNames
                             index:(NSUInteger)index {
    /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
    if (imageScale == 0)
    {
        imageScale = 0.8;
    }
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, imageScale ?: 1.f);
    
    /*! 拼接data */
    if (imageData != nil)
    {   // 图片数据不为空才传递 fileName
        //                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
        
        // 默认图片的文件名, 若fileNames为nil就使用
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.%@",str, index, imageType?:@"jpg"];
        
        [formData appendPartWithFileData:imageData
                                    name:[NSString stringWithFormat:@"picflie%ld", index]
                                fileName:fileNames ? [NSString stringWithFormat:@"%@.%@",fileNames[index],imageType?:@"jpg"] : imageFileName
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"]];
        NSLog(@"上传图片 %lu 成功", (unsigned long)index);
    }
}

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)ys_clearAllHttpCache {
    [YSNetManagerCache ys_clearAllHttpCache];
}

@end

