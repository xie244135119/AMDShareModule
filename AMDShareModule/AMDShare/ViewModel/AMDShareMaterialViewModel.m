//
//  AMDShareMaterialViewModel.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/4.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "AMDShareMaterialViewModel.h"
#import <Masonry/Masonry.h>
#import <SSBaseKit/SSBaseKit.h>
#import <Social/Social.h>
#import "MShareStaticMethod.h"
//#import "MShareManager.h"
//#import "MShareTool.h"
#import "SDWebImageManager.h"


@interface AMDShareMaterialViewModel()
{
    __weak UIView *_middleView;          //内部视图
    __weak UIView *_wechatPasteView;        // 微信文案复制视图
    __block NSMutableArray *_allCacheImages;        //缓存图片类
    __block BOOL _isImagesSaved;                //图片已经保存
    __block BOOL _isImagesCached;                //图片已经缓存
    __weak AMDRootViewController *_senderController;
    __weak UIView *_currentBackView;
}



@end


@implementation AMDShareMaterialViewModel

- (void)dealloc
{
    _allCacheImages = nil;
    self.shareImageUrls = nil;
    self.shareUrl = nil;
    self.shareContent = nil;
}


-(void)prepareView{
    _senderController = (AMDRootViewController *)self.senderController;
    [self initContentView];
    [self initMembory];
}


#pragma mark - 视图加载
- (void)initContentView
{
//    self.backgroundColor = [UIColor clearColor];
    //点击添加手势
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    recognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [recognizer setNumberOfTapsRequired:1];
    [_senderController.contentView addGestureRecognizer:recognizer];
    
    //截取上个界面的画面做背景
    UIImageView *imageBack = [[UIImageView alloc]init];
    imageBack.image = _backImage;
    [_senderController.contentView addSubview:imageBack] ;
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    //半透明背景视图
    UIView *backView = [[UIView alloc]init];
    _currentBackView = backView;
    [imageBack addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = [UIColor whiteColor];
    [_senderController.contentView addSubview:middleView];
    _middleView = middleView;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@240);
        make.bottom.equalTo(@240);
    }];
    
    // 选择分享方式
    UILabel *titlelb = [[UILabel alloc]init];
    titlelb.text = @"选择分享方式";
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.textColor = DEFAULT_TEXT_GRAY_COLOR;
    titlelb.font = FontWithName(@"", 14);
    [middleView addSubview:titlelb];
    //    _titleLb = titlelb;
    [titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    // 线条
    AMDLineView *line = [[AMDLineView alloc]init];
    line.lineColor = AMDLineColor;
    [middleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(titlelb.mas_bottom);
        make.height.equalTo(@(AMDLineHeight));
    }];
    
    // 加载中间的按钮
    [self initShareBtsWithTopView:titlelb];
    
    // 取消按钮
    AMDButton *cancelbt = [[AMDButton alloc]init];
    cancelbt.titleLabel.text = @"取消";
    cancelbt.titleLabel.font = FontWithName(@"", 15);
    [cancelbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbt setBackgroundColor:AMDLineColor forState:UIControlStateHighlighted];
    [cancelbt addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbt setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [_middleView addSubview:cancelbt];
    cancelbt.layer.borderWidth = AMDBorderWidth;
    cancelbt.layer.borderColor = [summary_text_color CGColor];
    cancelbt.layer.cornerRadius = AMDCornerRadius;
    cancelbt.layer.masksToBounds = YES;
    [cancelbt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@45);
        make.bottom.equalTo(@-13);
    }];
    
    
    // 分享文案已复制，去粘贴
    if (_wechatPasteView == nil) {
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = [UIColor blackColor];
        [_senderController.contentView addSubview:v];
        v.alpha = 0;
        v.layer.cornerRadius = 3;
        v.layer.masksToBounds = YES;
        _wechatPasteView = v;
        
        // 文案已复制
        UILabel *titlelb = [[UILabel alloc]init];
        titlelb.textColor = [UIColor whiteColor];
        titlelb.font = FontWithName(@"", 12);
        titlelb.text = @"分享文案已复制，去粘贴";
        [v addSubview:titlelb];
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
            make.centerX.equalTo(_senderController.contentView.mas_centerX);
        }];
    }
}

// 加载内存
- (void)initMembory
{
    _allCacheImages = [[NSMutableArray alloc]init];
}



// 内部分享按钮
// 加载分享按钮
- (void)initShareBtsWithTopView:(UIView *)topLabel
{
#define XQAnimationSrcName(file) [@"ShareImageTwo.bundle" stringByAppendingPathComponent:file]
    NSArray *titles = @[@"微信好友",@"朋友圈",@"保存图文"];
    NSArray *images = @[@"share_weixin@2x.png",@"share_weixin-friend@2x.png",@"share_picturetext@2x.png"];
    
    //按钮背景
    UIView *backView = [[UIView alloc]init];
    [_middleView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@100);
        make.top.equalTo(topLabel.mas_bottom).with.offset(20);
    }];
    
    for (NSInteger i = 0; i<titles.count; i++) {
        
        UIView *v = [[UIView alloc]init];
        [backView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@80);
            make.top.equalTo(@10);
            
            make.centerX.equalTo(backView.mas_centerX).multipliedBy((CGFloat)(2*i+1)/3);
        }];
        
        //分享图片按钮
        AMDButton *shareBt = [[AMDButton alloc]init];
        shareBt.tag = i+1;
        shareBt.layer.cornerRadius = 25;
        shareBt.layer.masksToBounds = YES;
        [shareBt setBackgroundColor:nil forState:UIControlStateHighlighted];
        [shareBt setImage2:AMDShareSrcImage(images[i]) forState:UIControlStateNormal];
        [shareBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:shareBt];
        [shareBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.left.top.equalTo(@0);
        }];
        
        UILabel *titleLB = [[UILabel alloc]init];
        titleLB.text = titles[i];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = FontWithName(@"", 12);
        titleLB.textColor = DEFAULT_TEXT_GRAY_COLOR;
        [v addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@20);
        }];
    }
}




#pragma mark - 按钮事件
// 按钮事件
- (void)clickAction:(AMDButton *)sender
{
    switch (sender.tag) {
        case 1:     //微信好友
        case 2:     //微信朋友圈
        {
            __weak typeof(self) weakself = self;
            [self cachePostPhotosCompletion:^(NSArray *cachesImages ,NSError *error) {
                if (error == nil) {
                    //
                    [weakself _showWechatPasteView];
                    
                    // 调用微信分享和复制文本
                    [weakself pasteText:weakself.shareContent];
                    [weakself wechatShareWithText:weakself.shareContent images:cachesImages url:weakself.shareUrl];
                }
                else {
                    [weakself hide];
                }
            }];
        }
            break;
        case 3:     //保存图文
        {
            __weak typeof(self) weakself = self;
            [self saveImagesToAlbumWithUrls:self.shareImageUrls completion:^(NSError *error) {
                if (error == nil) {
                    [weakself pasteText:weakself.shareContent];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

// 按钮事件
- (void)clickCancelAction:(AMDButton *)sender
{
    [self hide];
}

//


#pragma mark - public api

- (void)show
{
    [_senderController.contentView layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        _currentBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
        }];
        [_senderController.contentView layoutIfNeeded];
    }];
}

// 隐藏
- (void)hide
{
    _wechatPasteView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        _currentBackView.backgroundColor = [UIColor clearColor];
        
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@310);
        }];
        [_senderController.contentView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [_senderController dismissViewControllerAnimated:NO completion:nil];
    }];
}


#pragma mark - private api
#pragma mark  直接调用微信相关点击
// 直接调用微信分享
- (void)wechatShareWithText:(NSString *)aText
                     images:(NSArray *)aImages
                        url:(NSString *)aUrl
{
    NSString *wechat = @"com.tencent.xin.sharetimeline";
    if (![SLComposeViewController isAvailableForServiceType:wechat]) {
        NSLog(@" 不支持相关账号 ");
        return;
    }
    SLComposeViewController *compostVc = [SLComposeViewController composeViewControllerForServiceType:wechat];
    if (compostVc == nil)  return;
    [compostVc setInitialText:aText];
    for (UIImage *image in aImages) {
        [compostVc addImage:image];
    }
    if (aUrl.length > 0) {
        
    }
    __weak typeof(self) weakself = self;
    compostVc.completionHandler = ^(SLComposeViewControllerResult result) {
        // 隐藏粘贴视图
        _wechatPasteView.alpha = 0;
        // 隐藏视图
        [weakself hide];
    };
    
    id app = [UIApplication sharedApplication].delegate;
    [[[app window] rootViewController] presentViewController:compostVc animated:YES completion:nil];
}


// 保存文字到剪切板
- (void)pasteText:(NSString *)text
{
    if (text.length > 0) {
        [[UIPasteboard generalPasteboard] setString:text];
    }
}


// 缓存九图处理
- (void)cachePostPhotosCompletion:(void (^)(NSArray *cachesImages ,NSError *error))completion
{
    // 没有图片的情况下
    if (self.shareImageUrls.count == 0) {
        completion(nil, [NSError errorWithDomain:@"没有找到素材相关图片" code:101 userInfo:nil]);
        return;
    }
    
    // 已经下载完成的情况下
    if (_isImagesCached) {
        completion(_allCacheImages, nil);
        return;
    }
    [_allCacheImages removeAllObjects];
    
    // 判断图片权限
    //    if ([self permissionFromAlbum]) {
    // 下载图片
    [self _batchDownloadImageWithUrl:self.shareImageUrls[0] completion:^(NSArray *cachesImages ,NSError *error) {
        if (error == nil) {
            _isImagesCached = YES;
            completion(cachesImages, error);
        }
    }];
    //    }
}



// 批量下载图片处理
- (void)_batchDownloadImageWithUrl:(NSString *)imageurl
                        completion:(void (^)(NSArray *cachesImages, NSError *error))completion
{
    // 加载动画
    __weak typeof(self) weakself = self;
    NSURL *url = [NSURL URLWithString:imageurl];
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        // 加载动画
        //
        if (finished) {
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
            else {
                //                completion(_allCacheImages, error);
            }
        }
        else {
            //            completion(_allCacheImages, error);
        }
    }];
}


// 缓存图片
- (void)saveImagesToAlbumWithUrls:(NSArray *)imageurls
                       completion:(void (^)(NSError *error))completion
{
    if (_isImagesSaved){
        completion(nil);
        return;
    }
    
    // 判断图片权限
    if (![self.serviceProtocal permissionFromType:AMDPrivacyPermissionTypeAssetsLibrary]) {
        return;
    }
    
    [self.serviceProtocal perpareForSendNinePhotos:self.shareImageUrls successAction:^(NSArray * _Nullable cachePicImages, NSError * _Nullable error) {
        if (cachePicImages.count > 0) {
                        _isImagesSaved = YES;
                        if (!_isImagesCached) {
                            _isImagesCached = YES;
                            [_allCacheImages removeAllObjects];
                            [_allCacheImages addObjectsFromArray:cachePicImages];
                        }
                    }
        completion(nil);

    } failAction:^(NSArray * _Nullable cachePicImages, NSError * _Nullable error) {
                completion(error);
    }];
    
  
}


#pragma mark - 分享文案视图相关
// 弹出微信插件（隐藏middleView操作 显示粘贴事件）
- (void)_showWechatPasteView
{
    _wechatPasteView.alpha = 1;
    
    // 分享文案视图加个 上移 动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.toValue = @(_wechatPasteView.center.y);
    animation.fromValue = @(_wechatPasteView.center.y+150);
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
    
    [UIView animateWithDuration:0.25 animations:^{
        _currentBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        // 隐藏 middleView
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@310);
        }];
        [_senderController.contentView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        // 弹出已复制视图标志
    }];
}



#pragma mark - Touch事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_middleView]) {
        return NO;
    }
    return YES;
}
@end
