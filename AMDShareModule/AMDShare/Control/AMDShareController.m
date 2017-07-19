//
//  AMDShareController.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "AMDShareController.h"
#import "AMDShareViewModel.h"
#import "MShareStaticMethod.h"
#import "AMDShareMaterialViewModel.h"


@interface AMDShareController ()
{
    
    AMDShareViewModel *_shareViewModel ;
    AMDShareMaterialViewModel *_materialViewModel;
    AMDShareController *_shareVC;
}
@property(nonatomic,copy)NSString *serviceType;
@property(nonatomic, copy) UIImage *currentImage;

@end

@implementation AMDShareController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_serviceType isEqualToString:@"com.share.default"]) {
        //主分享
        [self initShareViewModel];
    }else if ([_serviceType isEqualToString:@"com.share.material"]){
        //素材
        [self initMaterialViewModel];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_shareViewModel) {
        [_shareViewModel show];
    }else if (_materialViewModel){
        [_materialViewModel show];
    }
}

#pragma mark - 初始化界面
+(BOOL)isAvailableForServiceType:(NSString *)serviceType{
    if ([serviceType isEqualToString:@"com.share.default"]) {
        return YES;
    }else if ([serviceType isEqualToString:@"com.share.material"]){
        return YES;
    }
    return NO;
}


+(instancetype)shareViewControllerForServiceType:(NSString *)serviceType{
    AMDShareController *shareVC = [[AMDShareController alloc]initWithTitle:nil titileViewShow:NO tabBarShow:NO];
    shareVC.serviceType = serviceType;
    shareVC.currentImage = [shareVC renderImage];

    return shareVC;
}


#pragma mark - 搭建相应视图
- (void)initShareViewModel {
    AMDShareViewModel *viewModel = [[AMDShareViewModel alloc]init];
    _shareViewModel = viewModel;
    viewModel.shareSource = self.shareSource;
    viewModel.shareImageUrls = self.shareImageUrls;
    viewModel.shareShortUrl = self.shareShortUrl;
    viewModel.shareUrl = self.shareUrl;
    viewModel.shareContent = self.shareContent;
    viewModel.shareTitle = self.shareTitle;
    viewModel.senderController = self;
    viewModel.backImage = _currentImage;
    viewModel.customIntentIdentifiers = self.customIntentIdentifiers;
    viewModel.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState,NSError* error) {
        if (_completionHandle) {
            _completionHandle(shareType,responseState,error);
        }
    };
    [viewModel prepareView];
}

- (void)initMaterialViewModel {
    AMDShareMaterialViewModel *viewmodel = [[AMDShareMaterialViewModel alloc]init];
    viewmodel.senderController = self;
    viewmodel.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState,NSError* error) {
        if (_completionHandle) {
            _completionHandle(shareType,responseState,error);
        }
    };
    viewmodel.serviceProtocal = self.serviceProtocal;
    viewmodel.shareContent = self.shareContent;
    viewmodel.shareImageUrls = self.shareImageUrls;
    viewmodel.shareUrl = self.shareUrl;
    viewmodel.backImage = _currentImage;
    _materialViewModel = viewmodel;
    [viewmodel prepareView];
}


#pragma mark - 截取上个VC图片
- (UIImage *)renderImage
{
    id<UIApplicationDelegate> app = [UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(APPWidth, APPHeight), 1, 0.0);
    [[app window].rootViewController.view drawViewHierarchyInRect:[app window].rootViewController.view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
