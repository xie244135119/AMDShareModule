//
//  SMAlertView.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/8/11.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SMAlertView.h"
#import <Masonry/Masonry.h>
#import <SSBaseLib/SSBaseLib.h>
#import <SSBaseKit/SSBaseKit.h>
#import "MShareStaticMethod.h"
#import "AMDShareManager.h"
@interface SMAlertView()<UITextViewDelegate>
{
    UITextView *_contentTextView;
    UIView *_alertBack;
}
@end

@implementation SMAlertView


-(void)dealloc{
    _contentTextView = nil;
    _alertBack = nil;
}


-(instancetype)init{
    if (self = [super init]) {
        [self initContentView];
    }
    return self;
}


//
-(void)initContentView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    //
    UIView *alertBack = [[UIView alloc]init];
    _alertBack = alertBack;
    alertBack.layer.cornerRadius = 10;
    alertBack.backgroundColor = [UIColor whiteColor];
    [self addSubview:alertBack];
    [alertBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(300);
        make.height.offset(200);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //标题
    UILabel *titleLB = [[UILabel alloc]init];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.text = @"分享文案已复制";
    titleLB.textColor = ColorWithRGB(70, 70, 70, 1);
    titleLB.font = FontWithName(@"", 16);
    [alertBack addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(150);
        make.height.offset(30);
        make.centerX.equalTo(alertBack.mas_centerX);
        make.top.offset(15);
    }];
    
    //关闭按钮
    AMDButton *cancelBt = [[AMDButton alloc]init];
    cancelBt.imageView.image = SMShareSrcImage(@"close-dialog@2x.png");
    cancelBt.tag = 1;
    [cancelBt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    cancelBt.layer.borderWidth = 1;
    [alertBack addSubview:cancelBt];
    [cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.right.offset(-5);
        make.width.height.offset(35);
    }];
    [cancelBt.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    UIView *tvBack = [[UIView alloc]init];
    tvBack.backgroundColor = ColorWithRGB(243, 243, 243, 1);
    [alertBack addSubview:tvBack];
    [tvBack  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.equalTo(titleLB.mas_bottom).offset(10);
        make.bottom.offset(-60);
    }];
    
    //内容展示框
    UITextView *contentTextView = [[UITextView alloc]init];
    contentTextView.font = FontWithName(@"", 14);
    contentTextView.textColor = ColorWithRGB(70, 70, 70, 1);
    contentTextView.backgroundColor = ColorWithRGB(243, 243, 243, 1);
    contentTextView.delegate = self;
    _contentTextView = contentTextView;
//    contentTextView.layer.borderWidth = 1;
    [tvBack addSubview:contentTextView];
    [contentTextView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.bottom.offset(0);
    }];
    
    //跳转微信按钮
    AMDButton *confirmBT = [[AMDButton alloc]init];
    confirmBT.tag = 2;
//    confirmBT.layer.borderWidth = 1;
    [confirmBT addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    confirmBT.titleLabel.text = @"去微信粘贴";
    confirmBT.titleLabel.textColor = ColorWithRGB(68, 129, 235, 1);
    confirmBT.titleLabel.font = FontWithName(@"", 16);
    [alertBack addSubview:confirmBT];
    [confirmBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(50);
    }];
    
    AMDLineView *line = [[AMDLineView alloc]init];
    line.lineColor = SMLineColor;
    [confirmBT addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(SMLineHeight);
    }];
}


#pragma mark - 点击事件
- (void)click:(AMDButton *)sender{
    switch (sender.tag) {
        case 1://取消
        {
            [self hide];
        }
            break;
            case 2://跳转到微信
        {
            NSURL * url = [NSURL URLWithString:@"weixin://"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                NSLog(@"canOpenURL");
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - 展示或者隐藏
-(void)show
{
    // 分享文案视图加个 放大 动画
    CABasicAnimation *transform = [CABasicAnimation animation];
    transform.keyPath = @"transform.scale";
    transform.fromValue = @0.6;
    transform.toValue = @1;
    transform.repeatCount = 1;
    transform.duration = 0.05;
    transform.removedOnCompletion = YES;
    [_alertBack.layer addAnimation:transform forKey:@"transormanimation"];
    _alertBack.alpha = 1;
    _contentTextView.text = _alertContent;
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    }];
}


-(void)hide
{
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _alertBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}



@end






