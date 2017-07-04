
//
//  MShareStaticMethod.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#ifndef MShareStaticMethod_h
#define MShareStaticMethod_h


#define GetFilePath(a) [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:a]

//按钮圆角大小
#define AMDCornerRadius 3

//屏幕宽度
#define APPWidth [UIScreen mainScreen].bounds.size.width
#define APPHeight [UIScreen mainScreen].bounds.size.height

//字体
#define FontWithName(n,s) [UIFont fontWithName:@"HiraginoSansGB-W3" size:s]


//描边宽度
#define AMDBorderWidth  0.5
//线条高度和宽度
#define AMDLineHeight   0.5
#define AMDLineWidth    0.5

//字体颜色来源于RGB
#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]
// 默认文字颜色 0x333333
#define DEFAULT_TEXT_COLOR ColorWithRGB(51,51,51, 1)
// 默认灰色文字颜色 0x777777
#define DEFAULT_TEXT_GRAY_COLOR ColorWithRGB(119,119,119, 1)
//线条颜色
#define AMDLineColor ColorWithRGB(230, 230, 230, 1)
// 灰色文字颜色 0x999999
#define summary_text_color ColorWithRGB(153,153,153, 1)
// 默认背景色
#define DEFAULT_BACKGROUND_COLOR ColorWithRGB(246, 246, 246, 1)



//加载过程中的图片
#define AMDLoadingImage [[UIImage imageNamed:@"GoodsModule.bundle/xnormal_img"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 7, 7)]                 //商品默认头像


#define imageFromBundleName(b,n) [[UIImage alloc]initWithContentsOfFile:GetFilePathFromBundle(b, n)]
#define GetFilePathFromBundle(b,n) [[[NSBundle bundleWithPath:GetFilePath(b)] resourcePath]stringByAppendingPathComponent:n]
#define GetFilePath(a) [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:a]


//单例模式解析
#pragma mark - 单例模式定义

#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define NonNil(a,r)  a?a:r

#endif /* MShareStaticMethod_h */
