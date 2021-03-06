//
//  AMDShareMaterialViewModel.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/4.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>
#import "MShareServiceProtocal.h"
#import "AMDShareConfig.h"

@interface AMDShareMaterialViewModel : AMDBaseViewModel

// 一组图片地址
@property(nonatomic, strong) NSArray<NSURL *> *shareImageUrls;
// 分享内容
@property(nonatomic, copy) NSString *shareContent;
// 分享链接
@property(nonatomic, copy) NSString *shareUrl;

@property (nonatomic ,copy)UIImage *backImage;

@property(nonatomic, weak) id<MShareServiceProtocal>serviceProtocal;

@property(nonatomic, copy) void  (^completionHandle)(AMDShareType shareType,AMDShareResponseState responseState,NSError* error);


- (void)show;

@end
