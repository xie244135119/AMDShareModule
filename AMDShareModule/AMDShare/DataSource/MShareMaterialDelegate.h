//
//  MShareMaterialDelegate.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/4.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MShareMaterialDelegate <NSObject>


/**
 获取分享的内容

 @param completion 返回的图片地址、内容、链接
 */
-(void)getShareSourceCompletion:(void(^)(NSArray *imageUrls,NSString*content,NSString *url))completion;



/**
 下载图片

 @param url 图片地址
 @param completion 返回下载后的图片
 */
-(void)loadImageWithUrl:(NSURL *)url Completion:(void(^)(UIImage *image,BOOL result))completion;



/**
 九图分享

 @param imageUrls 图片地址
 @param completion 返回结果
 */
-(void)perpareForSendNinePhotos:(NSArray *)imageUrls Completion:(void(^)(NSArray *images,BOOL result))completion;







@end
