//
//  AMDUMSDKManager.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//
#import "AMDUMSDKManager.h"
#import <UMSocialCore/UMSocialCore.h>
//#import "MultiProjectManager.h"
#import "AMDShareManager.h"
#import "MShareManager.h"
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
+(BOOL)shareToUMWithType:(AMDShareType)shareType shareContent:(NSString *)shareContent shareTitle:(NSString *)shareTitle shareImageUrl:(NSString *)shareImageUrl url:(NSString *)shareUrl competion:(void (^)(NSString *))completion{
    //字符截取处理规则(复制不截取)
    if (shareType != AMDShareTypeCopy) {
        // 标题不能超过20个字 详细内容不能超过140个字
        shareTitle = shareTitle.length > 30?[shareTitle substringToIndex:30]:shareTitle;
        shareContent = shareContent.length > 40?[shareContent substringToIndex:40]:shareContent;
    }
    
    // 分享内容拼接规则
    if ( shareType == AMDShareTypeCopy) {
        // 如果内容中含有http
        if ([shareContent rangeOfString:@"http"].length == 0 && shareUrl.length > 0) {
            shareContent = [shareContent stringByAppendingFormat:@" %@",shareUrl];
        }
    }
    
    //图片裁剪40
    //    if (shareUrl.length > 0) {
    if ([shareImageUrl rangeOfString:@"?imageView2"].length == 0 &&  ![shareImageUrl hasPrefix:@"local:"]) {
        shareImageUrl = [shareImageUrl stringByAppendingString:@"?imageView2/1/w/80/h/80"];
    }
    
    UIImage *img =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]]];
    
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
        [[UMSocialManager defaultManager] shareToPlatform:shareType==AMDShareTypeWeChatSession? UMSocialPlatformType_WechatSession:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                completion([self shareErrorWithCode:error.code]);
//                [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:[self shareErrorWithCode:error.code]];
            }else{
                completion(@"分享成功");
//                [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:@"分享成功"];
            }
        }];
        
    }else{
        [AMDShareManager shareType:shareType content:shareContent title:shareTitle imageUrl:shareImageUrl infoUrl:shareUrl competion:completion];
    }
    return NO;
}


+ (UIImage*)shareImageWithURL:(NSString *)imageurl{
    UIImage *img = nil ;
    if ([imageurl hasPrefix:@"local:"]) {
        NSString *url = [imageurl stringByReplacingOccurrencesOfString:@"local:" withString:@""];
        img =[[UIImage alloc]initWithContentsOfFile:url];
    }else{
        img =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]];
    }
    return img;
}


//单图分享
+ (BOOL)shareUMType:(AMDShareType)shareType shareImage:(id)image
{
    if(!image)
        return NO;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    if ([image isKindOfClass:[UIImage class]]) {
        UIImage *imageOj = image;
        [shareObject setShareImage:imageOj];
    }else{
        UIImage *imgeOj = [self shareImageWithURL:image];
        [shareObject setShareImage:imgeOj];
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType==AMDShareTypeWeChatSession? UMSocialPlatformType_WechatSession:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
//            [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:[self shareErrorWithCode:error.code]];
        }else{
//            [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:@"分享成功"];
        }
    }];
    return NO;
    
}


#pragma mark - 报错code转换
//sharesdk分享错误
+ (NSString *)shareErrorWithCode:(NSInteger)code
{
    NSDictionary *errorlist = [[NSDictionary alloc]initWithContentsOfFile:GetFilePath(@"UShareErrorCodeList.plist")];
    NSString *errorcode = [[NSString alloc]initWithFormat:@"%li",(long)code];
    NSDictionary *param = errorlist[errorcode];
    if (param == nil) {
        return @"分享失败";
    }
    return param[@"description"];
}

@end












