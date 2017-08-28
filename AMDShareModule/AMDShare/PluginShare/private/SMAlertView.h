//
//  SMAlertView.h
//  AMDShareModule
//  提示弹出框
//  Created by 马清霞 on 2017/8/11.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAlertView : UIView

//提示内容
@property (nonatomic ,copy)NSString *alertContent;

//展示提示视图
-(void)show;

@end
