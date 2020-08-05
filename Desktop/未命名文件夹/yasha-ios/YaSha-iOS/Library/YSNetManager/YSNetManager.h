//
//  YSNetManager.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YSNewsAttachmentModel.h"

#define YSNetManagerShare [YSNetManager sharedYSNetManager]

/*! 过期属性或方法名提醒 */
#define YSNetManagerDeprecated(instead) __deprecated_msg(instead)

/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, YSNetworkStatus) {
    /*! 未知网络 */
    YSNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    YSNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络 */
    YSNetworkStatusReachableViaWWAN,
    /*! wifi 网络 */
    YSNetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, YSHttpRequestType) {
    /*! get请求 */
    YSHttpRequestTypeGet = 0,
    /*! post请求 */
    YSHttpRequestTypePost,
    /*! put请求 */
    YSHttpRequestTypePut,
    /*! delete请求 */
    YSHttpRequestTypeDelete
};

typedef NS_ENUM(NSUInteger, YSHttpRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    YSHttpRequestSerializerJSON,
    /** 设置请求数据为HTTP格式*/
    YSHttpRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, YSHttpResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    YSHttpResponseSerializerJSON,
    /** 设置响应数据为HTTP格式*/
    YSHttpResponseSerializerHTTP,
};

/*! 实时监测网络状态的 block */
typedef void(^YSNetworkStatusBlock)(YSNetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ YSResponseSuccess)(id response);
/*! 定义请求失败的 block */
typedef void( ^ YSResponseFail)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ YSUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ YSDownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);

/*!
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask YSURLSessionTask;

@class YSDataEntity;

@interface YSNetManager : NSObject

/**
 创建的请求的超时间隔（以秒为单位），此设置为全局统一设置一次即可，默认超时时间间隔为30秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 设置网络请求参数的格式，此设置为全局统一设置一次即可，默认：YSHttpRequestSerializerJSON
 */
@property (nonatomic, assign) YSHttpRequestSerializer requestSerializer;

/**
 设置服务器响应数据格式，此设置为全局统一设置一次即可，默认：YSHttpResponseSerializerJSON
 */
@property (nonatomic, assign) YSHttpResponseSerializer responseSerializer;

/**
 自定义请求头：httpHeaderField
 */
@property(nonatomic, strong) NSDictionary *httpHeaderFieldDictionary;

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类YSNetManager单例
 */
+ (instancetype)sharedYSNetManager;

#pragma mark - 网络请求的类方法 --- get / post / put / delete
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
                                         progress:(YSDownloadProgress)progress;

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
                                          progress:(YSDownloadProgress)progress;

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
                                         progress:(YSDownloadProgress)progress;

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
                                            progress:(YSDownloadProgress)progress;

/**
 上传图片(多图)
 
 @param urlString 上传的url
 @param parameters 上传图片预留参数---视具体情况而定 可移除
 @param imageArray 上传的图片数组
 @param file 上传的图片数组file,服务器接收地址
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
                                   upLoadProgress:(YSUploadProgress)progress;


/**
 上传文件

 @param urlString 上传的url
 @param parameters 上传文件预留参数---视具体情况而定 可移除
 @param fileArray 上传的文件数组
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
                                   upLoadProgress:(YSUploadProgress)progress;

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
                     uploadProgress:(YSUploadProgress)progress;

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
                                  downLoadProgress:(YSDownloadProgress)progress;

#pragma mark - 网络状态监测
/*!
 *  开启实时网络状态监测，通过Block回调实时获取(此方法可多次调用)
 */
+ (void)ys_startNetWorkMonitoringWithBlock:(YSNetworkStatusBlock)networkStatus;

#pragma mark - 自定义请求头
/**
 *  自定义请求头
 */
+ (void)ys_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;

/**
 删除所有请求头
 */
+ (void)ys_clearAuthorizationHeader;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ys_cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ys_cancelRequestWithURL:(NSString *)URL;

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)ys_clearAllHttpCache;

@end
