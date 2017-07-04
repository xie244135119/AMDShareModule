//
//  AMDTextField.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-10-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDTextField : UITextField

// 是否支持粘贴功能  默认YES
@property(nonatomic) BOOL supportPaste;

// 是否支持剪切功能 默认YES
@property(nonatomic) BOOL supportCut;


@end
