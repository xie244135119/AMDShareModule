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

//配置友盟sdk
+ (void)config;

//统计页面时长
+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

/**
 *  第三方分享
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
competion:(void(^)(NSString *alertTitle))completion;

/*
 *单图分享
 * 裁剪统一由调用方负责,当前仅负责分享操作
 * image字段支持url 和 UIimage
 */
+ (BOOL)shareUMType:(AMDShareType)shareType shareImage:(id)image;




@end

















