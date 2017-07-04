//
//  MShareAnimationDelegate.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MShareAnimationDelegate <NSObject>

//开始 && 结束动画
-(void)showAnimation;
-(void)stopAnimation;

@end
