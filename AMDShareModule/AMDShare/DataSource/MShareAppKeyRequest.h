//
//  MShareAppKeyRequest.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MShareAppKeyRequest <NSObject>

-(NSString *)appkey;
//新浪
-(NSString *)sinaAppKey;

-(NSString *)sinaAppSecret;

-(NSString *)sinaRedirectUri;

//微信
-(NSString *)wechatAppKey;

-(NSString *)wechatAppSecret;

//QQ && Qzone
-(NSString *)qqAppKey;

-(NSString *)qqAppSecret;
@end
