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
#import "MShareStaticMethod.h"
#import <SDWebImage/SDWebImageManager.h>
#import "AMDShareManager.h"
#import "SSAppPluginShare.h"

@interface AMDShareMaterialViewModel()
{
    __weak UIView *_middleView;          //内部视图
    __weak UIView *_wechatPasteView;        // 微信文案复制视图
    __weak UILabel *_wechatPasteLabel;      //文案 视图
//    __block NSMutableArray *_allCacheImages;        //缓存图片类
    __block BOOL _isImagesSaved;                //图片已经保存
//    __block BOOL _isImagesCached;                //图片已经缓存
    __weak AMDRootViewController *_senderController;
    __weak UIView *_currentBackView;
    
    SSAppPluginShare *_pluginShare;             //分享插件类
}

@end


@implementation AMDShareMaterialViewModel

- (void)dealloc
{
//    _allCacheImages = nil;
    self.shareImageUrls = nil;
    self.shareUrl = nil;
    self.shareContent = nil;
    _pluginShare = nil;
}


-(void)prepareView{
    _senderController = (AMDRootViewController *)self.senderController;
    [self initContentView];
//    [self initMembory];
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
    titlelb.textColor = SMDEFAULT_TEXT_GRAY_COLOR;
    titlelb.font = FontWithName(@"", 14);
    [middleView addSubview:titlelb];
    //    _titleLb = titlelb;
    [titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    // 线条
    AMDLineView *line = [[AMDLineView alloc]init];
    line.lineColor = SMLineColor;
    [middleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(titlelb.mas_bottom);
        make.height.equalTo(@(SMLineHeight));
    }];
    
    // 加载中间的按钮
    [self initShareBtsWithTopView:titlelb];
    
    // 取消按钮
    AMDButton *cancelbt = [[AMDButton alloc]init];
    cancelbt.titleLabel.text = @"取消";
    cancelbt.titleLabel.font = FontWithName(@"", 15);
    [cancelbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbt setBackgroundColor:SMLineColor forState:UIControlStateHighlighted];
    [cancelbt addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbt setTitleColor:SMDEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [_middleView addSubview:cancelbt];
    cancelbt.layer.borderWidth = SMBorderWidth;
    cancelbt.layer.borderColor = [SMsummary_text_color CGColor];
    cancelbt.layer.cornerRadius = SMCornerRadius;
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
        titlelb.text = @"分享文案已复制，请等待图片下载完成...";
        [v addSubview:titlelb];
        _wechatPasteLabel = titlelb;
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
//- (void)initMembory
//{
//    _allCacheImages = [[NSMutableArray alloc]init];
//}



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
        [shareBt setImage2:SMShareSrcImage(images[i]) forState:UIControlStateNormal];
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
        titleLB.textColor = SMDEFAULT_TEXT_GRAY_COLOR;
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
    // 先隐藏 分享ui 视图
    [self hideShareView];
    
    switch (sender.tag) {
        case 1:     //微信好友
        case 2:     //微信朋友圈
        {
            if (_pluginShare == nil) {
                _pluginShare = [[SSAppPluginShare alloc]init];
                _pluginShare.shareImages = _shareImageUrls;
                _pluginShare.shareUrl = [NSURL URLWithString:_shareUrl?_shareUrl:@""];
                _pluginShare.shareContent = _shareContent;
                _pluginShare.senderController = self.senderController;
                _pluginShare.pluginIder = SSPluginShareWechat;
            }
            
            __weak typeof(self) weakself = self;
            [_pluginShare share:^(NSInteger resault, NSError *error) {
                switch (resault) {
                    case 0: {   //失败
                        if (weakself.completionHandle) {
                            weakself.completionHandle(AMDShareTypeWeChatSession,AMDShareResponseFail,nil);
                        }
                    }
                        break;
                    case 1: {   //完成
                        [weakself hide];
                    }
                        break;
                    case 2: {   //取消
                        if (weakself.completionHandle) {
                            weakself.completionHandle(AMDShareTypeWeChatSession,AMDShareResponseCancel,nil);
                        }
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        case 3:     //保存图文
        {
            _wechatPasteLabel.text = @"图片正在保存中...";
            [self _showWechatPasteView];
            // 复制文本
            [self pasteText:_shareContent];
            
            __weak typeof(self) weakself = self;
            [self saveImagesToAlbumWithUrls:self.shareImageUrls completion:^(NSError *error) {
                // 隐藏展示视图
                _wechatPasteView.alpha = 0;

                   //回调提示
                    if (weakself.completionHandle) {
                        weakself.completionHandle(AMDShareTypeWeChatSession, error == nil ?AMDShareResponseSuccess:AMDShareResponseFail, nil);
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


//// 仅隐藏视图
- (void)hideShareView
{
    [UIView animateWithDuration:0.25 animations:^{
        _currentBackView.backgroundColor = [UIColor clearColor];
        
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@310);
        }];
        [_senderController.contentView layoutIfNeeded];
    }];
}


#pragma mark - private api
#pragma mark  直接调用微信相关点击

// 保存文字到剪切板
- (void)pasteText:(NSString *)text
{
    if (text.length > 0) {
        [[UIPasteboard generalPasteboard] setString:text];
    }
}


// 缓存图片
- (void)saveImagesToAlbumWithUrls:(NSArray *)imageurls
                       completion:(void (^)(NSError *error))completion
{
    if (_isImagesSaved || imageurls.count == 0){
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
//                        if (!_isImagesCached) {
//                            _isImagesCached = YES;
//                            [_allCacheImages removeAllObjects];
//                            [_allCacheImages addObjectsFromArray:cachePicImages];
//                        }
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
