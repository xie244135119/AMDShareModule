//
//  MShareServiceProtocal.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/5.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

// 系统权限
typedef NS_ENUM(NSUInteger, AMDPrivacyPermissionType) {
    AMDPrivacyPermissionTypeAssetsLibrary,           //相册
    AMDPrivacyPermissionTypeCamera,                  //相机
    AMDPrivacyPermissionTypeRecord,                  //录音
    //    AMDDevicePermissionTypePhoto,
};

@protocol MShareServiceProtocal <NSObject>

@optional

/**
 图片保存到系统相册

 @param image 图片
 */
- (void)savePhotoAlbumWithImage:(UIImage *)image
                     completion:(void (^)(BOOL success, NSError *error))completion;


/**
 不同类型权限
 包含提示语 需要统一提示
 @param type AMDPrivacyPermissionType
 @return 是否有权限
 */
- (BOOL)permissionFromType:(AMDPrivacyPermissionType)type;


/**
 *  保存网络图片
 * @param photourls 图片地址
 * @param callBackAction 成功回调事件
 * @param failAction 失败回调事件
 */
- (void)perpareForSendNinePhotos:(nullable NSArray *)photourls
                   successAction:(void(^)(NSArray *_Nullable cachePicImages, NSError *_Nullable error))callBackAction
                      failAction:(void(^)(NSArray *_Nullable cachePicImages, NSError *_Nullable error))failAction;

@end



NS_ASSUME_NONNULL_END



