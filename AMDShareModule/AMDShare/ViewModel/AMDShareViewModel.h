//
//  AMDShareViewModel.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>
#import <SSBaseKit/SSBaseKit.h>
#import "AMDShareConfig.h"

@interface AMDShareViewModel : AMDBaseViewModel

@property(nonatomic, strong) NSArray<NSNumber *> *customIntentIdentifiers;;

@property(nonatomic) NSInteger shareSource;

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


@property(nonatomic, copy) void  (^handleShareAction)(AMDShareType shareType,NSString *alertTitle);


@property (nonatomic ,copy)UIImage *backImage;

- (void)show;
@end
