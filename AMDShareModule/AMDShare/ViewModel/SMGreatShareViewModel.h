//
//  GreatShareViewModel.h
//  GreatShareViewTest
//
//  Created by 马清霞 on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>
#import "AMDShareConfig.h"

@interface SMGreatShareViewModel : AMDBaseViewModel

@property(nonatomic, strong)NSArray<NSURL*>*shareImageArray;//分享的图片数组

@property(nonatomic, strong)NSString *shareContent;//分享内容

@property(nonatomic, strong)NSURL *shareUrl;//分享链接

/**
 分享结果
 */
@property(nonatomic, copy) void  (^completionHandle)(AMDShareType shareType,AMDShareResponseState responseState,NSError* error);


@end
