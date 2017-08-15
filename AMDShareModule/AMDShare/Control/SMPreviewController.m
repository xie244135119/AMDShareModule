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

@property(nonatomic, strong)NSArray *currentImages;

@property(nonatomic, strong)NSArray *currentImageUrls;

@property(nonatomic, strong)SMPreviewViewModel *viewModel;

@property(nonatomic)NSInteger currentIndex;


@property(nonatomic ,strong) void(^callBack)(NSArray<NSNumber *>* selectImages);

@end

@implementation SMPreviewController


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
    viewModel.showImages = _currentImages.count>0?_currentImages:_currentImageUrls;
    viewModel.senderController = self;
    [viewModel prepareView];
    [viewModel invoImageCurrentIndex:_currentIndex];
}


//初始化
+ (instancetype)showImage:(NSArray<UIImage *> *)images
                 imageUrl:(NSArray<NSURL*>*)imageurls
                showIndex:(NSUInteger)showIndex
               completion:(void(^)(NSArray<NSNumber *>* selectImages))completion{
    static SMPreviewController *VC = nil;
    if (VC == nil) {
        VC = [[SMPreviewController alloc]init];
        VC.callBack = completion;
        VC.currentImages = images;
        VC.currentImageUrls = imageurls;
    }
    if (VC.viewModel) {
        [VC.viewModel invoImageCurrentIndex:showIndex];
    }
    VC.currentIndex = showIndex;
    return VC;
}

- (void)viewController:(id)viewController object:(id)sender{
    if ([_delegate respondsToSelector:@selector(viewController:object:)]) {
        [_delegate viewController:sender object:sender];
    }
}
@end
