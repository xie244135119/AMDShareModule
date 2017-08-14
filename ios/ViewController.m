//
//  ViewController.m
//  ios
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "ViewController.h"
#import "AMDShareController.h"
#import "AMDUMSDKManager.h"
#import "SMGreatShareController.h"
#import <WXApi.h>
//#import "MShareManager.h"
//#import "AMDShareMaterialController.h"

@interface ViewController ()
{

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApi registerApp:@"wx70de670912bf7725"];
    [self.navigationController setNavigationBarHidden:YES];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    bt.backgroundColor = [UIColor redColor];
    [bt addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}


- (void)click {
    
    SMGreatShareController *VC = [[SMGreatShareController alloc]initWithTitle:@"创建商品" titileViewShow:YES tabBarShow:NO];


    VC.shareImageUrlArray =  @[@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100",@"http://wdwd-prod.wdwdcdn.com/597713f192953.jpg",@"http://wdwd-prod.wdwdcdn.com/596726da1bb6e.jpg",@"http://wdwd-prod.wdwdcdn.com/596726d454c85.jpg"];
    VC.shareContent = @"我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！";
    VC.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
        NSLog(@"----%lu",(unsigned long)responseState);
    };
    [self.navigationController pushViewController:VC animated:YES];
    
    return;
////    UIImage *img =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"]]];
//    NSURL *img =[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"];
//    [AMDUMSDKManager shareUMType:AMDShareTypeWeChatSession sender:img competion:^(AMDShareResponseState responseState, NSError *error) {
//    }];
    
//    AMDShareController *VC = [AMDShareController shareViewControllerForServiceType:@"com.share.material"];
////    VC.shareTitle = @"mingcheng ";
//    VC.shareContent = @"neirong";
////    VC.shareUrl = @"www.baidu.com";
////    VC.shareShortUrl = @"www.baidu.com";
//    VC.shareImageUrls = @[[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"]];
//    VC.customIntentIdentifiers = @[@1,@2,@3,@4,@5,@6,@7,@8];
//    VC.shareSource = 1;
//    VC.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
//    };
//    [self presentViewController:VC animated:NO completion:nil];
}


@end
