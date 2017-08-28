//
//  SMConstVar.h
//  AMDShareModule
//
//  Created by SunSet on 2017/8/28.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>

// bundle 名
extern NSString *const SMShareBundleName;

// 图片加载
#define SMGetFilePath(a) [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:a]
#define SMimageFromName(a) [[UIImage alloc]initWithContentsOfFile:SMGetFilePath(a)]
#define SMShareSrcImage(file) SMimageFromName([SMShareBundleName stringByAppendingPathComponent:file])

