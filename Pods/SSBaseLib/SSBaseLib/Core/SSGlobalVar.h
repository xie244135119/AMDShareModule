//
//  SSGlobalVar.h
//  SSBaseLib
//
//  Created by SunSet on 2017/7/20.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#ifndef SSGlobalVar_h
#define SSGlobalVar_h

// 字体颜色来源于RGB
#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]

// 字体样式
#define FontWithName(n,s) [UIFont fontWithName:n.length>0?n:@"HiraginoSansGB-W3" size:s]
#define FontBoldWithName(n,s) [UIFont fontWithName:@"HiraginoSansGB-W3" size:s]


// - NSUserDefaults
//获取NSUserDefaults中的值
#define GetDefaults(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
//设置NSUserDefaults中的键值对
#define SetDefaults(key,value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define SetDefaultsSynchronize() [[NSUserDefaults standardUserDefaults] synchronize]
#define RemoveDefaults(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]


//屏幕宽高
#define SScreenWidth [UIScreen mainScreen].bounds.size.width
#define SScreenHeight [UIScreen mainScreen].bounds.size.height



// 调试相关
#if DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


// GCD相关
#define SSGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define SSMainQueue dispatch_get_main_queue()



#endif /* SSGlobalVar_h */










