//
//  ViewController.m
//  ios
//
//  Created by 马清霞 on 2017/7/3.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "ViewController.h"
#import "AMDShareController.h"
//#import "MShareManager.h"
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
    AMDShareController *VC = [AMDShareController shareViewControllerForServiceType:@"com.share.default"];
    VC.shareTitle = @"mingcheng ";
    VC.shareContent = @"neirong";
    VC.shareUrl = @"www.baidu.com";
    VC.shareShortUrl = @"www.baidu.com";
    VC.shareImageUrls = @[[NSURL URLWithString:@"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=tup&step_word=&hs=0&pn=0&spn=0&di=34039469310&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&istype=0&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=undefined&cs=4131634322%2C487666839&os=3422253642%2C3624277890&simid=3468816028%2C333149790&adpicid=0&lpn=0&ln=1987&fr=&fmq=1499671877172_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fimglf0.ph.126.net%2F1EnYPI5Vzo2fCkyy2GsJKg%3D%3D%2F2829667940890114965.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bs5upj6_z%26e3Bv54AzdH3Fuweks52AzdH3Fo78llnb9%3Fur5fp%3Dd1jn9b_l8bd1l1&gsm=0&rpstart=0&rpnum=0"]];
    VC.customIntentIdentifiers = @[@1,@2,@3,@4];
    VC.shareSource = 1;
    VC.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
    };
    [self presentViewController:VC animated:NO completion:nil];
}


@end
