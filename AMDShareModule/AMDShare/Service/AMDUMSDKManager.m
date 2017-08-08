//
//  AMDUMSDKManager.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//
#import "AMDUMSDKManager.h"
//#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialCore/UMSocialCore.h>
#import "AMDShareManager.h"
#import "MShareStaticMethod.h"


@implementation AMDUMSDKManager



//启动配置
+ (void)registerUMShareAppKey:(NSString *)shareAppKey
                 wechatAppKey:(NSString *)wechatAppKey
              wechatAppSecret:(NSString *)wechatAppSecret{
    //设置友盟appKey
    [[UMSocialManager defaultManager] setUmSocialAppkey:shareAppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wechatAppKey appSecret:wechatAppSecret  redirectURL:@""];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:wechatAppKey appSecret:wechatAppSecret  redirectURL:@""];
}


#pragma mark - 发起分享
+(BOOL)shareToUMWithType:(AMDShareType)shareType
            shareContent:(NSString *)shareContent
              shareTitle:(NSString *)shareTitle
           shareImageUrl:(NSURL *)shareImageUrl
                     url:(NSString *)shareUrl
               competion:(void (^)(AMDShareResponseState responseState,NSError *error))completion{
    //字符截取处理规则(复制不截取)
    if (shareType != AMDShareTypeCopy) {
        // 标题不能超过20个字 详细内容不能超过140个字
        shareTitle = shareTitle.length > 30?[shareTitle substringToIndex:30]:shareTitle;
        shareContent = shareContent.length > 40?[shareContent substringToIndex:40]:shareContent;
    }
    
//    // 分享内容拼接规则
//    if ( shareType == AMDShareTypeCopy) {
//        // 如果内容中含有http
//        if ([shareContent rangeOfString:@"http"].length == 0 && shareUrl.length > 0) {
//            shareContent = [shareContent stringByAppendingFormat:@" %@",shareUrl];
//        }
//    }
    
    //图片裁剪40
    NSString *imagestring = [NSString stringWithFormat:@"%@",shareImageUrl];
    if ([[shareImageUrl scheme] rangeOfString:@"http"].length>0&& [imagestring rangeOfString:@"?imageView2"].length == 0 ) {
        imagestring = [imagestring stringByAppendingString:@"?imageView2/1/w/80/h/80"];
        shareImageUrl = [NSURL URLWithString:imagestring];
    }
    
    UIImage *img =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
    
    if (shareType == AMDShareTypeWeChatSession||shareType == AMDShareTypeweChatTimeline) {

        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareContent thumImage:img];
        //设置网页地址
        shareObject.webpageUrl =shareUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:shareType==AMDShareTypeWeChatSession? UMSocialPlatformType_WechatSession:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                completion(AMDShareResponseFail,error);
            }else{
                completion(AMDShareResponseSuccess,error);
            }
        }];
        
    }else{
        [AMDShareManager shareType:shareType content:shareContent title:shareTitle imageUrl:shareImageUrl infoUrl:shareUrl competion:completion];
    }
    return NO;
}


//单图分享
+ (BOOL)shareUMType:(AMDShareType)shareType
             sender:(id)sender
          competion:(void(^)(AMDShareResponseState responseState,NSError *error))completion
{
    if(!sender)
        return NO;

    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    if ([sender isKindOfClass:[UIImage class]]) {
        UIImage *imageOj = sender;
        [shareObject setShareImage:imageOj];
    }else{
        NSURL *imageUrl = sender;
//       UIImage *img =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
        if ([imageUrl.scheme isEqualToString:@"http"]) {
            NSString *img = [NSString stringWithFormat:@"%@",sender];
            img = [img stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            imageUrl  = [NSURL URLWithString:img];
        }
        [shareObject setShareImage:imageUrl.relativeString];
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType==AMDShareTypeWeChatSession? UMSocialPlatformType_WechatSession:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            if (completion) {
                completion(AMDShareResponseFail,error);
            }
        }else{
            if (completion) {
                completion(AMDShareResponseSuccess,nil);
            }
        }
    }];
    return NO;
    
}


@end












