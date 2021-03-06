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
// 分享的图片URL数组
@property(nonatomic, strong)NSArray<NSURL*>*shareImageUrlArray;
// 分享的图片数组
@property(nonatomic, strong)NSArray<UIImage*>*shareImageArray;
// 分享内容
@property(nonatomic, strong)NSString *shareContent;
// 分享链接
@property(nonatomic, strong)NSURL *shareUrl;




/**
 选中某张图片

 @param index 某个索引
 */
-(void)selectImageWithIndex:(NSInteger)index;

/**
 分享结果
 */
@property(nonatomic, copy) void  (^completionHandle)(AMDShareType shareType,AMDShareResponseState responseState,NSError* error);

/**
页面跳转
 */
@property(nonatomic, copy) void  (^selectAction)(NSInteger index);



/**
 选中的图片索引位置

 @return 所有选中的图片索引
 */
- (NSArray<NSNumber *> *)selectImageIndexs;


@end
