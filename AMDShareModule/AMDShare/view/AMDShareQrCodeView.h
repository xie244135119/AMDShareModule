//
//  AMDShareViewModel.h
//  AppMicroDistribution
//  分享弹层
//  Created by 马清霞 on 16/7/22.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDShareQrCodeView.h"
#import <UIKit/UIKit.h>
#import <SSBaseKit/SSBaseKit.h>

@interface AMDShareQrCodeView : UIView

/**
 * 1是有量 2是买否 (默认买否)
 */
@property(nonatomic, assign)  NSInteger shareSource;       //分享来源

@property(nonatomic, copy) NSString *shareTitle;            //分享的标题
@property(nonatomic, copy) NSString *shareInfoURL;      //分享的详情url 用于生成二维码
@property(nonatomic, copy) NSString *shareContent;      //分享内容
@property(nonatomic, copy) NSString *shareImageURL;     //分享的图片url
@property(nonatomic, copy) NSString *goodsTitle;   //商品名称



-(void)show;



@end
