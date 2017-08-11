//
//  ImagePreviewController.h
//  TradeApp
//  图片预览器
//  Created by SunSet on 14-6-3.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMImagePreviewController : UIViewController<UIViewControllerTransitioningDelegate>

// 所有图片原始的尺寸
@property(nonatomic, strong) NSArray<NSString *> *originalFrames;
// 所有的缩略图
@property(nonatomic, strong) NSArray *thumbnailImages;
// 所有图片的url地址--一组字符串地址
@property(nonatomic, strong) NSArray *remoteImagePaths;
// 点击的图片索引--起始为0
@property(nonatomic, assign) NSInteger currentIndex;

//@property(nonatomic,weak) UIScrollView *operableScrollView;

@end
