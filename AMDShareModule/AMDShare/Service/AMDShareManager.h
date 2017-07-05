//
//  AMDShareManager.h
//  AppMicroDistribution
//  ShareSDK 类--便于后续变更单独类处理
//  Created by SunSet on 15-5-31.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDShareConfig.h"

typedef void(^AMDWechatLoginHandle) (BOOL result, NSDictionary *userInfo, id error);


@interface AMDShareManager : NSObject


/**
 *  第三方分享(卡片分享)
 *
 *  @param shareType app中的分享类型
 *  @param content   分享内容
 *  @param title     分享标题
 *  @param imageurl  分享的图片地址
 *  @param infourl   分享的详情地址
 */
+ (void)shareType:(AMDShareType)shareType
          content:(NSString *)content
            title:(NSString *)title
         imageUrl:(NSString *)imageurl
          infoUrl:(NSString *)infourl
        competion:(void(^)(AMDShareResponseState responseState,NSError *error))completion;

/**
 *  单图分享
 *
 *  @param shareType 分享类型
 *  @param imageurl  图片地址--和上面分享的图片地址格式相同
 */
+ (void)shareType:(AMDShareType)shareType photoURL:(NSString *)imageurl competion:(void(^)(AMDShareResponseState responseState,NSError *error))completion;

/**
 *  微信授权登录
 */
+ (void)getUserInfoFormWeiChat:(AMDWechatLoginHandle)handle;

/**
 *  微信取消授权登录
 */
+ (void)cancelWechatAuthWithType;

/**
 *  打开微信
 */
+ (void)openWechat;



#pragma mark - App配置相关
//启动配置
+ (void)registerShareAppKey:(NSString *)shareAppKey
                 sinaAppKey:(NSString *)sinaAppKey
              sinaAppSecret:(NSString *)sinaAppSecret
               wechatAppKey:(NSString *)wechatAppKey
            wechatAppSecret:(NSString *)wechatAppSecret
                   qqAppKey:(NSString *)qqAppKey
                qqAppSecret:(NSString *)qqAppSecret;

//AppDelegate中回调
//+ (BOOL)handleOpenURL:(NSURL *)url;
//+ (BOOL)sourceApplication:(NSString *)sourceApplication
//                  openURL:(NSURL *)url
//               annotation:(id)annotation;

@end
















