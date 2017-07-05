//
//  ViewController.m
//  ios
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "ViewController.h"
#import "AMDShareController.h"
#import "MShareManager.h"
//#import "AMDShareMaterialController.h"

@interface ViewController ()
{

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    bt.backgroundColor = [UIColor redColor];
    [bt addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}



- (void)click {
    AMDShareController *VC = [AMDShareController shareViewControllerForServiceType:@"com.share.material"];
    VC.shareTitle = @"mingcheng ";
    VC.shareContent = @"neirong";
    VC.shareUrl = @"www.baidu.com";
    VC.shareShortUrl = @"www.baidu.com";
    VC.shareImageUrls = @[@"www.tupian.com"];
    VC.customIntentIdentifiers = @[@1,@2,@3,@4];
    VC.shareSource = 1;
    VC.handleShareAction = ^(AMDShareType shareType, NSString *alertTitle) {
        NSLog(@"---------%lu--------%@",(unsigned long)shareType,alertTitle);
    };
    [self presentViewController:VC animated:NO completion:nil];
}


@end
