//
//  SMPreviewViewModel.h
//  AMDShareModule
//
//  Created by 马清霞 on 2017/8/14.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <SSBaseLib/SSBaseLib.h>

@interface SMPreviewViewModel : AMDBaseViewModel

//返回图片是否被选中
@property(nonatomic ,copy) void(^callBack)(BOOL select);

// 需要展示的图片<NSURL 或者 UIImage>
@property(nonatomic, strong) NSArray *showImages;

-(void)invoImageCurrentIndex:(NSInteger)index;

@end
