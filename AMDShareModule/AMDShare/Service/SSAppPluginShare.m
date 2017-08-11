//
//  SSAppPluginShare.m
//  AMDShareModule
//
//  Created by SunSet on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SSAppPluginShare.h"
#import <Social/Social.h>
#import <SDWebImage/SDWebImageManager.h>
#import <Masonry/Masonry.h>

// 微信分享类型
NSString * const SSPluginShareWechat = @"com.tencent.xin.sharetimeline";
// qq分享
NSString * const SSPluginShareQQ = @"com.tencent.mqq.ShareExtension";
// 微博分享
NSString * const SSPluginShareSina = @"sina";


@interface SSAppPluginShare()
{
    __block BOOL _isImagesCached;           //图片缓存
    __weak UIView *_backgroundView;         //后背景视图
    
    __block NSMutableArray *_allCacheImages;        //所有的缓存图片
    __weak UILabel *_wechatShareLabel;               //分享文案视图
}
@end


@implementation SSAppPluginShare

- (void)dealloc
{
    self.shareImageUrls = nil;
    self.shareUrl = nil;
    self.shareContent = nil;
    self.pluginIder = nil;
    _allCacheImages = nil;
}



#pragma mark - public api
//
- (void)share:(void (^)(NSInteger resault, NSError *error))completion
{
    [self pasteText:_shareContent];
    // 加载文案视图
    [self initAnimateViewOnView:_senderController.view];
    
    // 显示动画
    [self _showWechatPasteView];
    
    __weak typeof(self) weakself = self;
    [self _cachePostPhotosCompletion:^(NSArray *cachesImages, NSError *error) {
        // ui处理
        [weakself _hideWechatPasteView];
        if (error) {
            //
            completion(0, error);
        }
        else {
            // 调用微信分享
            [SSAppPluginShare pluginShareWithType:_pluginIder text:_shareContent images:_allCacheImages url:_shareUrl rootController:_senderController completion:^(NSInteger resault) {
                completion(resault, nil);
            }];
        }
    }];
}


- (NSArray *)allCacheImages
{
    return _allCacheImages;
}





#pragma mark - private api
#pragma mark  直接调用微信相关点击
// 直接调用微信分享
+ (void)pluginShareWithType:(NSString *)shareType
                       text:(NSString *)aText
                     images:(NSArray<UIImage *> *)aImages
                        url:(NSURL *)aUrl
             rootController:(UIViewController *)controller
                 completion:(void (^)(NSInteger resault))completion
{
    NSString *wechat = [shareType isEqualToString:@"sina"]?SLServiceTypeSinaWeibo:shareType;
    if (![SLComposeViewController isAvailableForServiceType:wechat]) {
        NSLog(@" 不支持当前应用 ");
        return;
    }
    SLComposeViewController *compostVc = [SLComposeViewController composeViewControllerForServiceType:wechat];
    if (compostVc == nil)  return;
    [compostVc setInitialText:aText];
    for (UIImage *image in aImages) {
        [compostVc addImage:image];
    }
    if (aUrl) {
        [compostVc addURL:aUrl];
    }
    compostVc.completionHandler = ^(SLComposeViewControllerResult result) {
        // 1 完成 2取消
        completion(result==SLComposeViewControllerResultDone?1:2);
    };
    [controller presentViewController:compostVc animated:YES completion:nil];
}


// 保存文字到剪切板
- (void)pasteText:(NSString *)text
{
    if (text.length > 0) {
        [[UIPasteboard generalPasteboard] setString:text];
    }
}


#pragma mark - 图片下载处理
// 缓存九图处理
- (void)_cachePostPhotosCompletion:(void (^)(NSArray *cachesImages ,NSError *error))completion
{
    // 没有图片的情况下
    if (_shareImageUrls.count == 0) {
        completion(nil, [NSError errorWithDomain:@"没有找到素材相关图片" code:101 userInfo:nil]);
        return;
    }
    
    // 已经下载完成的情况下
    if (_isImagesCached) {
        completion(_allCacheImages, nil);
        return;
    }
    
    if (_allCacheImages == nil) {
        _allCacheImages = [[NSMutableArray alloc]init];
    }
    
    [_allCacheImages removeAllObjects];
    
    // 下载图片
    [self _batchDownloadImageWithUrl:self.shareImageUrls[0] completion:^(NSArray *cachesImages ,NSError *error) {
        _isImagesCached = (error == nil);
        completion(cachesImages, error);
    }];
}


// 批量下载图片处理
- (void)_batchDownloadImageWithUrl:(NSURL *)imageurl
                        completion:(void (^)(NSArray *cachesImages, NSError *error))completion
{
    // 加载动画
    __weak typeof(self) weakself = self;
    NSURL *url = imageurl;
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        // 加载动画
        //
        if (!error) {
            if ((cacheType == SDImageCacheTypeMemory && image) || data ) {
                [_allCacheImages addObject:image];
                if (_allCacheImages.count == weakself.shareImageUrls.count) {
                    // 下载完成
                    completion(_allCacheImages, nil);
                    return ;
                }
                
                // 继续执行
                [weakself _batchDownloadImageWithUrl:weakself.shareImageUrls[_allCacheImages.count] completion:completion];
            }
        }
        else {
            completion(_allCacheImages, error);
        }
    }];
}



#pragma mark - 分享文案已复制
- (void)initAnimateViewOnView:(UIView *)superView
{
    // 分享文案已复制，去粘贴
    if (_wechatShareLabel == nil) {
        // 后背景视图
        UIView *backgroundview = [[UIView alloc]initWithFrame:superView.bounds];
        backgroundview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [superView addSubview:backgroundview];
        _backgroundView = backgroundview;
        
        // 文案展示视图
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = [UIColor blackColor];
        [superView addSubview:v];
        v.alpha = 0;
        v.layer.cornerRadius = 3;
        v.layer.masksToBounds = YES;
        
        // 文案已复制
        UILabel *titlelb = [[UILabel alloc]init];
        titlelb.textColor = [UIColor whiteColor];
        titlelb.font = [UIFont systemFontOfSize:10];
        titlelb.text = @"分享文案已复制，请等待图片下载完成...";
        [v addSubview:titlelb];
        _wechatShareLabel = titlelb;
        NSMutableAttributedString *att = [titlelb.attributedText mutableCopy];
        [att addAttribute:NSKernAttributeName value:@1 range:NSMakeRange(0, titlelb.text.length)];
        titlelb.attributedText = att;
        [titlelb sizeToFit];
        [titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
        }];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(84));
            make.height.equalTo(@30);
            make.centerX.equalTo(superView.mas_centerX);
        }];
    }
}


// 弹出分享文案视图
- (void)_showWechatPasteView
{
    UIView *_wechatPasteView = _wechatShareLabel.superview;
    _wechatPasteView.alpha = 1;
    
    // 分享文案视图加个 上移 动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.toValue = @(114/2);
    animation.fromValue = @(114/2+150);
    animation.repeatCount = 1;
    animation.duration = 0.25;
    animation.removedOnCompletion = YES;
    [_wechatPasteView.layer addAnimation:animation forKey:@"postionanimation"];
    
    // 分享文案视图加个 放大 动画
    CABasicAnimation *transform = [CABasicAnimation animation];
    transform.keyPath = @"transform.scale";
    transform.fromValue = @0.6;
    transform.toValue = @1;
    transform.repeatCount = 1;
    transform.duration = 0.25;
    transform.removedOnCompletion = YES;
    [_wechatPasteView.layer addAnimation:transform forKey:@"transormanimation"];
    
    // 后背景视图展示
    [UIView animateWithDuration:0.05 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}


// 隐藏分享文案视图
- (void)_hideWechatPasteView
{
    [UIView animateWithDuration:0.05 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _wechatShareLabel.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        [_wechatShareLabel removeFromSuperview];
    }];
}



@end







