//
//  AMDShareViewModel.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "AMDShareViewModel.h"
#import <Masonry/Masonry.h>
#import "MShareStaticMethod.h"
#import "MShareManager.h"
#import "AMDShareManager.h"
#import "AMDUMSDKManager.h"
#import <Social/Social.h>
#import "AMDShareConfig.h"

@interface AMDShareViewModel()
{
    __weak AMDRootViewController *_senderController;
    __weak UIView *_middleView;         //分享背景视图
    __weak UILabel *_titleLb;               //文字
    __weak UIView *_currentBackView;            //  透明背景图
    NSMutableArray *_shareImages; //分享的image数组
    NSArray *_shareImagesURLs;
    NSString *_shareShortUrl;
    NSString *_shareInfoURL;
    NSString *_shareTitle;
    NSString *_shareContent;
    NSString *_shareImageURL;
    
}

@end
@implementation AMDShareViewModel

-(void)prepareView{
    _senderController = (AMDRootViewController *)self.senderController;
    
    [self initContentView];
}


-(void)initContentView{
    _shareImages = [[NSMutableArray alloc]init];
    
    //截取上个界面的画面做背景
    UIImageView *imageBack = [[UIImageView alloc]init];
    imageBack.image = _backImage;
    [_senderController.contentView addSubview:imageBack] ;
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    //半透明背景视图
    UIView *backView = [[UIView alloc]init];
    backView.layer.borderWidth = 1;
    _currentBackView = backView;
    [imageBack addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    //点击添加手势
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
            recognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
            [recognizer setNumberOfTapsRequired:1];
            [_senderController.contentView addGestureRecognizer:recognizer];
    
    //分享按钮背景图
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = [UIColor whiteColor];
    [_senderController.contentView addSubview:middleView];
    _middleView = middleView;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@310);
        make.bottom.equalTo(@(310));
    }];
    
    // 选择分享方式
    UILabel *titlelb = [[UILabel alloc]init];
    titlelb.text = @"选择分享方式";
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.textColor = DEFAULT_TEXT_GRAY_COLOR;
    titlelb.font = FontWithName(@"", 14);
    [middleView addSubview:titlelb];
    _titleLb = titlelb;
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
    
    
    // 取消按钮
    AMDButton *cancelbt = [[AMDButton alloc]init];
    cancelbt.titleLabel.text = @"取消";
    cancelbt.titleLabel.font = FontWithName(@"", 15);
    [cancelbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbt setBackgroundColor:AMDLineColor forState:UIControlStateHighlighted];
    [cancelbt addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbt setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [middleView addSubview:cancelbt];
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
    [self initShareBts];
    
}


// 加载分享按钮
- (void)initShareBts
{
    __block   NSArray *shareTitles = nil;
    __block   NSArray *shareIcons = nil;
    [self invokeBtTitleAndImage:^(NSArray *images, NSArray *titles) {
        shareTitles = titles;
        shareIcons = images;
    }];
    
    __weak UIView *_firstBt = nil;
    __weak UIView *_lastBt = nil;
    for (NSInteger i = 0; i<shareTitles.count; i++) {
        //按钮背景
        UIView *backView = [[UIView alloc]init];
        [_middleView addSubview:backView];
        backView.tag = [shareTitles hash];
        
        //分享图片按钮
        AMDButton *shareBt = [[AMDButton alloc]init];
        shareBt.tag = [shareTitles[i] hash];
        shareBt.layer.cornerRadius = 25;
        shareBt.layer.masksToBounds = YES;
        [shareBt setBackgroundColor:nil forState:UIControlStateHighlighted];
        [shareBt setImage2: AMDShareSrcImage(shareIcons[i]) forState:UIControlStateNormal];
        [shareBt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:shareBt];
        
        [shareBt.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.centerX.equalTo(shareBt.mas_centerX);
            make.centerY.equalTo(shareBt.mas_centerY);
        }];
        
        [shareBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.centerX.equalTo(backView.mas_centerX);
            make.top.equalTo(@5);
        }];
        
        //分享标题
        UILabel *titleLB = [[UILabel alloc]init];
        titleLB.text = shareTitles[i];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = FontWithName(@"", 12);
        titleLB.textColor = DEFAULT_TEXT_GRAY_COLOR;
        [backView addSubview:titleLB];
        
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@15);
            make.top.equalTo(shareBt.mas_bottom).with.offset(5);
        }];
        
        NSInteger row = i/4;
        NSInteger column = i%4;
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@80);
            
            // 第一个按钮不存在的时候
            if (_firstBt == nil) {
                make.top.equalTo(_titleLb.mas_bottom).with.offset(15);
                make.left.equalTo(@10);
            }
            else {
                // 设置等宽度
                make.width.equalTo(_lastBt.mas_width);
                
                // 第一行
                if (row == 0) {
                    make.top.equalTo(_firstBt.mas_top);
                }
                else {  //其余行的时候
                    make.top.equalTo(_firstBt.mas_bottom).with.offset(15);
                }
                
                // 首列
                if (column == 0) {  make.left.equalTo(@10); }
                else {// 设置左侧约束
                    make.left.equalTo(_lastBt.mas_right).with.offset(10);
                    
                    // 末列
                    if (column == 3) {  make.right.equalTo(@-10); }
                }
            }
        }];
        
        _lastBt = backView;
        if (i == 0)  _firstBt = backView;
    }
}


-(void)invokeBtTitleAndImage:(void(^)(NSArray *images,NSArray*titles))completion{
    NSMutableArray *shareTitles = [[NSMutableArray alloc]init];
    NSMutableArray *shareIcons = [[NSMutableArray alloc]init];
    if (!self.customIntentIdentifiers) {
        NSArray *title = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间",@"微博",@"复制链接"];
        [shareTitles addObjectsFromArray:title];
        NSArray *image = @[@"share_weixin@2x.png",@"share_weixin-friend@2x.png",@"share_qq@2x.png",@"share_q-zone@2x.png",@"share_weibo@2x.png",@"M_copy_100@2x.png"];
        [shareIcons addObjectsFromArray:image];
    }else{
        for (int i = 0; i<self.customIntentIdentifiers.count; i++) {
            switch (i+1) {
                case 1:
                {
                    [shareTitles addObject:@"微信好友"];
                    [shareIcons addObject:@"share_weixin@2x.png"];
                }
                    break;
                case 2:
                {
                    [shareTitles addObject:@"朋友圈"];
                    [shareIcons addObject:@"share_weixin-friend@2x.png"];
                }
                    break;
                case 3:
                {
                    [shareTitles addObject:@"图文分享"];
                    [shareIcons addObject:@"share_picturetext@2x.png"];
                }
                    break;
                case 4:
                {
                    [shareTitles addObject:@"商品二维码"];
                    [shareIcons addObject:@"share_qrcode@2x.png"];
                }
                    break;
                case 5:
                {
                    [shareTitles addObject:@"QQ好友"];
                    [shareIcons addObject:@"share_qq@2x.png"];
                }
                    break;
                case 6:
                {
                    [shareTitles addObject:@"QQ空间"];
                    [shareIcons addObject:@"share_q-zone@2x.png"];
                }
                    break;
                    
                    
                case 7:
                {
                    [shareTitles addObject:@"微博"];
                    [shareIcons addObject:@"share_weibo@2x.png"];
                }
                    break;
                    
                case 8:
                {
                    [shareTitles addObject:@"复制链接"];
                    [shareIcons addObject:@"M_copy_100@2x.png"];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    completion(shareIcons,shareTitles);
    
}


- (void)show
{
    [_senderController.contentView layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
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




#pragma mark - Touch事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}



#pragma mark - 按钮事件
- (void)clickCancelAction:(AMDButton *)sender
{
    [self hide];
}


- (void)clickAction:(UIButton *)sender
{
    NSString *titleString = _shareTitle;
    NSString *contentString = self.shareContent;
    NSString *infourl = _shareInfoURL;
    
    AMDShareType shareType = 0;
    
    if (sender.tag == [@"微信好友" hash]) {
        shareType = AMDShareTypeWeChatSession;
    }
    else if (sender.tag == [@"朋友圈" hash]) {
        shareType = AMDShareTypeweChatTimeline;
    }
    else if (sender.tag == [@"图文分享" hash]) {
        shareType = AMDShareTypeTuwen;
        if (_handleShareAction) {
            _handleShareAction(shareType,@"");
        }
    }
    else if (sender.tag == [@"商品二维码" hash]) {
        shareType = AMDShareTypeQrCode;
        if (_handleShareAction) {
            _handleShareAction(shareType,@"");
        }
    }
    else if (sender.tag == [@"QQ好友" hash]) {
        //        shareTypeStr = @"qq";
        shareType = AMDShareTypeQQ;
    }
    else if (sender.tag == [@"微博" hash]) {
        shareType = AMDShareTypeSina;
    }
    else if (sender.tag == [@"QQ空间" hash]) {
        shareType = AMDShareTypeQQZone;
    }
    else if (sender.tag == [@"复制链接" hash]) {
        [self shareCopy];
        return;
    }
    
    if (shareType == AMDShareTypeQrCode||shareType == AMDShareTypeTuwen) {
        return;
    }
    
    //分享时需要压缩图片(统一在底层裁剪)
    NSString *imgUrl = _shareImageURL;
    
    // 分享
    switch (_shareSource) {
        case 0:     //有量
        {
            [AMDShareManager shareType:shareType content:contentString title:titleString imageUrl:imgUrl infoUrl:infourl competion:^(NSString *alertTitle) {
                if (_handleShareAction) {
                    _handleShareAction(shareType,alertTitle);
                }
            }];
        }
            break;
        default:
        {
            [AMDUMSDKManager shareToUMWithType:shareType shareContent:contentString shareTitle:titleString shareImageUrl:imgUrl url:infourl competion:^(NSString *alertTitle) {
                if (_handleShareAction) {
                    _handleShareAction(shareType,alertTitle);
                }
            }];
        }
            break;
    }
    
}


//
////弹出系统分享控件
-(void)shareImageText{
    // 复制文字到剪切板
    [self saveCopyText];
    
    // 直接调用微信分享
    [self wechatShareWithText:nil images:_shareImages.count>0?_shareImages:@[AMDLoadingImage] url:nil];
}


#pragma mark - 直接调用微信插件分享
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
    [compostVc setInitialText:aText];
    for (UIImage *image in aImages) {
        [compostVc addImage:image];
    }
    if (aUrl.length > 0) {
        //        [compostVc addURL:[NSURL URLWithString:aUrl]];
    }
    id app = [UIApplication sharedApplication].delegate;
    [[[app window] rootViewController] presentViewController:compostVc animated:YES completion:nil];
}



//-(void)setShareImagesURLs:(NSArray *)shareImagesURLs{
//    if (shareImagesURLs) {
//
//    }
//}

//url转换成image对象
- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result = AMDLoadingImage;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    if (data) {
        result = [UIImage imageWithData:data];
    }
    return result;
}

//
-(void)shareCopy
{
    /**
     *  小店内部复制链接的时候这边需要拼上店铺名称，这边单独处理
     */
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _shareContent;
}

#pragma mark - 九图保存
- (void)saveCopyText
{
    //有短链的时候复制短链 没有则复制商品原始链接
    NSString *shareUrl = _shareShortUrl.length>0?_shareShortUrl:_shareInfoURL;
    
    if (_shareContent.length > 0 || _shareTitle.length > 0 || shareUrl.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if([_shareContent rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
        {
            pasteboard.string = [NSString stringWithFormat:@"%@ %@",NonNil(_shareTitle,@""),_shareContent];
        }
        
        else
        {
            pasteboard.string = [NSString stringWithFormat:@"%@ %@ %@",NonNil(_shareTitle,@""),_shareContent,NonNil(shareUrl,@"")];
        }
    }
}

// 图文分享
- (void)shareNinePhotoCompletion:(void (^)(void))completion
{
    [[[MShareManager shareInstance] animationDelegate] showAnimation];
    //    [[AMDRequestService sharedAMDRequestService] animationStartForDelegate:self];
    
    //    开启子线程下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *imageURL in _shareImagesURLs) {
            NSString * aimageURL = [imageURL stringByAppendingString:@"?imageView2/3/w/640/h/100"];
            [_shareImages addObject: [self getImageFromURL:aimageURL]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[MShareManager shareInstance] animationDelegate] stopAnimation];
            //            [[AMDRequestService sharedAMDRequestService] animationStopForDelegate:self];
            completion();
        });
    });
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_middleView]) {
        return NO;
    }
    return YES;
}
@end
