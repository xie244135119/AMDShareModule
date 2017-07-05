//
//  AMDUMSDKManager.h
//  AppMicroDistribution
//  友盟SDK
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMDShareConfig.h"

@interface AMDUMSDKManager : NSObject


#pragma mark - App配置相关
//启动配置
+ (void)registerUMShareAppKey:(NSString *)shareAppKey
               wechatAppKey:(NSString *)wechatAppKey
            wechatAppSecret:(NSString *)wechatAppSecret;

//配置友盟sdk
//+ (void)config;



/**
 *  第三方分享<仅支持微信分享>
 *
 *  @param shareType app中的分享类型
 *  @param shareContent   分享内容
 *  @param shareTitle     分享标题
 *  @param shareImageUrl  分享的图片地址
 *  @param shareUrl   分享的详情地址
 */
+ (BOOL)shareToUMWithType:(AMDShareType)shareType
          shareContent:(NSString *)shareContent
            shareTitle:(NSString *)shareTitle
         shareImageUrl:(NSString *)shareImageUrl
          url:(NSString *)shareUrl
competion:(void(^)(AMDShareResponseState responseState,NSError *error))completion;

/*
 *单图分享
 * 裁剪统一由调用方负责,当前仅负责分享操作
 * image字段支持url 和 UIimage
 */
+ (BOOL)shareUMType:(AMDShareType)shareType shareImage:(id)image;




@end

















