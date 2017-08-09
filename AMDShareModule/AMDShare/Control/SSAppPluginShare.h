//
//  SSAppPluginShare.h
//  AMDShareModule
//
//  Created by SunSet on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 微信分享类型
extern NSString * const SSPluginShareWechat;
// qq分享
extern NSString * const SSPluginShareQQ;
// 微博分享
extern NSString * const SSPluginShareSina;



@interface SSAppPluginShare : NSObject

/**
 插件分享

 @param shareType 分享类型 SSPluginShareWechat等
 @param aText 文本内容
 @param aImages 图片
 @param aUrl url
 @param controller 控制器
 @param completion 完成事件<1完成 2取消>
 */
+ (void)pluginShareWithType:(NSString *)shareType
                       text:(NSString *)aText
                     images:(NSArray *)aImages
                        url:(NSURL *)aUrl
             rootController:(UIViewController *)controller
                 completion:(void (^)(NSInteger resault))completion;



@end










