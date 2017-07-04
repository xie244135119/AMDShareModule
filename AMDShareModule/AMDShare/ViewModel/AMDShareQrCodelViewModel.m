//
//  AMDShareQrCodelViewModel.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/4.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "AMDShareQrCodelViewModel.h"
#import "MShareTool.h"
#import "AMDUMSDKManager.h"
#import "AMDShareManager.h"
#import "MShareStaticMethod.h"
#import "MShareManager.h"
#import <SSBaseKit/SSBaseKit.h>
#import <Masonry/Masonry.h>

@interface AMDShareQrCodelViewModel()
{
    __weak AMDRootViewController *_senderController;
    __weak AMDImageView *_goodsImageView;
    __weak UIImageView *_qrCodelImageView;
    __weak UILabel *_shareContentLB;
    __weak UIView *_currentBackView;
    __weak UIView *_centerBack;
    AMDButton *_cancelBT;
    __weak UIView *_shareBtBack;
}

@property(nonatomic, assign)  AMDShareToType shareSource;       //分享来源
@property(nonatomic, copy) NSString *shareTitle;            //分享的标题
@property(nonatomic, copy) NSString *shareInfoURL;      //分享的详情url 用于生成二维码
@property(nonatomic, copy) NSString *shareContent;      //分享内容
@property(nonatomic, copy) NSString *shareImageURL;     //分享的图片url
@property(nonatomic, copy) NSString *goodsTitle;   //商品名称

@end

@implementation AMDShareQrCodelViewModel


-(void)prepareView{
    _senderController = (AMDRootViewController *)self.senderController;
    
    [self initContentView];
    [self getShareSource];
}


//搭建视图
-(void)initContentView{
#define XQAnimationSrcName(file) [@"ShareImageTwo.bundle" stringByAppendingPathComponent:file]
    
    
    //截取上个界面的画面做背景
    UIImageView *imageBack = [[UIImageView alloc]init];
    imageBack.image = _backImage;
    [_senderController.contentView addSubview:imageBack] ;
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    //半透明背景视图
    UIView *myBackView = [[UIView alloc]init];
    _currentBackView = myBackView;
    [imageBack addSubview:myBackView];
    [myBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15, 130/2, APPWidth-30, APPHeight-64-70)];
    _centerBack = backView;
    if ([MShareTool deviceModel] == AASDeviceModelType_iPhone6) {
        backView.frame =   CGRectMake(15, 180/2, APPWidth-30, APPHeight-64-115);
    }
    if ([MShareTool deviceModel] == AASDeviceModelType_iPhone6Plus) {
        backView.frame =   CGRectMake(15, 210/2, APPWidth-30, APPHeight-64-145);
    }
    
    backView.layer.cornerRadius = 6;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [_senderController.contentView addSubview:backView];
    
    AMDImageView *imgView = [[AMDImageView alloc]initWithFrame:CGRectMake(25, 25, backView.frame.size.width-50, backView.frame.size.width-50)];
    _goodsImageView = imgView;
    [backView addSubview:imgView];
    
    UILabel *descLB = [[UILabel alloc]initWithFrame:CGRectMake(25, imgView.frame.size.height+imgView.frame.origin.y+5, backView.frame.size.width-50, 70/2)];
    descLB.numberOfLines = 0;
    descLB.font = FontWithName(@"", 12);
    descLB.textColor = DEFAULT_TEXT_COLOR;
    _shareContentLB = descLB;
    [backView addSubview:descLB];
    
    UIImageView *codeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, descLB.frame.origin.y+descLB.frame.size.height+5, 106/2, 106/2)];
    _qrCodelImageView = codeImgView;
    [backView addSubview:codeImgView];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(168/2, descLB.frame.origin.y+descLB.frame.size.height+5, 200,  106/2)];
    lb.text = @"长按或扫描二维码可查看详情";
    lb.textColor = summary_text_color;
    lb.font = FontWithName(@"", 12);
    [backView addSubview:lb];
    
    UIView *shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height-60, backView.frame.size.width, 60)];
    _shareBtBack = shareBackView;
    //    _shareBackView = shareBackView;
    shareBackView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [backView addSubview:shareBackView];
    
    NSArray *imgArr = @[@"M_weixin_68@2x.png",@"M_weixin-friend_68@2x.png",@"M_q-zone_68@2x.png",@"M_weibo_68@2x.png",@"M_download_68@2x.png"];
    
    for (NSInteger i = 0; i < 5; i++) {
        AMDButton *shareBt = [[AMDButton alloc]initWithFrame:CGRectMake(i* backView.frame.size.width/5, 0, backView.frame.size.width/5, 60)];
        shareBt.tag = i+1;
        [shareBt addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [shareBackView addSubview:shareBt];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(((backView.frame.size.width - 5*34)/6)+i* (34+((backView.frame.size.width - 5*34)/6)), 30-(34/2), 34, 34)];
        UIImage *image = AMDShareSrcImage(imgArr[i]);
        [shareBt setImage2:image forState:UIControlStateNormal];
        
        [shareBackView addSubview:img];
    }
    
    AMDButton *bt = [[AMDButton alloc]initWithFrame:CGRectMake(backView.frame.size.width-35, 6, 42, 42)];
    //    _cancelBt = bt;
    _cancelBT = bt;
    bt.imageView.bounds = bt.bounds;
    bt.tag = 6;
    [bt addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    bt.imageView.image = AMDShareSrcImage(@"adver_pop_close.png");
    [backView addSubview:bt];
}


#pragma mark - 点击事件
-(void)Click:(AMDButton *)sender{
    UIImage * screenshotImg =  [self ScreenShot];
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
            imageurl  =  [MShareTool writeImageToFile:screenshotImg];
        }
            break;
        case 4://微博
        {
            shareType = AMDShareTypeSina;
            imageurl  =  [MShareTool writeImageToFile:screenshotImg];
        }
            break;
        case 5://保存到本地
            [self savaToTheLocalWithImage:screenshotImg];
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
                
        switch (self.shareSource) {
            case ShareToShareSDK:
            {
                [AMDShareManager shareType:shareType photoURL:imageurl];
            }
                break;
            default:
            {
                if (shareType ==AMDShareTypeWeChatSession || shareType == AMDShareTypeweChatTimeline ) {
                    [AMDUMSDKManager shareUMType:shareType shareImage:screenshotImg];
                }else{
                    [AMDShareManager shareType:shareType photoURL:imageurl];
                }
            }
                break;
        }
    }
}


#pragma mark - set赋值
-(void)setShareInfoURL:(NSString *)shareInfoURL{
    if (shareInfoURL) {
        _qrCodelImageView.image = [MShareTool imageQrcodeViewWithStr:shareInfoURL];
    }
    _shareInfoURL = shareInfoURL?shareInfoURL:@"";
}

-(void)setShareImageURL:(NSString *)shareImageURL{
    if (shareImageURL) {
        NSString *imgStr = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/%.0f/h/%.0f", shareImageURL,_goodsImageView.frame.size.width*2,_goodsImageView.frame.size.height*2]];
        [_goodsImageView setImageWithUrl:[NSURL URLWithString:imgStr] placeHolder:AMDLoadingImage];
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



#pragma mark - 展示或者隐藏
-(void)show{
    
    [UIView animateWithDuration:.25 animations:^{
        _currentBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        _centerBack.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _centerBack.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _centerBack.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }];
}

//隐藏弹出层
-(void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        _centerBack.transform = CGAffineTransformMakeScale(0.10f, 0.10f);
        _currentBackView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        _centerBack.transform = CGAffineTransformIdentity;
        [_senderController dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - 截图
-(UIImage*)ScreenShot{
    _cancelBT.hidden = YES;
    _centerBack.amd_height = _centerBack.amd_height-60;
    _shareBtBack.hidden = YES;
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(_centerBack.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_centerBack.layer renderInContext:context];
    UIImage *sendImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _centerBack.amd_height = _centerBack.amd_height+60;
    _shareBtBack.hidden = NO;
    _cancelBT.hidden = NO;
    return sendImage;
}


-(void)savaToTheLocalWithImage:(UIImage*)image{
    [MShareTool savePhotoAlbumWithImage:image completion:^(BOOL success, NSError *error) {
        if (success) {
            [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:@"保存图片成功"];
        }else{
            [[[MShareManager shareInstance] alertDelegate] showToastWithTitle:error.localizedDescription];
        }
    }];
    
}


#pragma mark - 获取分享内容
-(void)getShareSource{
    [[[MShareManager shareInstance] requestDelegare ] getShareSource:^(NSString *productID, AMDShareToType type, NSString *content, NSString *title, NSString *url, NSArray *imageUrls, NSArray *images, NSString *goodsTitle, NSString *shortUrl) {
        self.shareSource = type;
        self.shareTitle = title;
        self.shareInfoURL = url;
        self.shareContent = content;
        self.shareImageURL = imageUrls[0];
        self.goodsTitle = goodsTitle;
    }];
}


@end
