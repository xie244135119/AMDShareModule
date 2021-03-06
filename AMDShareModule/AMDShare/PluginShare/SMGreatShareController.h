//
//  GreatShareController.h
//  GreatShareViewTest
//  创建分享界面
//  Created by 马清霞 on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseKit/SSBaseKit.h>
#import "AMDShareConfig.h"

@interface SMGreatShareController : AMDRootViewController

// 优先 展示 UIImage 其次为 NSURL
// 分享的图片URL数组
@property(nonatomic, strong) NSArray<NSURL*>*shareImageUrlArray;
// 分享的图片数组
@property(nonatomic, strong) NSArray<UIImage*>*shareImageArray;
// 分享内容
@property(nonatomic, strong)NSString *shareContent;
// 分享链接
@property(nonatomic, strong)NSURL *shareUrl;

/**
 分享结果
 */
@property(nonatomic, copy) void  (^completionHandle)(AMDShareType shareType,AMDShareResponseState responseState,NSError* error);

@end
