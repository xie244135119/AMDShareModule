//
//  AMDShareViewModel.m
//  AppMicroDistribution
//
//  Created by 马清霞 on 16/7/22.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDShareQrCodeView.h"
#import "MShareTool.h"
#import "AMDUMSDKManager.h"
#import "AMDShareManager.h"
#import "MShareStaticMethod.h"
#import "MShareManager.h"

@interface AMDShareQrCodeView()
{
    UIView   *_backView;
    AMDButton __weak *_cancelBt;
    AMDImageView __weak*_shareimageView;//商品图片
    UILabel *_shareContentLB;//商品介绍
    UIImageView __weak *_codeImgView;//商品二维码图片
    UIImage *_screenshotImg;//截出的图片
    UIView *_shareBackView;
}

@end


@implementation AMDShareQrCodeView

-(instancetype)init
{
    if (self = [super init]) {
        [self initContentView];
    }
    return self;
}

//搭建视图
-(void)initContentView{
#define XQAnimationSrcName(file) [@"ShareImageTwo.bundle" stringByAppendingPathComponent:file]

    self.frame =CGRectMake(0, 0, APPWidth, APPHeight);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15, 130/2, APPWidth-30, APPHeight-64-70)];
    
    if ([MShareTool deviceModel] == AASDeviceModelType_iPhone6) {
        backView.frame =   CGRectMake(15, 180/2, APPWidth-30, APPHeight-64-115);
    }
    if ([MShareTool deviceModel] == AASDeviceModelType_iPhone6Plus) {
        backView.frame =   CGRectMake(15, 210/2, APPWidth-30, APPHeight-64-145);
    }
    
    backView.layer.cornerRadius = 6;
    _backView = backView;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    AMDImageView *imgView = [[AMDImageView alloc]initWithFrame:CGRectMake(25, 25, backView.frame.size.width-50, backView.frame.size.width-50)];
    _shareimageView = imgView;
    //    imgView.backgroundColor = AMDNavBarColor;
    [backView addSubview:imgView];
    
    NSString *imgStr = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/%.0f/h/%.0f", _shareImageURL,_shareimageView.frame.size.width*2,_shareimageView.frame.size.height*2]];
    [_shareimageView setImageWithUrl:[NSURL URLWithString:imgStr] placeHolder:AMDLoadingImage];
    
    
    UILabel *descLB = [[UILabel alloc]initWithFrame:CGRectMake(25, imgView.frame.size.height+imgView.frame.origin.y+5, backView.frame.size.width-50, 70/2)];
    descLB.numberOfLines = 0;
    descLB.font = FontWithName(@"", 12);
    descLB.textColor = DEFAULT_TEXT_COLOR;
    _shareContentLB = descLB;
    [backView addSubview:descLB];
    
    UIImageView *codeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, descLB.frame.origin.y+descLB.frame.size.height+5, 106/2, 106/2)];
    _codeImgView = codeImgView;
    [backView addSubview:codeImgView];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(168/2, descLB.frame.origin.y+descLB.frame.size.height+5, 200,  106/2)];
    lb.text = @"长按或扫描二维码可查看详情";
    lb.textColor = summary_text_color;
    lb.font = FontWithName(@"", 12);
    [backView addSubview:lb];
    
    UIView *shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height-60, backView.frame.size.width, 60)];
    _shareBackView = shareBackView;
    shareBackView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [backView addSubview:shareBackView];
    
    NSArray *imgArr = @[@"M_weixin_68@2x.png",@"M_weixin-friend_68@2x.png",@"M_q-zone_68@2x.png",@"M_weibo_68@2x.png",@"M_download_68@2x.png"];
    
    for (NSInteger i = 0; i < 5; i++) {
        AMDButton *shareBt = [[AMDButton alloc]initWithFrame:CGRectMake(i* backView.frame.size.width/5, 0, backView.frame.size.width/5, 60)];
        shareBt.tag = i+1;
        [shareBt addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [shareBackView addSubview:shareBt];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(((backView.frame.size.width - 5*34)/6)+i* (34+((backView.frame.size.width - 5*34)/6)), 30-(34/2), 34, 34)];
        UIImage *image = imageFromBundleName(@"ShareImage.bundle", imgArr[i]);
        [shareBt setImage2:image forState:UIControlStateNormal];

        [shareBackView addSubview:img];
    }
    
    AMDButton *bt = [[AMDButton alloc]initWithFrame:CGRectMake(backView.frame.size.width-35, 6, 42, 42)];
    _cancelBt = bt;
    bt.imageView.bounds = bt.bounds;
    bt.tag = 6;
    [bt addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    bt.imageView.image = imageFromBundleName(@"CommonUIModule.bundle", @"adver_pop_close.png");
    [backView addSubview:bt];
}



-(void)setShareInfoURL:(NSString *)shareInfoURL{
    if (shareInfoURL) {
        _codeImgView.image = [MShareTool imageQrcodeViewWithStr:shareInfoURL];
    }
    _shareInfoURL = shareInfoURL?shareInfoURL:@"";
}

-(void)setShareImageURL:(NSString *)shareImageURL{
    if (shareImageURL) {
        NSString *imgStr = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/%.0f/h/%.0f", shareImageURL,_shareimageView.frame.size.width*2,_shareimageView.frame.size.height*2]];
        [_shareimageView setImageWithUrl:[NSURL URLWithString:imgStr] placeHolder:AMDLoadingImage];
    }
    _shareImageURL = shareImageURL;
}


-(void)setGoodsTitle:(NSString *)goodsTitle{
    if (goodsTitle) {
        _shareContentLB.text = goodsTitle.length>0?goodsTitle:@"";
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineSpacing = 5;
        paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
        _shareContentLB.attributedText = [[NSAttributedString alloc] initWithString:_shareContentLB.text
                                                                         attributes:@{
                                                                                      NSParagraphStyleAttributeName: paragraph
                                                                                      }];
    }
    _goodsTitle = goodsTitle;
}

#pragma mark - 点击事件
-(void)Click:(AMDButton *)sender{
    _screenshotImg =  [self ScreenShot];
    NSString *imageurl = @"";
    AMDShareType shareType = 0;
    switch (sender.tag) {
        case 1://微信好友
        {
            shareType = AMDShareTypeWeChatSession;
        }
            break;
        case 2://朋友圈
        {
            shareType = AMDShareTypeweChatTimeline;
        }
            break;
        case 3://QQ空间
        {
            shareType = AMDShareTypeQQZone;
            imageurl  =  [MShareTool writeImageToFile:_screenshotImg];
        }
            break;
        case 4://微博
        {
            shareType = AMDShareTypeSina;
            imageurl  =  [MShareTool writeImageToFile:_screenshotImg];
        }
            break;
        case 5://保存到本地
            [self savaToTheLocalWithImage:_screenshotImg];
            break;
        case 6://取消分享
        {
            [self hide];
            return;
        }
            break;
        default:
            break;
    }
    
    // 分享
    if (shareType > 0 ) {
        if ([[[MShareManager shareInstance] requestDelegare] respondsToSelector:@selector(invokeForwardRelationshipWithPlatform:completion:)]) {
            [[[MShareManager shareInstance] requestDelegare] invokeForwardRelationshipWithPlatform:shareType completion:^(NSError *error) {
                
            }];
        }

        if ( _shareSource == 1) {//有量
            [AMDShareManager shareType:shareType photoURL:imageurl];
        }
        else{//默认买否
            if (shareType ==AMDShareTypeWeChatSession || shareType == AMDShareTypeweChatTimeline ) {
                [AMDUMSDKManager shareUMType:shareType shareImage:_screenshotImg];
            }else{
                [AMDShareManager shareType:shareType photoURL:imageurl];
            }
        }
    }
}

#pragma mark - 展示或者隐藏
-(void)show{

    __weak typeof(self) weakself = self;
    weakself.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.25 animations:^{
        weakself.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        _backView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _backView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _backView.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }];
}

//隐藏弹出层
-(void)hide
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        _backView.transform = CGAffineTransformMakeScale(0.10f, 0.10f);
        weakself.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        _backView.transform = CGAffineTransformIdentity;
        [weakself removeFromSuperview];
    }];
}

#pragma mark - 截图
-(UIImage*)ScreenShot{
    _cancelBt.hidden = YES;
    _backView.amd_height = _backView.amd_height-60;
    _shareBackView.hidden = YES;
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(_backView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_backView.layer renderInContext:context];
    UIImage *sendImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _backView.amd_height = _backView.amd_height+60;
    _shareBackView.hidden = NO;
    _cancelBt.hidden = NO;
    return sendImage;
}

-(void)savaToTheLocalWithImage:(UIImage*)image{
//    [AMDUIFactory makeToken:nil message:@"图片保存成功"];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存图片到照片库
    
    [MShareTool savePhotoAlbumWithImage:image completion:^(BOOL success, NSError *error) {
            if (success) {
                [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:@"保存图片成功"];
            }else{
                [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:error.localizedDescription];
            }
    }];
    
}

@end
