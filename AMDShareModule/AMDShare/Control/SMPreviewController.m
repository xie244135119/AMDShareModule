//
//  SMPreviewController.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/8/14.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SMPreviewController.h"
#import "SMPreviewViewModel.h"

@interface SMPreviewController ()
{

}

// UIImage 或者 NSUrl
@property(nonatomic, strong)NSArray *currentImages;

@property(nonatomic, strong)SMPreviewViewModel *viewModel;

@property(nonatomic) NSInteger currentIndex;
// 选中的图片
@property(nonatomic, strong) NSArray<NSNumber *> *selectImageIndexs;
//
@property(nonatomic ,copy) void(^callBack)(NSArray<NSNumber *>* selectImages);

@end

@implementation SMPreviewController

- (void)dealloc
{
    self.currentImages = nil;
    self.viewModel = nil;
    self.callBack = nil;
    self.selectImageIndexs = nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewModel];
}


- (id)init
{
    return [super initWithTitle:nil titileViewShow:NO tabBarShow:NO];
}


-(void)initViewModel{
    SMPreviewViewModel *viewModel = [[SMPreviewViewModel alloc]init];
    _viewModel = viewModel;
    
    viewModel.showImages = _currentImages;
    viewModel.senderController = self;
    [viewModel prepareView];
//    [viewModel invoImageCurrentIndex:_currentIndex];
    [viewModel configSelectImageIndexs:_selectImageIndexs showIndex:_currentIndex];
}


//初始化
+ (instancetype)showImage:(NSArray<UIImage *> *)images
                 imageUrl:(NSArray<NSURL*>*)imageurls
             selectImages:(NSArray<NSNumber *> *)selectImages
                showIndex:(NSUInteger)showIndex
               completion:(void(^)(NSArray<NSNumber *>* selectImages))completion
{
    SMPreviewController *VC = nil;
    if (VC == nil) {
        VC = [[SMPreviewController alloc]init];
        VC.callBack = completion;
        NSMutableArray *imagearry = [[NSMutableArray alloc]init];
        // 图片加载顺序 本地图片 -> 网络图片
        if (images.count > 0) {
            [imagearry addObjectsFromArray:images];
        }
        if (imageurls.count > 0) {
            [imagearry addObjectsFromArray:imageurls];
        }
        VC.currentImages = imagearry;
        VC.selectImageIndexs = selectImages;
    }
//    if (VC.viewModel) {
//        [VC.viewModel ];
//    }
    VC.currentIndex = showIndex;
    return VC;
}

- (void)viewController:(id)viewController object:(id)sender{
    if ([_delegate respondsToSelector:@selector(viewController:object:)]) {
        [_delegate viewController:sender object:sender];
    }
}
@end
