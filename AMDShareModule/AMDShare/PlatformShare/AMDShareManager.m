//
//  AMDShareManager.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-31.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDShareManager.h"
#import <WXApi.h>
#import <ShareSDK3/WeiboSDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "SMConstVar.h"


@interface AMDShareManager()

@end

@implementation AMDShareManager


// 授权登录--统一处理
+ (void)getUserInfoFormWeiChat:(AMDWechatLoginHandle)handle
{
//    NSLog(@"当前版本 ：%@",[ShareSDK sdkVer]);
    // 授权登录
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        // 取消授权
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        //
        handle(state==SSDKResponseStateSuccess?AMDShareResponseSuccess:state==SSDKResponseStateFail?AMDShareResponseFail:AMDShareResponseCancel,user.rawData,error);
    }];
}


// 取消授权
+ (void)cancelWechatAuthWithType
{
    //如果微信已授权
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    }
}

// 九图分享
+ (void)openWechat
{
    [WXApi openWXApp];
}


#pragma mark - 全新的shareSDK体系
+ (void)registerShareAppKey:(NSString *)shareAppKey
                 sinaAppKey:(NSString *)sinaAppKey
              sinaAppSecret:(NSString *)sinaAppSecret
               wechatAppKey:(NSString *)wechatAppKey
            wechatAppSecret:(NSString *)wechatAppSecret
                    qqAppKey:(NSString *)qqAppKey
                qqAppSecret:(NSString *)qqAppSecret
{
    // 配置连接 @"db1e4895e49d"[[MultiProjectManager globalConfigFile] shareSDKAppKey]
    [ShareSDK registerApp:shareAppKey activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:NSClassFromString(@"QQApiInterface") tencentOAuthClass:NSClassFromString(@"TencentOAuth")];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:sinaAppKey
                                          appSecret:sinaAppSecret
                                        redirectUri:nil
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:wechatAppKey
                                      appSecret:wechatAppSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:qqAppKey
                                     appKey:qqAppSecret
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}


// shareSDK V3.X版本
+ (void)shareType:(AMDShareType)shareType
          content:(NSString *)content
            title:(NSString *)title
         imageUrl:(NSURL *)imageurl
          infoUrl:(NSString *)infourl
        competion:(void(^)(AMDShareResponseState responseState,NSError *error))completion
{
    //这边不是单图分享不给予截图操作
    if (title.length != 0 || content.length != 0||infourl.length != 0) {
        // 卡片分享的时候处理图片裁剪--保证小比例图片分享
        NSString *imagestring = [NSString stringWithFormat:@"%@",imageurl];
        if ([[imageurl scheme] rangeOfString:@"http"].length>0&& [imagestring rangeOfString:@"?imageView2"].length == 0 ) {
            imagestring = [imagestring stringByAppendingString:@"?imageView2/1/w/80/h/80"];
            imageurl = [NSURL URLWithString:imagestring];
        }
    }
    [self _shareType:shareType content:content title:title imageUrl:imageurl infoUrl:infourl competion:completion];
  }



// 分享图片
+ (void)shareType:(AMDShareType)shareType photoURL:(NSURL *)imageurl competion:(void (^)(AMDShareResponseState responseState,NSError *error))completion
{
    // 自动调用图片类型
    [self shareType:shareType content:nil title:nil imageUrl:imageurl infoUrl:nil competion:completion];
}



#pragma mark - private
+ (void)_shareType:(AMDShareType)shareType
           content:(NSString *)content
             title:(NSString *)title
          imageUrl:(NSURL *)imageurl
           infoUrl:(NSString *)infourl
         competion:(void(^)(AMDShareResponseState responseState,NSError *error))completion{
    //字符截取处理规则(复制不截取)
    if (shareType != AMDShareTypeCopy) {
        // 标题不能超过20个字 详细内容不能超过140个字
        title = title.length > 30?[title substringToIndex:30]:title;
        content = content.length > 40?[content substringToIndex:40]:content;
    }
    
    
    // 分享内容拼接规则
    if (shareType == AMDShareTypeSina || shareType == AMDShareTypeCopy) {
        // 如果内容中含有http
        if ([content rangeOfString:@"http"].length == 0 && infourl.length > 0) {
            content = [content stringByAppendingFormat:@" %@",infourl];
        }
    }
    
    SSDKPlatformType platformtype = 0;
    switch (shareType) {
        case AMDShareTypeQQ:        //qq
            platformtype = SSDKPlatformSubTypeQQFriend;
            break;
        case AMDShareTypeQQZone:    //qq空间
            platformtype = SSDKPlatformSubTypeQZone;
            break;
        case AMDShareTypeSina:      //新浪微博
            platformtype = SSDKPlatformTypeSinaWeibo;
            break;
        case AMDShareTypeWeChatSession:         //微信好友
            platformtype = SSDKPlatformSubTypeWechatSession;
            break;
        case AMDShareTypeweChatTimeline:        //微信朋友圈
            platformtype = SSDKPlatformSubTypeWechatTimeline;
            break;
        case AMDShareTypeCopy:              //复制
        {
            //            //调用系统剪切板
            //                if (content.length == 0) return;
            //
            //                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            //                pasteboard.string = content;
            completion(AMDShareResponseSuccess,nil);
            return;
        }
            break;
        default:
            break;
    }
    
    
    //参数处理 如果内容、标题、infourl为空 即为图片分享
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (content.length<=0&& title.length<=0&& infourl.length<=0) {
        //1、创建分享参数（必要）
        [shareParams SSDKSetupShareParamsByText:platformtype ==SSDKPlatformTypeSinaWeibo?@"分享给您一张图片～": nil
                                         images:imageurl
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeImage];
    }else{
        //1、创建分享参数（必要）
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageurl
                                            url:infourl.length==0?nil:[NSURL URLWithString:infourl]
                                          title:title
                                           type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:platformtype parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:{//成功
                completion(AMDShareResponseSuccess,error);
            }
                break;
            case SSDKResponseStateFail:{//失败
                completion(AMDShareResponseFail,error);
            }
                break;
            case SSDKResponseStateCancel:{//取消
                completion(AMDShareResponseCancel,error);
            }
                break;
            default:
                break;
        }
    }];
    [shareParams SSDKEnableUseClientShare];
    
}

@end












