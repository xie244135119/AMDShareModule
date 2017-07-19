//
//  AMDShareConfig.h
//  AppMicroDistribution
//
//  Created by 马清霞 on 16/3/10.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#ifndef AMDShareConfig_h
#define AMDShareConfig_h

typedef NS_ENUM(NSUInteger, AMDShareType) {
    AMDShareTypeQQ = 1,                             //QQ分享
    AMDShareTypeQQZone,                     //QQ空间
    AMDShareTypeWeChatSession,                  //微信好友
    AMDShareTypeweChatTimeline,                 //微信朋友圈
    AMDShareTypeCopy,                           //复制链接
    AMDShareTypeSina,                           //新浪微博
    AMDShareTypeTuwenShare,                 //图文分享
    AMDShareTypeQrCode,                         //商品二维码分享
    AMDShareTypeTuwenSave,                      //图文保存
};

typedef NS_ENUM(NSUInteger, AMDShareResponseState) {
    AMDShareResponseSuccess = 1,
    AMDShareResponseFail,
    AMDShareResponseCancel,
};

#endif /* AMDShareConfig_h */
