//
//  AMDShareViewModel.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "AMDShareViewModel.h"
#import <Masonry/Masonry.h>
#import "SMConstVar.h"
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
    NSMutableArray *_shareTitleArray;
}

@end
@implementation AMDShareViewModel

-(void)prepareView{
    _senderController = (AMDRootViewController *)self.senderController;
    
    [self initContentView];
}


-(void)initContentView{
//    _shareImages = [[NSMutableArray alloc]init];
    
    //截取上个界面的画面做背景
    UIImageView *imageBack = [[UIImageView alloc]init];
    imageBack.image = _backImage;
    [_senderController.contentView addSubview:imageBack] ;
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    //半透明背景视图
    UIView *backView = [[UIView alloc]init];
//    backView.layer.borderWidth = 1;
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
    titlelb.textColor = SSColorWithRGB(119,119,119, 1);
    titlelb.font = SSFontWithName(@"", 14);
    [middleView addSubview:titlelb];
    _titleLb = titlelb;
    [titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    // 线条
    AMDLineView *line = [[AMDLineView alloc]init];
    line.lineColor = SSColorWithRGB(230, 230, 230, 1);
    [middleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(titlelb.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    // 加载中间的按钮
    
    
    // 取消按钮
    AMDButton *cancelbt = [[AMDButton alloc]init];
    cancelbt.titleLabel.text = @"取消";
    cancelbt.titleLabel.font = SSFontWithName(@"", 15);
    [cancelbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbt setBackgroundColor:SSColorWithRGB(230, 230, 230, 1) forState:UIControlStateHighlighted];
    [cancelbt addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbt setTitleColor:SSColorWithRGB(51,51,51, 1) forState:UIControlStateNormal];
    [middleView addSubview:cancelbt];
    cancelbt.layer.borderWidth = 0.5;
    cancelbt.layer.borderColor = [SSColorWithRGB(153,153,153, 1) CGColor];
    cancelbt.layer.cornerRadius = 3;
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
    if (shareTitles.count<=4) {
        [_middleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(230);
        }];
    }
    __weak UIView *_firstBt = nil;
    __weak UIView *_lastBt = nil;
    for (NSInteger i = 0; i<shareTitles.count; i++) {
        //按钮背景
        UIView *backView = [[UIView alloc]init];
        [_middleView addSubview:backView];
        backView.tag = [shareTitles hash];
        
        //分享图片按钮
        AMDButton *shareBt = [[AMDButton alloc]init];
        shareBt.tag = i;
        shareBt.layer.cornerRadius = 25;
        shareBt.layer.masksToBounds = YES;
        [shareBt setBackgroundColor:nil forState:UIControlStateHighlighted];
        [shareBt setImage2: SMShareSrcImage(shareIcons[i]) forState:UIControlStateNormal];
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
        titleLB.tag = i;
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = SSFontWithName(@"", 12);
        titleLB.textColor = SSColorWithRGB(119,119,119, 1);
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
    
    // 修正当配置数量少于一行的时候
    if (shareTitles.count < 4) {
        [_lastBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
        }];
    }
}


-(void)invokeBtTitleAndImage:(void(^)(NSArray *images,NSArray*titles))completion{
    NSMutableArray *shareTitles = [[NSMutableArray alloc]init];
    _shareTitleArray = shareTitles;
    NSMutableArray *shareIcons = [[NSMutableArray alloc]init];
    if (!self.customIntentIdentifiers) {
        NSArray *title = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间",@"微博",@"复制链接"];
        [shareTitles addObjectsFromArray:title];
        NSArray *image = @[@"share_weixin@2x.png",@"share_weixin-friend@2x.png",@"share_qq@2x.png",@"share_q-zone@2x.png",@"share_weibo@2x.png",@"M_copy_100@2x.png"];
        [shareIcons addObjectsFromArray:image];
    }else{
        for (int i = 0; i<self.customIntentIdentifiers.count; i++) {
            NSNumber *ident =self.customIntentIdentifiers[i];
            switch (ident.integerValue) {
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
    NSString *infourl = _shareUrl;
    
    AMDShareType shareType = 0;
    
    if ([_shareTitleArray[sender.tag] isEqualToString:@"微信好友" ]) {
        shareType = AMDShareTypeWeChatSession;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString: @"朋友圈"]) {
        shareType = AMDShareTypeweChatTimeline;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString:@"图文分享" ]) {
        shareType = AMDShareTypeTuwenShare;
        if (_completionHandle) {
            _completionHandle(shareType,AMDShareResponseSuccess,nil);
        }
        return;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString: @"商品二维码"]) {
        shareType = AMDShareTypeQrCode;
        if (_completionHandle) {
            _completionHandle(shareType,AMDShareResponseSuccess,nil);
        }
        return;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString:@"QQ好友"]) {
        //        shareTypeStr = @"qq";
        shareType = AMDShareTypeQQ;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString:@"微博" ]) {
        shareType = AMDShareTypeSina;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString:@"QQ空间"]) {
        shareType = AMDShareTypeQQZone;
    }
    else if ([_shareTitleArray[sender.tag] isEqualToString: @"复制链接"]) {
        shareType = AMDShareTypeCopy;
        NSString*pasteboardString = @"";
        NSString*shorturl = self.shareShortUrl.length>0?self.shareShortUrl:self.shareUrl;
        if ([self.shareContent rangeOfString:@"http"].length == 0 && shorturl.length > 0) {
            pasteboardString = [self.shareContent stringByAppendingFormat:@" %@",shorturl];
        }
        else {
            pasteboardString = [self.shareContent stringByAppendingFormat:@" %@",shorturl];
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = pasteboardString;
    }
    
    //分享时需要压缩图片(统一在底层裁剪)
    NSURL  *imgUrl = [[NSURL alloc]init];
    if (_shareImageUrls.count>0) {
        imgUrl   = _shareImageUrls[0];
    }
    
    // 分享
    switch (_shareSource) {
        case 1:     //有量
        {
            [AMDUMSDKManager shareToUMWithType:shareType shareContent:contentString shareTitle:titleString shareImageUrl:imgUrl url:infourl competion:^(AMDShareResponseState responseState, NSError *error) {
                if (_completionHandle) {
                    _completionHandle(shareType,responseState,error);
                }
            }];
        }
            break;
        default:
        {
            [AMDShareManager shareType:shareType content:contentString title:titleString imageUrl:imgUrl infoUrl:infourl competion:^(AMDShareResponseState responseState, NSError *error) {
                if (_completionHandle) {
                    _completionHandle(shareType,responseState,error);
                }
            }];
        }
            break;
    }
    
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_middleView]) {
        return NO;
    }
    return YES;
}
@end
