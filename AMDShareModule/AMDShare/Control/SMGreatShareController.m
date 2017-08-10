//
//  GreatShareController.m
//  GreatShareViewTest
//
//  Created by 马清霞 on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SMGreatShareController.h"
#import "SMGreatShareViewModel.h"


@interface SMGreatShareController ()
{
    SMGreatShareViewModel *_viewModel;
}
@end

@implementation SMGreatShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewModel];
}

-(void)initViewModel{
    self.supportBackBt = YES;
    SMGreatShareViewModel *viewModel = [[SMGreatShareViewModel alloc]init];
    __weak typeof(self) weakself = self;
    viewModel.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
        if (weakself.completionHandle) {
            weakself.completionHandle(shareType,responseState,error);
        }
    };
    viewModel.shareUrl = self.shareUrl;
    viewModel.shareContent = self.shareContent;
    viewModel.shareImageArray = self.shareImageArray;
    viewModel.senderController = self;
    _viewModel = viewModel;
    [viewModel prepareView];
}


@end
