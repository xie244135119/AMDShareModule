//
//  GreatShareViewModel.m
//  GreatShareViewTest
//
//  Created by 马清霞 on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SMGreatShareViewModel.h"
#import <SSBaseKit/SSBaseKit.h>
#import <Masonry/Masonry.h>
#import "SSAppPluginShare.h"
#import "MShareStaticMethod.h"

@interface SMGreatShareViewModel()
{
    AMDRootViewController *_senderController;
    NSMutableArray *_currentSelectedImages;         //选中的需要分享的图片
    UILabel *_imageCountLB;                                         //选中的图片数量
    UITextView *_shareContentTV;                 //分享语编辑
    SSAppPluginShare *_pluginShare;                             //分享插件类
    
}
@end


@implementation SMGreatShareViewModel

-(void)dealloc{
    _senderController = nil;
    _pluginShare = nil;
    _currentSelectedImages = nil;
    _imageCountLB = nil;
    _shareContentTV = nil;
}


-(void)prepareView{
    _senderController = (AMDRootViewController*)self.senderController;
    [self initContentView];
}


//搭建视图
-(void)initContentView{
    _currentSelectedImages = [[NSMutableArray alloc]init];
    //背景滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.layer.borderWidth = 1;
    scrollView.layer.borderColor = [UIColor redColor].CGColor;
    [_senderController.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-140);
    }];
    
    NSInteger offset = 0;
    if (SScreenHeight < 667) {
        offset = 100;
    }
    //承载视图
    UIView *contentBackView = [[UIView alloc]init];
    contentBackView.layer.borderWidth = 1;
    [scrollView addSubview:contentBackView];
    [contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView.mas_width);
        make.height.equalTo(scrollView.mas_height).offset(offset);
    }];
    
    //顶部提示视图
    UIControl *promptingContr = [[UIControl alloc]init];
    //    promptingContr.layer.borderWidth = 1;
    promptingContr.backgroundColor = [UIColor greenColor];
    [contentBackView addSubview:promptingContr];
    [promptingContr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(0);
    }];
    
    //提示标题
    AMDImgViewLabelView *prompTitleView = [[AMDImgViewLabelView alloc]init];
    //    prompTitleView.headImgView.layer.borderWidth = 1;
    //    prompTitleView.textLabel.layer.borderWidth = 1;
    [promptingContr addSubview:prompTitleView];
    [prompTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.offset(0);
        make.right.offset(-80);
    }];
    [prompTitleView.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(10);
        make.width.height.offset(20);
    }];
    [prompTitleView.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prompTitleView.headImgView.mas_right).offset(3);
        make.top.bottom.right.offset(0);
    }];
    
    //提示内容
    AMDLabelShowView *prompContentView = [[AMDLabelShowView alloc]init];
    //    prompContentView.titleLabel.text = @"规则";
    prompContentView.titleLabel.textAlignment = NSTextAlignmentRight;
    prompContentView.titleLabel.font = FontWithName(@"", 12);
    prompContentView.rightArrowShow = YES;
    [promptingContr addSubview:prompContentView];
    [prompContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prompTitleView.mas_right);
        make.top.right.bottom.offset(0);
    }];
    [prompContentView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.right.offset(-30);
    }];
    
    //选择图片标题 数量
    AMDLabelShowView *selectLb = [[AMDLabelShowView alloc]init];
    selectLb.titleLabel.text = @"选择图片";
    selectLb.contentLabel.text = @"已选0张";
    _imageCountLB = selectLb.contentLabel;
    selectLb.layer.borderWidth = 1;
    [contentBackView addSubview:selectLb];
    [selectLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(promptingContr.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    
    //图片滑动视图
    UIScrollView *imageScroll = [[UIScrollView alloc]init];
    imageScroll.layer.borderWidth = 1;
    [contentBackView addSubview:imageScroll];
    [imageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(selectLb.mas_bottom).offset(10);
        make.height.offset(100);
    }];
    
    //图片承载视图
    UIView *imageBack = [[UIView alloc]init];
    imageBack.layer.borderWidth = 3;
    imageBack.layer.borderColor = [UIColor redColor].CGColor;
    [imageScroll addSubview:imageBack];
    [imageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageScroll).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(@(self.shareImageArray.count*110+20));
        make.height.equalTo(imageScroll.mas_height);
    }];
    
    //需要分享的图片数组
    NSMutableArray *shareImageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.shareImageArray.count; i++)
    {
        AMDButton *shareImageView = [[AMDButton alloc]init];
        shareImageView.tag = i;
        shareImageView.backgroundColor = [UIColor yellowColor];
        shareImageView.layer.borderWidth = 1;
        shareImageView.imageView.layer.borderWidth = 1;
        [shareImageView addTarget:self action:@selector(selectShareImage:) forControlEvents:UIControlEventTouchUpInside];
        [shareImageView setImage:SMShareSrcImage(@"") forState:UIControlStateNormal];
        [shareImageView setImage:SMShareSrcImage(@"M_weibo_68@2x.png") forState:UIControlStateSelected];
        [imageBack addSubview:shareImageView];
        [shareImageArray addObject:shareImageView];
        [shareImageView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(3);
            make.right.offset(-3);
            make.width.height.offset(24);
        }];
        
        AMDImageView *selectIcon = [[AMDImageView alloc]init];
        [selectIcon setImageWithUrl:self.shareImageArray[i] placeHolder:nil];
        selectIcon.layer.borderWidth = 1;
        [shareImageView addSubview:selectIcon];
        [selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(shareImageView).width.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@100);
            make.top.equalTo(@0);
            make.left.equalTo(@(110*i+15));
        }];
    }
    
    //编辑文案
    UILabel *editTitleLB = [[UILabel alloc]init];
    editTitleLB.text = @"编辑分享文案";
    [contentBackView addSubview:editTitleLB];
    [editTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(imageScroll.mas_bottom).offset(15);
        make.height.offset(30);
    }];
    
    UIView *tvBackView = [[UIView alloc]init];
    tvBackView.layer.borderWidth = .5;
    tvBackView.layer.borderColor = [UIColor grayColor].CGColor;
    [contentBackView addSubview:tvBackView];
    [tvBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(editTitleLB.mas_bottom).offset(5);
        make.height.offset(100);
    }];
    
    //文案输入框
    UITextView *editTV = [[UITextView alloc]init];
    _shareContentTV = editTV;
    editTV.text = self.shareContent;
    editTV.layer.borderWidth = .5;
    editTV.layer.borderColor = [UIColor grayColor].CGColor;
    [contentBackView addSubview:editTV];
    [editTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tvBackView).width.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    //编辑图示语
    UILabel *promptWordsLB = [[UILabel alloc]init];
    //    promptWordsLB.layer.borderWidth = 1;
    [contentBackView addSubview:promptWordsLB];
    [promptWordsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(tvBackView.mas_bottom).offset(5);
        make.height.offset(15);
        make.width.offset(150);
    }];
    
    //复制按钮
    AMDButton *copyBT = [[AMDButton alloc]init];
    copyBT.titleLabel.text = @"复制文案";
    copyBT.titleLabel.textAlignment = NSTextAlignmentRight;
    copyBT.titleLabel.textColor = [UIColor orangeColor];
    copyBT.layer.borderWidth = 1;
    [contentBackView addSubview:copyBT];
    [copyBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(promptWordsLB);
        make.width.offset(130);
        make.height.offset(15);
    }];
    
    //文字描述
    UILabel *textDescriptionLB = [[UILabel alloc]init];
    textDescriptionLB.numberOfLines = 3;
    //    textDescriptionLB.layer.borderWidth = 1;
    [contentBackView addSubview:textDescriptionLB];
    [textDescriptionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(promptWordsLB.mas_bottom).offset(10);
        make.height.offset(60);
    }];
    [self initShareView];
}


-(void)initShareView{
    //分享背景视图
    UIView *shareBackView = [[UIView alloc]init];
    [_senderController.contentView addSubview:shareBackView];
    [shareBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(140);
    }];
    
    AMDLineView *line = [[AMDLineView alloc]init];
    line.lineColor = [UIColor grayColor];
    [shareBackView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(7);
        make.height.offset(.5);
    }];
    
    UILabel *headingLB = [[UILabel alloc]init];
    headingLB.textAlignment = NSTextAlignmentCenter;
    headingLB.backgroundColor = [UIColor whiteColor];
    headingLB.text = @"图文分享到";
    [shareBackView addSubview:headingLB];
    [headingLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareBackView.mas_centerX);
        make.top.offset(0);
        make.width.offset(100);
        make.height.offset(14);
    }];
    
    //默认微信 ，拷贝三个渠道
    NSArray *titles = @[@"微信好友",@"朋友圈",@"QQ",@"微博"];
    NSArray *images = @[@"share_weixin@2x.png",@"share_weixin-friend@2x.png",@"share_qq@2x.png",@"share_weibo@2x.png"];
    
    for (NSInteger i = 0; i<titles.count; i++) {
        
        UIView *v = [[UIView alloc]init];
        [shareBackView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@80);
            make.top.equalTo(@40);
            
            make.centerX.equalTo(shareBackView.mas_centerX).multipliedBy((CGFloat)(2*i+1)/4);
        }];
        
        //分享图片按钮
        AMDButton *shareBt = [[AMDButton alloc]init];
        shareBt.tag = i+1;
        shareBt.layer.cornerRadius = 25;
        shareBt.layer.masksToBounds = YES;
        [shareBt setBackgroundColor:nil forState:UIControlStateHighlighted];
        [shareBt setImage2:SMShareSrcImage(images[i]) forState:UIControlStateNormal];
        [shareBt addTarget:self action:@selector(clickShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:shareBt];
        [shareBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.left.top.equalTo(@0);
        }];
        
        UILabel *titleLB = [[UILabel alloc]init];
        titleLB.text = titles[i];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = FontWithName(@"", 12);
        titleLB.textColor = [UIColor grayColor];
        [v addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@20);
        }];
    }
}


#pragma mark - 点击事件
-(void)clickShareAction:(AMDButton*)sender{
    if (_pluginShare == nil) {
        _pluginShare = [[SSAppPluginShare alloc]init];
    }
    _pluginShare.shareImageUrls = _currentSelectedImages;
    _pluginShare.shareContent = _shareContentTV.text;
    _pluginShare.shareUrl = self.shareUrl;
    _pluginShare.senderController = _senderController;
    switch (sender.tag) {
        case 1://微信
        case 2://朋友圈
        {
            _pluginShare.pluginIder = SSPluginShareWechat;
        }
            break;
        case 3://QQ
        {
            _pluginShare.pluginIder = SSPluginShareQQ;
        }
            break;
        case 4://微博
        {
            _pluginShare.pluginIder = SSPluginShareSina;
        }
            break;
        default:
            break;
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
                [_senderController.navigationController popViewControllerAnimated: YES];
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


//选择需要分享的图片
-(void)selectShareImage:(AMDButton *)sender{
    NSLog(@"-----%ld",sender.tag);
    NSLog(@"****%@",self.shareImageArray[sender.tag]);
    NSLog(@"====%@",_currentSelectedImages);
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    if (sender.selected)
    {//取消选中状态
        sender.selected = NO;
        NSURL *imageUrl = self.shareImageArray[sender.tag];
        if ([_currentSelectedImages containsObject:imageUrl]) {
            [_currentSelectedImages removeObject:imageUrl];
        }
    }else
    {//添加选中状态
        sender.selected = YES;
        NSURL *imageUrl = self.shareImageArray[sender.tag];
        if (![_currentSelectedImages containsObject:imageUrl]) {
            [_currentSelectedImages addObject:imageUrl];
        }
    }
    NSLog(@"-----%ld",sender.tag);
    NSLog(@"****%@",self.shareImageArray[sender.tag]);
    NSLog(@"====%@",_currentSelectedImages);
    _imageCountLB.text = [NSString stringWithFormat:@"已选%ld张",_currentSelectedImages.count];
    [self invokeImageCountTitleWithLable:_imageCountLB];
}


#pragma mark - 文字处理
-(void)invokeImageCountTitleWithLable:(UILabel *)countLb{
    NSRange range = NSMakeRange(2, countLb.text.length-3);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:countLb.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [attributedString addAttribute:NSFontAttributeName value:FontWithName(@"", 13) range:range];
    NSRange headerRange = NSMakeRange(0, 2);
    NSRange footerRange =  NSMakeRange(countLb.text.length-1, 1);
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:headerRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:footerRange];
    [attributedString addAttribute:NSFontAttributeName value:FontWithName(@"", 10) range:footerRange];
    [attributedString addAttribute:NSFontAttributeName value:FontWithName(@"", 10) range:headerRange];
    countLb.attributedText = attributedString;
}




@end
