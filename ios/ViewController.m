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
#import "MShareStaticMethod.h"
#import "SMPreviewController.h"




@interface ViewController ()<AMDControllerTransitionDelegate>
{
    
}
@end

@implementation ViewController


-(void)dealloc{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApi registerApp:@"wx70de670912bf7725"];
    [self.navigationController setNavigationBarHidden: YES];
}


- (IBAction)greatShare:(id)sender {
    SMGreatShareController *VC = [[SMGreatShareController alloc]initWithTitle:@"创建商品" titileViewShow:YES tabBarShow:NO];
    
    UIImage *img = SMShareSrcImage(@"share_weixin@2x.png");
    UIImage *img2 = SMShareSrcImage(@"share_weixin-friend@2x.png");
    UIImage *img3 = SMShareSrcImage(@"share_qq@2x.png");
    
    VC.shareImageArray = @[img,img2,img3];
    NSArray *imageurls =  @[ [NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/597713f192953.jpg"],[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/596726da1bb6e.jpg"],[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"]];
    
    VC.shareImageUrlArray =  imageurls;
    VC.shareContent = @"我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！我是分享的内容test！！！！";
    VC.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
        NSLog(@"----%lu",(unsigned long)responseState);
    };
    [self.navigationController pushViewController:VC animated:YES];
}


- (IBAction)defaultShare:(id)sender {
    AMDShareController *VC = [AMDShareController shareViewControllerForServiceType:@"com.share.default"];
    VC.shareContent = @"neirong";
    VC.shareImageUrls = @[[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"]];
    VC.customIntentIdentifiers = @[@1,@2,@3,@4,@5,@6,@7,@8];
    VC.shareSource = 1;
    VC.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
        
    };
    [self presentViewController:VC animated:NO completion:nil];
    
}


- (IBAction)materialShare:(id)sender {
    AMDShareController *VC = [AMDShareController shareViewControllerForServiceType:@"com.share.material"];
    VC.shareContent = @"neirong";
    VC.shareImageUrls = @[[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"]];
    VC.customIntentIdentifiers = @[@1,@2,@3,@4,@5,@6,@7,@8];
    VC.shareSource = 1;
    VC.completionHandle = ^(AMDShareType shareType, AMDShareResponseState responseState, NSError *error) {
    };
    [self presentViewController:VC animated:NO completion:nil];
}


- (IBAction)PicShare:(id)sender {
    NSURL *img =[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"];
    [AMDUMSDKManager shareUMType:AMDShareTypeWeChatSession sender:img competion:^(AMDShareResponseState responseState, NSError *error) {
    }];
}

- (IBAction)showPic:(id)sender {
    UIImage *img = [UIImage imageNamed:@"1.pic.jpg"];
    UIImage *img2 = [UIImage imageNamed:@"2.pic.jpg"];
    //        UIImage *img2 = SMShareSrcImage(@"share_weixin-friend@2x.png");
    //        UIImage *img3 = SMShareSrcImage(@"share_qq@2x.png");
    NSArray *localimags = @[img,img2];
    
    NSArray *imageurls =  @[ [NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/597713f192953.jpg"],[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/596726da1bb6e.jpg"],[NSURL URLWithString:@"http://wdwd-prod.wdwdcdn.com/5965d340aec6c.jpg_640x640.jpg?imageView2/3/w/640/h/100"]];
    NSMutableArray *arrys = [[NSMutableArray alloc]initWithArray:nil];
    [arrys addObjectsFromArray:localimags];
    SMPreviewController *VC = [SMPreviewController showImage:nil imageUrl:arrys selectImages:nil showIndex:0 completion:nil];
    VC.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - AMDControllerTransitionDelegate
- (void)viewController:(id)viewController object:(id)sender{
    NSLog(@"=========%@",sender);
}


@end
