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

@interface AMDShareController ()
{
    UIImage *_currentImage;
    AMDShareViewModel *_viewModel ;
}
@end

@implementation AMDShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewModel];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_viewModel show];
}


- (id)initWithTitle:(NSString *)title
{
        _currentImage = [self renderImage];
    return [super initWithTitle:title titileViewShow:NO tabBarShow:NO];
}


- (void)initViewModel {
    AMDShareViewModel *viewModel = [[AMDShareViewModel alloc]init];
    _viewModel = viewModel;
    viewModel.senderController = self;
    viewModel.backImage = _currentImage;
    [viewModel prepareView];
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
