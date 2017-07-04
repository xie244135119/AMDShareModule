//
//  AMDShareMaterialView.h
//  AppMicroDistribution
//  素材分享视图
//  Created by SunSet on 2017/6/22.
//  Copyright © 2017年 SunSet. All rights reserved.
//

//#import "AMDBaseView.h"
#import <SSBaseKit/SSBaseKit.h>

@interface AMDShareMaterialView : AMDBaseView


// 一组图片地址
@property(nonatomic, strong) NSArray *shareImageUrls;
// 分享内容
@property(nonatomic, copy) NSString *shareContent;
// 分享链接
@property(nonatomic, copy) NSString *shareUrl;



// 显示和隐藏
- (void)show;

- (void)hide;


@end
