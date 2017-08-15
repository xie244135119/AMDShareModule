//
//  GreatShareController.m
//  GreatShareViewTest
//
//  Created by 马清霞 on 2017/8/9.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SMGreatShareController.h"
#import "SMGreatShareViewModel.h"
#import "SMPreviewController.h"

@interface SMGreatShareController ()<AMDControllerTransitionDelegate>
{
    SMGreatShareViewModel *_viewModel;
}
@end

@implementation SMGreatShareController


-(void)dealloc{
    _shareImageUrlArray = nil;
    _shareImageArray = nil;
    _shareUrl = nil;
    _shareContent = nil;
    _completionHandle = nil;
}


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
    viewModel.selectAction = ^(NSInteger index) {
        SMPreviewController *VC = [SMPreviewController showImage:_shareImageArray imageUrl:_shareImageUrlArray showIndex:index completion:nil];
        VC.delegate = weakself;
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    
    viewModel.shareUrl = self.shareUrl;
    viewModel.shareContent = self.shareContent;
    viewModel.shareImageUrlArray = self.shareImageUrlArray;
    viewModel.shareImageArray = self.shareImageArray;
    viewModel.senderController = self;
    _viewModel = viewModel;
    [viewModel prepareView];
}


#pragma mark - AMDControllerTransitionDelegate
- (void)viewController:(id)viewController object:(id)sender{
    if ([sender[@"type"] isEqualToString:@"save"]) {
        BOOL type = sender[@"status"];
        if (self.completionHandle) {
            self.completionHandle(AMDShareTypeTuwenShare,type?AMDShareResponseSuccess:AMDShareResponseFail,nil);
        }
    }else{
        NSNumber *tag = sender[@"tag"];
        [_viewModel invokeImageIconWithIndex:tag.integerValue];
    }
}

@end
