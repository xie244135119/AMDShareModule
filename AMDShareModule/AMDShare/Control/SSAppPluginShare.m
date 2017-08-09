//
//  SSAppPluginShare.m
//  AMDShareModule
//
//  Created by SunSet on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SSAppPluginShare.h"
#import <Social/Social.h>

// 微信分享类型
NSString * const SSPluginShareWechat = @"com.tencent.xin.sharetimeline";
// qq分享
NSString * const SSPluginShareQQ = @"";
// 微博分享
NSString * const SSPluginShareSina = @"";


@implementation SSAppPluginShare

#pragma mark  直接调用微信相关点击
// 直接调用微信分享
+ (void)pluginShareWithType:(NSString *)shareType
                       text:(NSString *)aText
                     images:(NSArray *)aImages
                        url:(NSURL *)aUrl
             rootController:(UIViewController *)controller
                 completion:(void (^)(NSInteger resault))completion
{
    NSString *wechat = shareType;
    if (![SLComposeViewController isAvailableForServiceType:wechat]) {
        NSLog(@" 不支持当前应用 ");
        return;
    }
    SLComposeViewController *compostVc = [SLComposeViewController composeViewControllerForServiceType:wechat];
    if (compostVc == nil)  return;
    [compostVc setInitialText:aText];
    for (UIImage *image in aImages) {
        [compostVc addImage:image];
    }
    if (aUrl) {
        [compostVc addURL:aUrl];
    }
    compostVc.completionHandler = ^(SLComposeViewControllerResult result) {
        // 1 完成 2取消
        completion(result==SLComposeViewControllerResultDone?1:2);
    };
    [controller presentViewController:compostVc animated:YES completion:nil];
}









@end
