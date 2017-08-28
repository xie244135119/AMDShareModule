//
//  SSAppPluginShare.h
//  AMDShareModule
//  直接插件分享
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


// 一组对象<UIImage 或NSUrl>
@property(nonatomic, strong) NSArray *shareImages;
// 内容
@property(nonatomic, copy) NSString *shareContent;
// url
@property(nonatomic, strong) NSURL *shareUrl;
// 承载的控制器
@property(nonatomic, weak) UIViewController *senderController;

// 插件类型 SSPluginShareWechat等
@property(nonatomic, copy) NSString *pluginIder;



/**
 分享

 @param completion 完成事件<1完成 2取消 0失败>
 */
- (void)share:(void (^)(NSInteger resault, NSError *error))completion;




@end










