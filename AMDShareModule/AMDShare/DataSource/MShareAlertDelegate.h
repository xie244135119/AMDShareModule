//
//  MShareAlertDelegate.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MShareAlertDelegate <NSObject>

@optional
/**
 toast提示
 *@param alertTitle 需要在使用项目的window上谈出提示信息
 **/
-(void)showToastWithTitle:(NSString *)alertTitle;


/**
 alert提示
 
 @param alertTitle 提示信息
 */
- (void)showAlertWithTitle:(NSString *)alertTitle;

@end
