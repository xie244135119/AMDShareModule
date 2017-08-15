//
//  SMPreviewViewModel.m
//  AMDShareModule
//
//  Created by 马清霞 on 2017/8/14.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "SMPreviewViewModel.h"
#import <SSBasekit/SSBaseKit.h>
#import <Masonry/Masonry.h>
#import <SSBaseLib/SSBaseLib.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MShareStaticMethod.h"
#import <Photos/Photos.h>

@interface SMPreviewViewModel()<UIScrollViewDelegate>
{
    AMDRootViewController *_senderController;
    UIScrollView *_currentScrollView;
    UIPageControl *_currentPageControl;
    NSMutableArray *_selectImageArray;
    UILabel *_currentSelectCountLB;  //当前选中的图片数量
    AMDButton *_selectImageButton;
}

@end

@implementation SMPreviewViewModel

-(void)dealloc{
    _senderController = nil;
    _currentScrollView = nil;
    _currentPageControl = nil;
}


-(void)prepareView{
    _senderController = (AMDRootViewController *)self.senderController;
    [self initContenView];
}


-(void)initContenView{
    _selectImageArray = [[NSMutableArray alloc]init];
    //
    _senderController.contentView.backgroundColor = [UIColor blackColor];
    //
    UIScrollView *scrollerView = [[UIScrollView alloc]init];
    _currentScrollView = scrollerView;
    scrollerView.delegate = self;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.pagingEnabled = YES;
    [_senderController.contentView addSubview:scrollerView];
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.centerY.equalTo(_senderController.contentView.mas_centerY).offset(-20);
        make.centerX.equalTo(_senderController.contentView.mas_centerX);
        make.height.offset(SScreenWidth);
    }];
    
    UIView *scrollerContentView = [[UIView alloc]init];
    [scrollerView addSubview:scrollerContentView];
    [scrollerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(@(SScreenWidth*_showImages.count));
        make.height.offset(SScreenWidth);
    }];
    
    //创建图片视图
    for (int i = 0; i < _showImages.count; i++) {
        CGRect imageRect = CGRectMake(0, 0, 0, 0);
        UIImageView *showImageView = [[UIImageView alloc]init];
        id imageobject = _showImages[i];
        if ([imageobject isKindOfClass:[UIImage class]]) {
            showImageView.image = imageobject;
            imageRect.size = showImageView.image.size;
        }
        else if([imageobject isKindOfClass:[NSURL class]]){
            NSURL *imageUrl = imageobject;
            [showImageView sd_setImageWithURL:imageUrl placeholderImage:SMShareSrcImage(@"xnormal_img@2x.png")];
            UIImage *localImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrl.relativeString];
            imageRect = [self dealFrameWithImage:localImage];
        }
        [scrollerContentView addSubview:showImageView];
        [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset((i*SScreenWidth)+((SScreenWidth/2)-(imageRect.size.width/2)));
            make.centerY.equalTo(scrollerContentView.mas_centerY);
            make.width.offset(imageRect.size.width);
            make.height.offset(imageRect.size.height);
        }];
    }
    
    //标签页
    UIPageControl *pageCtrol = [[UIPageControl alloc]init];
    _currentPageControl = pageCtrol;
    pageCtrol.numberOfPages = _showImages.count;
    pageCtrol.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageCtrol.pageIndicatorTintColor = ColorWithRGB(60, 53, 53, 1);
    pageCtrol.hidesForSinglePage = YES;
    [pageCtrol addTarget:self action:@selector(clickPageControlAction:) forControlEvents:UIControlEventValueChanged];
    [_senderController.contentView addSubview:pageCtrol];
    [pageCtrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(scrollerView.mas_bottom).offset(0);
        make.height.offset(30);
    }];
    
    //确定按钮
    AMDButton *selectBT = [[AMDButton alloc]init];
    selectBT.titleLabel.textAlignment = NSTextAlignmentRight;
    selectBT.titleLabel.text = @"确定";
    [selectBT addTarget:self action:@selector(completionSelectImage:) forControlEvents:UIControlEventTouchUpInside];
    [selectBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_senderController.contentView addSubview:selectBT];
    [selectBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(pageCtrol.mas_bottom).offset(30);
        make.width.offset(60);
        make.height.offset(40);
    }];

    UILabel *imageCountLB = [[UILabel alloc]init];
//    imageCountLB.text = @"0";
    imageCountLB.textAlignment = NSTextAlignmentCenter;
    _currentSelectCountLB = imageCountLB;
    imageCountLB.backgroundColor = [UIColor redColor];
    imageCountLB.textColor = [UIColor whiteColor];
    imageCountLB.layer.masksToBounds = YES;
    imageCountLB.layer.cornerRadius = 10;
    [selectBT addSubview:imageCountLB];
    [imageCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(3);
        make.centerY.equalTo(selectBT.mas_centerY);
        make.width.height.offset(20);
    }];
    imageCountLB.hidden = YES;
    
    
    //保存图片按钮
    AMDButton *saveBT = [[AMDButton alloc]init];
    [saveBT addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    saveBT.titleLabel.textAlignment = NSTextAlignmentLeft;
    saveBT.titleLabel.text = @"保存此图片";
    [saveBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_senderController.contentView addSubview:saveBT];
    [saveBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(pageCtrol.mas_bottom).offset(30);
        make.width.offset(100);
        make.height.offset(30);
    }];
    
    //返回按钮
    AMDButton *backBT = [[AMDButton alloc]init];
    [backBT setImage2:SMShareSrcImage(@"back_normal@2x.png") forState:UIControlStateHighlighted];
    [backBT setImage2:SMShareSrcImage(@"back_selected@2x.png") forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    backBT.titleLabel.textAlignment = NSTextAlignmentRight;
    [backBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_senderController.contentView addSubview:backBT];
    [backBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(50);
        make.width.height.offset(24);
    }];
    [backBT.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.top.bottom.left.right.offset(0);
    }];
    
    //选中图标
    AMDButton *selectImage = [[AMDButton alloc]init];
    _selectImageButton = selectImage;
    [selectImage addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    [selectImage setImage2:SMShareSrcImage(@"cart_riadio@2x.png") forState:UIControlStateNormal];
    [selectImage setImage2:SMShareSrcImage(@"cart_riadio-select@2x.png") forState:UIControlStateSelected];
    selectImage.titleLabel.textAlignment = NSTextAlignmentLeft;
    [selectImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_senderController.contentView addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(50);
        make.width.height.offset(24);
    }];
    [selectImage.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
}


#pragma mark - 图片大小配置
// 根据图片原始尺寸计算大小
-(CGRect)dealFrameWithImage:(UIImage *)image
{
    CGSize size = [self convertFrame:image.size];
    return CGRectMake(0, 0, size.width, size.height);
}


//将图片的大小转化为展示控件的大小
-(CGSize)convertFrame:(CGSize)size
{
    CGSize newsize = size;
    // 如果长图
    // 超出一个屏幕的话
    if (size.width > SScreenWidth) {
        newsize.width = SScreenWidth;
        newsize.height = SScreenWidth*size.height/size.width ;
    }
    return newsize;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _currentPageControl.currentPage = (NSInteger)(scrollView.contentOffset.x/SScreenWidth);
    NSLog(@"-----%ld",(long)_currentPageControl.currentPage);
    if (![_selectImageArray containsObject:@(_currentPageControl.currentPage )]) {
        _selectImageButton.selected = NO;
    }else{
        _selectImageButton.selected = YES;
    }
}


#pragma mark - 点击事件
//点击pageControl
-(void)clickPageControlAction:(UIPageControl *)control{
    NSInteger index = control.currentPage;
    [_currentScrollView setContentOffset:CGPointMake(index*SScreenWidth, 0) animated:YES];
}


//回退界面
-(void)clickBack:(AMDButton *)sender{
    [_senderController.navigationController popViewControllerAnimated:YES];
}


//保存图片
-(void)saveImage:(AMDButton *)sender{
    UIImage *image = nil;
    id imageobject = _showImages[_currentPageControl.currentPage];
    if ([imageobject isKindOfClass:[UIImage class]]) {
        image = imageobject;
        [self savePhotoAlbumWithImage:image completion:^(BOOL success, NSError *error) {
            if ([_senderController respondsToSelector:@selector(viewController:object:)]) {
                [(id<AMDControllerTransitionDelegate>)_senderController viewController:self object:@{@"type":@"save",@"status":@(success)}];
            };
        }];
    }
    else if ([imageobject isKindOfClass:[NSURL class]]){
        NSURL *imageurl = imageobject;
        __weak typeof(self) weakself = self;
        [self saveImageWithUrl:imageurl completion:^(UIImage *cachesImage, NSError *error) {
            [weakself savePhotoAlbumWithImage:cachesImage completion:^(BOOL success, NSError *error) {
                if ([_senderController respondsToSelector:@selector(viewController:object:)]) {
                    [(id<AMDControllerTransitionDelegate>)_senderController viewController:self object:@{@"type":@"save",@"status":@(success)}];
                };
            }];
        }];
    }
}


// 保存图文
- (void)saveImageWithUrl:(NSURL *)imageUrl
              completion:(void (^)(UIImage *cachesImage, NSError *error))completion
{
    [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        // 加载动画
        //
        if (finished) {
            if ((cacheType == SDImageCacheTypeMemory && image) || data ) {
                completion(image,nil);
            }
            else {
                //                completion(_allCacheImages, error);
            }
        }
        else {
            //            completion(_allCacheImages, error);
        }
    }];
}


//选择图片
-(void)selectImage:(AMDButton *)sender{
    
    if (sender.selected)
    {//取消选中状态
        sender.selected = NO;
        if ([_selectImageArray containsObject:@(_currentPageControl.currentPage)]) {
            [_selectImageArray removeObject:@(_currentPageControl.currentPage)];
        }
    }else{
        sender.selected = YES;
        if (![_selectImageArray containsObject:@(_currentPageControl.currentPage)]) {
            [_selectImageArray addObject:@(_currentPageControl.currentPage)];
        }
    }

    _currentSelectCountLB.text = [NSString stringWithFormat:@"%lu",(unsigned long)_selectImageArray.count];
    if (_selectImageArray.count>0) {
        _currentSelectCountLB.hidden = NO;
    }else{
        _currentSelectCountLB.hidden = YES;
    }
    //返回选择的索引
    if ([_senderController respondsToSelector:@selector(viewController:object:)]) {
        [(id<AMDControllerTransitionDelegate>)_senderController viewController:self object:@{@"tag":@(_currentPageControl.currentPage),@"type":@"select"}];
    };
}


//确定并返回
-(void)completionSelectImage:(AMDButton*)sender{
    [_senderController.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 保存图片到本地
/**
 图片保存到系统相册
 
 @param image 图片
 */
- (void)savePhotoAlbumWithImage:(UIImage *)image
                     completion:(void (^)(BOOL success, NSError *error))completion
{
    __weak typeof(self) weakself = self;
    // 如果不存在
    if (![weakself _isExistAlbumPhoto]) {
        [weakself _createAlbumPhoto];
    }
    
    // 存储图片
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 寻找指定相册
        PHFetchOptions *otions = [[PHFetchOptions alloc]init];
        otions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle == %@",[weakself _albumPhotoName]];
        PHFetchResult *resault = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:otions];
        if (resault.count > 0) {
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:resault[0]];
            // 请求创建一个Asset
            PHAssetChangeRequest *asset = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            // 使用placeholder 占位图操作(因为为异步存储操作)
            PHObjectPlaceholder *placeholder = asset.placeholderForCreatedAsset;
            [request insertAssets:@[placeholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        }
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //        NSLog(@" 保存成功:%i ",success);
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success, error);
        });
    }];
}

#pragma mark - 相册相关
// 是否存在 应用 相册
- (BOOL)_isExistAlbumPhoto
{
    PHFetchResult<PHCollection *> *list = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    __block BOOL resault = NO;
    [list enumerateObjectsUsingBlock:^(PHCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *colletion = (PHAssetCollection *)obj;
        if ([colletion.localizedTitle isEqual:[self _albumPhotoName]]) {
            resault = YES;
        }
    }];
    return resault;
}

// 创建相册
- (void)_createAlbumPhoto
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:[self _albumPhotoName]];
    } error:nil];
}


// 相册名称
- (NSString *)_albumPhotoName
{
    // 默认应用名称
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return name;
}

-(void)invoImageCurrentIndex:(NSInteger)index{
    if (index > 0) {
        [_currentScrollView.superview layoutIfNeeded];
        [_currentScrollView setContentOffset:CGPointMake(index*SScreenWidth, 0) animated:NO];
    }
}

@end


