//
//  AMDShareMaterialViewModel.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/4.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>
#import "MShareServiceProtocal.h"

@interface AMDShareMaterialViewModel : AMDBaseViewModel

// 一组图片地址
@property(nonatomic, strong) NSArray *shareImageUrls;
// 分享内容
@property(nonatomic, copy) NSString *shareContent;
// 分享链接
@property(nonatomic, copy) NSString *shareUrl;

@property (nonatomic ,copy)UIImage *backImage;

@property(nonatomic, weak) id<MShareServiceProtocal>serviceProtocal;


- (void)show;

@end
