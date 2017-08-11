//
//  ImagePreviewController.m
//  TradeApp
//
//  Created by SunSet on 14-6-3.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#define kAPPWidth self.view.frame.size.width
#define kAPPHeight self.view.frame.size.height

#import "SMImagePreviewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
//#import "AMDUIFactory.h"
//#import "AMDCommonClass.h"
//#import "AMDShareManager.h"
//#import "AMDUMSDKManager.h"
//#import "AMDTool.h"
//#import "AMDPhotoService.h"
#import <SSBaseLib/SSBaseLib.h>
#import "MShareStaticMethod.h"
/**
 *  1. 图片从原始位置直接放大到大图位置
 *  2.图片加载loading机制
 *  3.图片加载完成之后更换原图处理
 */

@interface SMImagePreviewController ()<UIScrollViewDelegate,UIViewControllerAnimatedTransitioning>
{
    __weak UIScrollView *_currentScrollView;            //当前的scrollView
    __weak UILabel *_currentPageLabel;                  //当前分页标签
}
@property(nonatomic, weak) UIImageView *currentSelectImageView;     //当前选中的imageView
@end

@implementation SMImagePreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.originalFrames = nil;
    self.thumbnailImages = nil;
    self.remoteImagePaths = nil;
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 加载视图
-(void)initContentView
{
    self.view.backgroundColor = [UIColor blackColor];
    self.transitioningDelegate = self;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tap];
    
    // 长按手势--保存图片
//    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
//    longpress.minimumPressDuration = 0.5;
//    [self.view addGestureRecognizer:longpress];
//    [tap requireGestureRecognizerToFail:longpress];
    
    //外层的scrollView
    NSInteger totalcount = _remoteImagePaths.count;
    UIScrollView *totoalScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    totoalScrollView.showsHorizontalScrollIndicator = NO;
    totoalScrollView.pagingEnabled = YES;
    totoalScrollView.delegate = self;
    totoalScrollView.tag = 1;
    [self.view addSubview:totoalScrollView];
    totoalScrollView.contentSize = CGSizeMake(kAPPWidth*totalcount, totoalScrollView.frame.size.height);
    [totoalScrollView setContentOffset:CGPointMake(kAPPWidth*_currentIndex, 0) animated:NO];
    _currentScrollView = totoalScrollView;
    
    //页数--Label
    UILabel *pagelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-20, kAPPWidth, 20)];
    pagelabel.textColor = [UIColor whiteColor];
    pagelabel.textAlignment = NSTextAlignmentCenter;
    if (_remoteImagePaths.count > 1) {
        pagelabel.text = [NSString stringWithFormat:@"%li/%lu",(long)_currentIndex+1,(unsigned long)totalcount];
    }
    [self.view addSubview:pagelabel];
    _currentPageLabel = pagelabel;
    
    for (NSInteger i = 0;i<totalcount;i++) {
        
        CGRect scrollViewframe = CGRectMake(kAPPWidth*i, 0, kAPPWidth, totoalScrollView.frame.size.height);
        //放大的scrollView
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:scrollViewframe];
        scrollView.tag = 2+i;
        scrollView.maximumZoomScale = 2;
        scrollView.minimumZoomScale = 0.5;
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [totoalScrollView addSubview:scrollView];
        
        //图片视图 --默认位置
        CGRect imgframe = CGRectFromString(_originalFrames.count>i?_originalFrames[i]:@"{{0,0},{100,100}}");
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:imgframe];
        imgView.tag = 1;
        imgView.image = _thumbnailImages.count>i?_thumbnailImages[i]:nil;
        [scrollView addSubview:imgView];
        
//        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
//        imgView.layer.borderWidth = 1;
        
//#warning 采用V2.0版本思路
//        CGRect imgframe = [self imageZoomToScreen:imgView.image.size];
//        imgView.frame = imgframe;
//        continue;
//        return;
        
        //设置初始图片位置  第一张图片的动画
        if (i == _currentIndex) {
            _currentSelectImageView = imgView;
            imgView.frame = imgframe;
        }
        else{
            //其他视图
            imgView.frame = CGRectMake((SScreenWidth-imgframe.size.width)/2, (SScreenHeight-imgframe.size.height)/2, imgframe.size.width, imgframe.size.height);
            [self loadPhotoFromInternetOnImageView:imgView index:i];
        }
    }
    
    //第一张动画--如果图片存在--直接本地动画
    UIImage *localImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:_remoteImagePaths[_currentIndex]];
    if (localImage) {
        _currentSelectImageView.image = localImage;
        CGRect frame = [self dealFrameWithImage:localImage];
        [UIView animateWithDuration:0.5 animations:^{
            _currentSelectImageView.frame = frame;
        } completion:^(BOOL finished) {
            if (frame.size.height >= SScreenHeight) {
                //设置scrollView的滑动位置
                UIScrollView *scrollView = (UIScrollView *)_currentSelectImageView.superview;
                scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, frame.size.height);
            }
        }];
    }
    else {
        CGRect imgframe = _currentSelectImageView.frame;
        _currentSelectImageView.frame = CGRectMake((kAPPWidth-imgframe.size.width)/2, (kAPPHeight-imgframe.size.height)/2, imgframe.size.width, imgframe.size.height);
        [self loadPhotoFromInternetOnImageView:_currentSelectImageView index:_currentIndex];
    }
}


//加载网络图片---和本地图片
- (void)loadPhotoFromInternetOnImageView:(UIImageView *)imgView index:(NSInteger)index
{
    //加载动画
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = imgView.bounds;
    activityView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [activityView startAnimating];
    [imgView addSubview:activityView];
    
    //配置当前第一组页面
    NSURL *url = nil;
    NSString *imagepath = _remoteImagePaths[index];
    if (![imagepath respondsToSelector:@selector(hasPrefix:)]) {
        // 如果地址不是字符串 hasPrefix:
        return;
    }
    
    // 网络图片
    if ([imagepath hasPrefix:@"http"]) {
        url = [[NSURL alloc]initWithString:imagepath];
    }
    else {  //本地图片
        url = [[NSURL alloc]initFileURLWithPath:imagepath];
    }
    
    __block UIImageView *_imgView = imgView;
    __block UIActivityIndicatorView *_activityView = activityView;
    UIImage *placderimage = _thumbnailImages.count>index?_thumbnailImages[index]:SMShareSrcImage(@"xnormal_img@2x.png");
    [imgView sd_setImageWithURL:url placeholderImage:placderimage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [_activityView removeFromSuperview];
            
            
            //如果取的是缓存的话
            CGRect frame = [self dealFrameWithImage:image];
            
            //获取图片的高度 显示出来
            [UIView animateWithDuration:0.5 animations:^{
                _imgView.frame = frame;
                
            } completion:^(BOOL finished) {
                if (frame.size.height >= SScreenHeight) {
                    //设置scrollView的滑动位置
                    UIScrollView *scrollView = (UIScrollView *)_imgView.superview;
                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, frame.size.height);
                }
            }];
        }
        else {
            [_activityView removeFromSuperview];
//            [AMDUIFactory makeToken:_imgView message:@"加载失败"];
        }
    }];
    
}

// 不显示状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

// 显示方式
//- (AMDControllerShowType)controllerShowType
//{
//    return AMDControllerShowTypePresent;
//}



#pragma mark - 
// 重写SET方法
- (void)setRemoteImagePaths:(NSArray *)remoteImagePaths
{
    if (_remoteImagePaths != remoteImagePaths) {
        if (remoteImagePaths) {
            NSMutableArray *muarry = [[NSMutableArray alloc]init];
            for (NSString *path in remoteImagePaths) {
                // 防御处理
                if ([path isKindOfClass:[NSNull class]]) continue;

                // 来自七牛的地址
                if ([path rangeOfString:@"qiniudn"].length > 0 || [path rangeOfString:@"wdwdcdn"].length > 0) {
                    // 没有接受裁剪
                    if ([path rangeOfString:@"?imageView2"].length == 0) {
                         [muarry addObject:[path stringByAppendingString:@"?imageView2/3/w/640/h/100"]];
                        continue;
                    }
                }
                    [muarry addObject:path];
            }
            _remoteImagePaths = muarry;
        }
    }
}



#pragma mark - 图片预览器 V2.0版本
- (void)_loadImageOnView:(UIImageView *)imageview
{
    
}



// 将图片等比放大到宽屏位置
- (CGRect)imageZoomToScreen:(CGSize)thumbimagesize
{
    if (CGSizeEqualToSize(thumbimagesize, CGSizeZero)) {
        // 如果没有默认图 则直接显示图中间位置
        return CGRectMake(0, (kAPPHeight-kAPPWidth)/2, kAPPWidth, kAPPWidth);
    }
    
    CGRect rect = CGRectZero;
    rect.size.width = kAPPWidth;
    rect.size.height = rect.size.width*thumbimagesize.height/thumbimagesize.width;
    return rect;
}




#pragma mark - 数据处理
// 根据图片原始尺寸计算大小
-(CGRect)dealFrameWithImage:(UIImage *)image
{
    CGSize size = [self convertFrame:image.size];
    CGFloat height = kAPPHeight;
    
    //如果是长图的话 需要自动滚动
    if (size.height > height) {
        return CGRectMake(0, 0, kAPPWidth, size.height);
    }
    
    //如果是图片宽不超过屏幕的话
    if (size.width < kAPPWidth) {
        //图片高不超过一屏幕
        if (size.height < kAPPHeight) {
            return CGRectMake((kAPPWidth-size.width)/2, (kAPPHeight-size.height)/2, size.width, size.height);
        }
        //图片高超出一屏幕
        return CGRectMake((kAPPWidth-size.width)/2, 0, size.width, size.height);
    }
    
    return CGRectMake(0, (height-size.height)/2, kAPPWidth, size.height);
}

//将图片的大小转化为展示控件的大小
-(CGSize)convertFrame:(CGSize)size
{
    CGSize newsize = size;
    // 如果长图
    // 超出一个屏幕的话
    if (size.width > kAPPWidth) {
        newsize.width = kAPPWidth;
        newsize.height = kAPPWidth*size.height/size.width ;
    }
    return newsize;
}



#pragma mark - 手势事件
// 点击手势
-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.35 animations:^{
        // 缩放处理
        NSString *framestr = _originalFrames[MIN(_originalFrames.count-1, _currentIndex)];
        _currentSelectImageView.frame = CGRectFromString(framestr);
    } completion:^(BOOL finished) {
        [weakself dismissViewControllerAnimated:NO completion:nil];
    }];
}

// 长按手势
//- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPress
//{
//    switch (longPress.state) {
//        case UIGestureRecognizerStateBegan:     //手势开始的时候
//        {
//            [[AMDCommonClass sharedAMDCommonClass] showActionSheetWithTitle:nil action:^(NSInteger index) {
//                switch (index) {
//                    case 1:     //保存图片
//                    {
//                        // 判断权限
//                        if (![AMDPhotoService permissionFromType:AMDPrivacyPermissionTypeAssetsLibrary]) {
//                            return ;
//                        }
//                        // 缓存图片
//                        [AMDPhotoService savePhotoAlbumWithImage:_currentSelectImageView.image completion:^(BOOL success, NSError *error) {
//                            [AMDUIFactory makeToken:nil message:success?@"保存图片成功":@"保存图片失败"];
//                        }];
//                        
////                        UIImageWriteToSavedPhotosAlbum(_currentSelectImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//                    }
//                        break;
//                    case 2:     //分享微信
//                    {
//                        NSString *urlstr = _remoteImagePaths[_currentIndex];
//                        BOOL internetphotourl = [urlstr hasPrefix:@"http"];
//                        [AMDUMSDKManager shareUMType:AMDShareTypeWeChatSession sender:internetphotourl?[NSURL URLWithString:urlstr]:[NSURL fileURLWithPath:urlstr] competion:^(AMDShareResponseState responseState, NSError *error) {
//                            switch (responseState) {
//                                case AMDShareResponseSuccess:
//                                    [AMDUIFactory makeToken:nil message:@"分享成功"];
//                                    break;
//                                case AMDShareResponseFail:
//                                    [AMDUIFactory makeToken:nil message:@"分享失败"];
//                                    break;
//                                case AMDShareResponseCancel:
//                                    [AMDUIFactory makeToken:nil message:@"取消分享"];
//                                    break;
//                                default:
//                                    break;
//                            }
//                        }];
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
//            } cancelBt:@"取消" destructiveBt:nil otherButtonTitles:@"保存图片",@"分享微信", nil];
//
//        }
//            break;
//        default:
//            break;
//    }
//}

// 保存图片回调方法
//- (void)image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
//{
//    if(error != NULL){
////        switch ([error code]) {
////            case -3310:         //数据不可用
////                [AMDUIFactory makeToken:nil message:@"权限不足 请打开设置-隐私-照片 找到 有量 并允许使用"];
////                break;
////            default:
//                [AMDUIFactory makeToken:nil message:error.localizedDescription];
////                break;
////        }
//    }else{
//        [AMDUIFactory makeToken:self.view message:@"保存图片成功"];
//    }
//}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1) {
        return nil;
    }
    
    return [scrollView viewWithTag:1];
}

/** 结束放大的时候 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //放大或缩小之后的最大尺寸(frame和contentsize比较)
    CGSize size = CGSizeMake(MAX(scrollView.contentSize.width,scrollView.frame.size.width), MAX(scrollView.contentSize.height,scrollView.frame.size.height));
    //将图片移动至中心
    [UIView animateWithDuration:0.25 animations:^{
        view.center = CGPointMake(size.width/2, size.height/2);
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1) {
        NSInteger index = (NSInteger)scrollView.contentOffset.x/kAPPWidth;
        UIScrollView *childscro = (UIScrollView *)[scrollView viewWithTag:(2+index)];
        _currentSelectImageView = (UIImageView *)[childscro viewWithTag:1];
        _currentIndex = index;
        //            _currentPageControl.currentPage = index;
        NSString *pagetext = [[NSString alloc]initWithFormat:@"%li/%lu",index+1,(unsigned long)_remoteImagePaths.count];
        _currentPageLabel.text = pagetext;
        //            [_operableScrollView setContentOffset:CGPointMake(320*index, 0) animated:YES];
        
        //        }
    }
}




#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *conterView = transitionContext.containerView;
    SMImagePreviewController *toVC =  (SMImagePreviewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC.view.alpha = 0;
    [conterView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        fromVC.view.transform = CGAffineTransformMakeScale(2, 2);
        //        toVC.currentSelectImageView.frame = CGRectMake(0, 0, , 10);
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        //必须添加---否则视图结束后无法操作
        [transitionContext completeTransition:YES];
        //        fromVC.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}


#pragma mark - UIViewControllerTransitioningDelegate---模态展示
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    //优化弹出登录页面的时候
    if ([presented isKindOfClass:[self class]]) {
        return self;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    //消失的时候么有动画
    return nil;
}


@end

















