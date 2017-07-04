//
//  MShareManager.h
//  AMDShareModule
//  数据源管理类
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MShareAppKeyRequest.h"
#import "MShareAlertDelegate.h"
#import "MShareAnimationDelegate.h"
#import "MShareRequestDelegate.h"

@interface MShareManager : NSObject

+ (instancetype)shareInstance;


@property(nonatomic, weak) id<MShareAppKeyRequest>appKeyDelegate;

@property(nonatomic, weak) id<MShareAlertDelegate>alertDelegate;

@property(nonatomic, weak) id<MShareAnimationDelegate>animationDelegate;

@property(nonatomic, weak) id<MShareRequestDelegate>requestDelegare;

@end
