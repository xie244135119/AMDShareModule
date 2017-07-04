//
//  AMDShareQrCodeControllerViewController.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/7/4.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "AMDShareQrCodeController.h"
#import "AMDShareQrCodelViewModel.h"
#import "MShareStaticMethod.h"


@interface AMDShareQrCodeController ()
{
    UIImage *_currentImage;
    AMDShareQrCodelViewModel *_viewModel;
}
@end

@implementation AMDShareQrCodeController

- (id)initWithTitle:(NSString *)title
{
    _currentImage = [self renderImage];
    return [super initWithTitle:title titileViewShow:NO tabBarShow:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_viewModel show];
}

- (void)initContentView {
    AMDShareQrCodelViewModel *viewmodel = [[AMDShareQrCodelViewModel alloc]init];
    viewmodel.senderController = self;
    viewmodel.backImage = _currentImage;
    _viewModel = viewmodel;
    [viewmodel prepareView];
}

- (UIImage *)renderImage
{
    id<UIApplicationDelegate> app = [UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(APPWidth, APPHeight), 1, 0.0);
    [[app window].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
