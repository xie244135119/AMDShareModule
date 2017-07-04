//
//  MShareRequestDelegate.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
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

typedef NS_ENUM(NSUInteger, AMDShareToType) {
    ShareToUMSDK = 1,           //友盟
    ShareToShareSDK,          //shareSDK

};



@protocol MShareRequestDelegate <NSObject>

@optional


/**
 初始分享视图

 @param type 传入需要初始化的类型
 */
-(void)initShareViewWithType:(void(^)(AMDShareViewFrom type))type;



/**
 分享

 @param source 分享类型，内容，标题，链接，图片链接
 */
-(void)getShareSource:(void(^)(NSString *productID, AMDShareToType type,NSString *content,NSString *title,NSString *url,NSArray*imageUrls,NSArray *images,NSString *goodsTitle,NSString * shortUrl))source;



/**
 创建转发关系

 @param platform 分享品台
 @param completion 返回结果
 */
-(void)invokeForwardRelationshipWithPlatform:(AMDShareType)platform completion:(void (^)(NSError *error))completion;


@end
