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
#import "AMDShareMaterialController.h"

@interface ViewController ()<MShareRequestDelegate>
{

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MShareManager shareInstance].requestDelegare = self;;
    [self.navigationController setNavigationBarHidden:YES];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    bt.backgroundColor = [UIColor redColor];
    [bt addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}



- (void)click {
    AMDShareController *VC = [[AMDShareController alloc]init];
    [self presentViewController:VC animated:NO completion:nil];
}

-(void)click2{
    AMDShareMaterialController *VC = [[AMDShareMaterialController alloc]init];
    [self presentViewController:VC animated:NO completion:nil];
}


#pragma mark - MShareRequestDelegate
-(void)initShareViewWithType:(void(^)(AMDShareViewFrom type))type{
    type(AMDShareViewFromTempGoods);
}

-(void)getShareSource:(void (^)(NSString *, AMDShareToType, NSString *, NSString *, NSString *, NSArray *, NSArray *, NSString *, NSString *))source{
    source(@"id",ShareToUMSDK,@"fdasf",@"dasfdasf",@"fsadfds",@[@"dasfsad"],@[@"dfasfdas"],@"1231321",@"fasdfadsfdsaf");
}

@end
