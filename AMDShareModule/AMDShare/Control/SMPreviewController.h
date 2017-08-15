//
//  SMPreviewController.h
//  AMDShareModule
//  图片预览类
//  Created by 马清霞 on 2017/8/14.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseKit/SSBaseKit.h>

@interface SMPreviewController : AMDRootViewController


/**
展示图片

 @param images 需要展示的图片<image>
 @param imageurls 需要展示的图片<url>
 @param showIndex 图片当前的位置
 @param completion 返回选中后的图片索引
 */
+ (instancetype)showImage:(NSArray<UIImage *> *)images
               imageUrl:(NSArray<NSURL*>*)imageurls
                showIndex:(NSUInteger)showIndex
       completion:(void(^)(NSArray<NSNumber *>* selectImages))completion;


/**
 返回选中的图片索引
 */
@property(nonatomic, weak) id<AMDControllerTransitionDelegate> delegate;







@end
