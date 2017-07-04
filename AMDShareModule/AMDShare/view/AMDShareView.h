//
//  AMDShareView.h
//  AppMicroDistribution
//  分享视图
//  Created by Fuerte on 16/7/22.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <SSBaseKit/SSBaseKit.h>
#import "AMDShareConfig.h"

typedef NS_ENUM(NSUInteger, AMDShareViewFrom) {
    AMDShareViewFromTeam = 1,           //团队(有量)
    AMDShareViewFromTopic,          //话题(买否,有量)
    AMDShareViewFromSupply,         //供应商(有量)
    AMDShareViewFromTempGoods,      //临时商品(买否)
    AMDShareViewFromShop,           //  店铺首页
    AMDShareViewFromPlatform,       //有量平台
    AMDShareViewFromShopGoods,   //店铺商品 （买否）
    AMDShareViewFromPTGoods,        //拼团商品(买否)
};

@interface AMDShareView : AMDBaseView

/**
 * 1是有量 2是买否 (默认买否)
 */
@property(nonatomic, assign)  NSInteger shareSource;       //分享来源
@property(nonatomic, assign) AMDShareViewFrom shareFrom;     //从哪个页面来

@property(nonatomic, copy) NSString *shareTitle;            //分享的标题
@property(nonatomic, copy) NSString *shareInfoURL;          //分享的详情url
@property(nonatomic, copy) NSString *shareImageURL;         //分享的图片url
@property(nonatomic, copy) NSString *shareContent;          //分享内容

@property(nonatomic, copy) NSString *shareShortUrl;  //短链  用于拼接

#pragma mark - 商品分享使用
//只在商品二维码中需要传
@property(nonatomic, copy) NSString *goodsTitle;   //商品名称
@property(nonatomic, copy) NSString *productID;               //九图分享用的商品id
@property(nonatomic, strong) NSArray *shareImagesURLs;        //图文分享时候要用到 注意：只能是image对象 在赋值的时候我这里会自动转换成image对象

/**
 *  点击相应的分享事件(用于转发关系)
 */
@property(nonatomic, copy) void  (^handleShareAction)(AMDShareType shareType);


// 显示
- (void)show;
// 隐藏
- (void)hide;


@end









