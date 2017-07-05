//
//  MShareManager.h
//  AMDShareModule
//  数据源管理类
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MShareAnimationDelegate.h"


@interface MShareManager : NSObject

+ (instancetype)shareInstance;

@property(nonatomic, weak) id<MShareAnimationDelegate>animationDelegate;




@end
