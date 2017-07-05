//
//  MShareTool.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MShareStaticMethod.h"




NS_ASSUME_NONNULL_BEGIN


typedef void (^AlertShowAction)(NSInteger index);
typedef void(^AMDPhotoAction)(NSArray *_Nullable cachePicImages, NSError *_Nullable error);

@interface MShareTool : NSObject

// 设备机型
typedef NS_ENUM(NSUInteger, AASDeviceModelType) {
    AASDeviceModelType_iPhone4Sery ,            //iphone4系列
    AASDeviceModelType_iPhone5Sery,             //iphone5系列
    AASDeviceModelType_iPhone6,                     //iphone6
    AASDeviceModelType_iPhone6Plus,             //iphone6plus
    AASDeviceModelType_Other,
};

// 系统权限
typedef NS_ENUM(NSUInteger, AMDPrivacyPermissionType) {
    AMDPrivacyPermissionTypeAssetsLibrary,           //相册
    AMDPrivacyPermissionTypeCamera,                  //相机
    AMDPrivacyPermissionTypeRecord,                  //录音
    //    AMDDevicePermissionTypePhoto,
};

SYNTHESIZE_SINGLETON_FOR_HEADER(MShareTool)

/**
 *  设备型号
 */
+ (AASDeviceModelType)deviceModel;

/**
 *  二维码生成功能
 *  @param qrcodestr 文本串
 *  @return 图片
 */
+ (UIImage *)imageQrcodeViewWithStr:(NSString *)qrcodestr;


/*
 * 系统提示框---AlertView
 * @param1 标题 @param2 消息内容 @param3 动作行为 @param4 取消按钮 @param5 其他按钮
 */
- (nonnull UIAlertView *) showAlertTitle:(NSString * _Nullable)title
                                 Message:(NSString * _Nullable)message
                                  action:(nullable AlertShowAction)action
                                cancelBt:(NSString * _Nullable)cancel
                       otherButtonTitles:(NSString * _Nullable)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  将图像写入本地文件
 */
+ (NSString *)writeImageToFile:(UIImage *)image;
///**
// 图片保存到系统相册
// 
// @param image 图片
// */
//+ (void)savePhotoAlbumWithImage:(UIImage *)image
//                     completion:(void (^)(BOOL success, NSError *error))completion;


/**
 不同类型权限
 包含提示语 需要统一提示
 @param type AMDPrivacyPermissionType
 @return 是否有权限
 */
//+ (BOOL)permissionFromType:(AMDPrivacyPermissionType)type;


/**
 *  保存网络图片
 * @param photourls 图片地址
 * @param callBackAction 成功回调事件
 * @param failAction 失败回调事件
 */
- (void)perpareForSendNinePhotos:(nullable NSArray *)photourls successAction:(nullable AMDPhotoAction)callBackAction failAction:(nullable AMDPhotoAction)failAction;

@end





NS_ASSUME_NONNULL_END









