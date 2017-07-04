//
//  MShareTool.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "MShareTool.h"
#import "NSObject+ShareBindValue.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Photos/Photos.h>
#import "MShareManager.h"

static NSString *const kBindSender = @"KBindSender";            //绑定Model


@implementation MShareTool

SYNTHESIZE_SINGLETON_FOR_CLASS(MShareTool)


+ (AASDeviceModelType)deviceModel
{
    static AASDeviceModelType type = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        switch ((NSInteger)[[UIScreen mainScreen] bounds].size.height) {
            case 480:
                type = AASDeviceModelType_iPhone4Sery;
                break;
            case 568:
                type = AASDeviceModelType_iPhone5Sery;
                break;
            case 667:
                type = AASDeviceModelType_iPhone6;
                break;
            case 736:
                type = AASDeviceModelType_iPhone6Plus;
                break;
            default:
                type = AASDeviceModelType_Other;
                break;
        }
    });
    return type;
}


#pragma mark - 二维码生成功能
//生成二维码
+ (UIImage *)imageQrcodeViewWithStr:(NSString *)qrcodestr
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    //KVC
    NSData * data = [qrcodestr dataUsingEncoding:4];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputimage = [filter outputImage];
    UIImage * image = [[UIImage alloc]initWithCIImage:outputimage];
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    return resized;
}

//生成图片
+ (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}



- (UIAlertView *) showAlertTitle:(NSString *)title
                         Message:(NSString *)message
                          action:(AlertShowAction)action
                        cancelBt:(NSString *)cancel
               otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list  arg;
    va_start(arg,otherButtonTitles);//调用可变参数的方法
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil];
    if(action){//如果事件存在，则为协议委托
        alert.delegate=self;
        //        _alertAction=action;
        [alert bindCopyValue:action forKey:kBindSender];
    }
    for(NSString *str=otherButtonTitles;str!=nil;str=va_arg(arg, NSString *))
    {//依次增加对话框按钮
        [alert addButtonWithTitle:str];
    }
    va_end(arg);
    [alert show];
    
    return alert;
}

#pragma mark - ******* UIAlertViewDelegate *******
//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertShowAction action = [alertView getBindValueForKey:kBindSender];
    if (action) {
        action(buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AlertShowAction action = [alertView getBindValueForKey:kBindSender];
    if (action) {
        [alertView removeBindObjects];
    }
}


#pragma mark - 私有API
// 写到本地文件
+ (NSString *)writeImageToFile:(UIImage *)image
{
    NSString *directorypath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/ImageCache"];
    // 文件夹不存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:directorypath]) {
        // 创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:directorypath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *_dateFormater = [[NSDateFormatter alloc]init];
    [_dateFormater setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    //    NSString *name = [_dateFormater stringFromDate:[NSDate date]];
    NSString *name = [self md5:[_dateFormater stringFromDate:[NSDate date]]];
    NSData *imgdata = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/ImageCache/photo%@.jpg",name];
    [imgdata writeToFile:path atomically:YES];
    return path;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


/**
 图片保存到系统相册
 
 @param image 图片
 */
+ (void)savePhotoAlbumWithImage:(UIImage *)image
                     completion:(void (^)(BOOL success, NSError *error))completion
{
    __weak typeof(self) weakself = self;
    // 如果不存在
    if (![weakself _isExistAlbumPhoto]) {
        [weakself _createAlbumPhoto];
    }
    
    // 存储图片
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 寻找指定相册
        PHFetchOptions *otions = [[PHFetchOptions alloc]init];
        otions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle == %@",[weakself _albumPhotoName]];
        PHFetchResult *resault = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:otions];
        if (resault.count > 0) {
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:resault[0]];
            // 请求创建一个Asset
            PHAssetChangeRequest *asset = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            // 使用placeholder 占位图操作(因为为异步存储操作)
            PHObjectPlaceholder *placeholder = asset.placeholderForCreatedAsset;
            [request insertAssets:@[placeholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        }
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //        NSLog(@" 保存成功:%i ",success);
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success, error);
        });
    }];
}

#pragma mark - 相册相关
// 是否存在 应用 相册
+ (BOOL)_isExistAlbumPhoto
{
    PHFetchResult<PHCollection *> *list = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    __block BOOL resault = NO;
    [list enumerateObjectsUsingBlock:^(PHCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *colletion = (PHAssetCollection *)obj;
        if ([colletion.localizedTitle isEqual:[self _albumPhotoName]]) {
            resault = YES;
        }
    }];
    return resault;
}

// 创建相册
+ (void)_createAlbumPhoto
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:[self _albumPhotoName]];
    } error:nil];
    //    return createresault;
}

// 相册名称
+ (NSString *)_albumPhotoName
{
    // 默认应用名称
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return name;
}

// 权限获取
+ (BOOL)permissionFromType:(AMDPrivacyPermissionType)type
{
    __block BOOL resault = YES;
    switch (type) {
        case AMDPrivacyPermissionTypeRecord:     //录音权限
        {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession requestRecordPermission:^(BOOL granted) {
                    resault = granted;
                }];
            }
        }
            break;
        case AMDPrivacyPermissionTypeAssetsLibrary:      //相册
        {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            switch (status) {
                case PHAuthorizationStatusNotDetermined:{   //尚未选择
                    resault = NO;
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        // 获取权限
                        resault = status;
                    }];
                }
                    break;
                case PHAuthorizationStatusDenied:           //权限被拒绝
                {
                    [[[MShareManager shareInstance] alertDelegate] showAlertWithTitle:[self textFromLackPermisson:AMDPrivacyPermissionTypeAssetsLibrary]];
//                    [[AMDCommonClass sharedAMDCommonClass] showAlertTitle:nil Message:[self textFromLackPermisson:AMDPrivacyPermissionTypeAssetsLibrary] action:nil cancelBt:nil otherButtonTitles:@"确定", nil];
                    resault = NO;
                }
                    break;
                case PHAuthorizationStatusAuthorized:
                    resault = YES;
                    break;
                case PHAuthorizationStatusRestricted:
                {
                     [[[MShareManager shareInstance] alertDelegate] showAlertWithTitle:@"App当前没有权限使用相册"];
                    resault = NO;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case AMDPrivacyPermissionTypeCamera:             //相机
        {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusDenied) {
                resault = NO;
            }
        }
            break;
        default:
            break;
    }
    return resault;
}

+ (NSString *)textFromLackPermisson:(AMDPrivacyPermissionType)type
{
    NSString *remindMessage = @"";
    switch (type) {
        case AMDPrivacyPermissionTypeAssetsLibrary:
            remindMessage = @"相册";
            break;
        case AMDPrivacyPermissionTypeCamera:
            remindMessage = @"相机";
            break;
        case AMDPrivacyPermissionTypeRecord:
            remindMessage = @"录音";
            break;
        default:
            break;
    }
    NSString *text = [[NSString alloc]initWithFormat:@"app需要访问您的%@。\n请启用%@-设置/隐私/%@",remindMessage,remindMessage,remindMessage];
    return text;
}
@end
