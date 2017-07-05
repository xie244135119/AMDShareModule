//
//  AMDShareManager.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-31.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDShareManager.h"
#import <ShareSDK3/WXApi.h>
#import <ShareSDK3/WeiboSDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "MShareStaticMethod.h"


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
        handle(state==SSDKResponseStateSuccess,user.rawData,error);
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


#pragma mark - PrivateAPI
//sharesdk分享错误
+ (NSString *)shareErrorWithCode:(NSInteger)code
{
    NSDictionary *errorlist = [[NSDictionary alloc]initWithContentsOfFile:GetFilePath(@"ShareErrorCodeList.plist")];
    NSString *errorcode = [[NSString alloc]initWithFormat:@"%li",(long)code];
    NSDictionary *param = errorlist[errorcode];
    if (param == nil) {
        return @"分享失败";
    }
    return param[@"description"];
}



#pragma mark
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
         imageUrl:(NSString *)imageurl
          infoUrl:(NSString *)infourl
        competion:(void(^)(AMDShareResponseState responseState,NSUInteger erroCodel))completion
{
    //字符截取处理规则(复制不截取)
    if (shareType != AMDShareTypeCopy) {
        // 标题不能超过20个字 详细内容不能超过140个字
        title = title.length > 30?[title substringToIndex:30]:title;
        content = content.length > 40?[content substringToIndex:40]:content;
    }

    // 卡片分享的时候处理图片裁剪--保证小比例图片分享
    if (infourl.length > 0) {
        if ([imageurl rangeOfString:@"?imageView2"].length == 0 &&  ![imageurl hasPrefix:@"local:"]) {
            imageurl = [imageurl stringByAppendingString:@"?imageView2/1/w/80/h/80"];
        }
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
            //调用系统剪切板
                if (content.length == 0) return;
            
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = content;
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
                                         images:[self shareImagePathWithUrl:imageurl]
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeImage];
    }else{
        //1、创建分享参数（必要）
        [shareParams SSDKSetupShareParamsByText:content
                                         images:[self shareImagePathWithUrl:imageurl]
                                            url:infourl.length==0?nil:[NSURL URLWithString:infourl]
                                          title:title
                                           type:SSDKContentTypeAuto];
    }

    [ShareSDK share:platformtype parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:{//成功
                completion(AMDShareResponseSuccess,error.code);
            }
                break;
            case SSDKResponseStateFail:{//失败
                completion(AMDShareResponseFail,error.code);
            }
                break;
            case SSDKResponseStateCancel:{//取消
                completion(AMDShareResponseCancel,error.code);
            }
                break;
            default:
                break;
        }
    }];
        [shareParams SSDKEnableUseClientShare];
}

// 分享图片
+ (void)shareType:(AMDShareType)shareType photoURL:(NSString *)imageurl competion:(void (^)(AMDShareResponseState responseState,NSUInteger erroCodel))completion
{
    // 自动调用图片类型
    [self shareType:shareType content:nil title:nil imageUrl:imageurl infoUrl:nil competion:completion];
}




//返回分享的图片实例
+ (id)shareImagePathWithUrl:(NSString *)imageurl
{
    if (imageurl.length == 0) {
        return nil;
    }
    //有前缀 local--本地图片
    if ([imageurl hasPrefix:@"local:"]) {
        NSString *url = [imageurl substringFromIndex:6];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:url];
        return image;
    }

    return imageurl;
}



@end












