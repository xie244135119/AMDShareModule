//
//  AMDShareController.h
//  AMDShareModule
//  普通分享视图
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseKit/SSBaseKit.h>
#import "AMDShareConfig.h"



@interface AMDShareController : AMDRootViewController

//分享标题
@property(nonatomic, copy) NSString *shareTitle;
//分享内容
@property(nonatomic, copy) NSString *shareContent;
//商品短链
@property(nonatomic, copy) NSString *shareShortUrl;
//分享链接
@property(nonatomic, copy) NSString *shareUrl;
//分享图片数组
@property(nonatomic, strong) NSArray<NSURL *>* shareImageUrls;

/**
 可以为nil 默认一般分享类型
@[@"微信 = 1",@"朋友圈 = 2",@"图文 = 3",@"二维码 = 4",@"QQ = 5",@"Qzone = 6",@"微博 = 7",@"复制 = 8"]
 */
@property(nonatomic, strong) NSArray<NSNumber *> *customIntentIdentifiers;;

//默认0:有量  1:买否
@property(nonatomic) NSInteger shareSource;

/**
 *  点击相应的分享事件(用于转发关系)
 */
@property(nonatomic, copy) void  (^handleShareAction)(AMDShareType shareType,NSString *alertTitle);


// com.share.default <主分享>  com.share.material<素材>
+ (BOOL)isAvailableForServiceType:(NSString *)serviceType;
+ (instancetype)shareViewControllerForServiceType:(NSString *)serviceType;


@end







