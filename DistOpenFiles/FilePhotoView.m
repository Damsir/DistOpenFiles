//
//  PhotoView.m
//  ImageBrowser
//
//  Created by msk on 16/9/1.
//  Copyright © 2016年 msk. All rights reserved.
//

#import "FilePhotoView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FilePhotoView ()<UIScrollViewDelegate>

@end

@implementation FilePhotoView

//-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //添加图片
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        BOOL isCached = [manager cachedImageExistsForURL:[NSURL URLWithString:photoUrl]];
//        if (!isCached) {//没有缓存
//            HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
//            HUD.mode = MBProgressHUDModeDeterminate;
//            
//            [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"ic-zanwu@3x"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
//                HUD.progress = ((float)receivedSize)/expectedSize;
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//                self.imageView.frame=[self caculateOriginImageSizeWith:image];
//                NSLog(@"图片加载完成");
//                if (!isCached) {
//                    [HUD hide:YES];
//                }
//            }];
//        }else{//直接取出缓存的图片，减少流量消耗
//            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photoUrl];
//            self.imageView.frame=[self caculateOriginImageSizeWith:cachedImage];
//            self.imageView.image=cachedImage;
//        }
//    }
//    return self;
//}
//
//-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //添加图片
//        self.imageView.frame=[self caculateOriginImageSizeWith:image];
//        [self.imageView setImage:image];
//    }
//    return self;
//}

- (void)showImageFilePath:(NSString *)filePath {
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    self.imageView.frame = [self caculateOriginImageSizeWith:image];
//    self.imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.imageView.image = image;
}


#pragma mark - UIScrollViewDelegate
/**scroll view处理缩放和平移手势，必须需要实现委托下面两个方法,另外 maximumZoomScale和minimumZoomScale两个属性要不一样*/

// 1.返回要缩放的图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// 让图片保持在屏幕中央，防止图片放大时，位置出现跑偏
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?(self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
    (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,self.scrollView.contentSize.height * 0.5 + offsetY);
}

// 2.重新确定缩放完后的缩放倍数
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}


#pragma mark - 图片的点击，touch事件

// 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(self.scrollView.zoomScale == 1) {
            float newScale = [self.scrollView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [self.scrollView zoomToRect:zoomRect animated:YES];
        } else {
            float newScale = [self.scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [self.scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

// 2手指操作
- (void)handleTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer {
    float newScale = [self.scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - 缩放大小获取方法

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [self.scrollView frame].size.height/scale;
    zoomRect.size.width = [self.scrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [_scrollView setZoomScale:1];
        
        //添加scrollView
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        
        doubleTap.numberOfTapsRequired = 2;//需要点两下
        twoFingerTap.numberOfTouchesRequired = 2;//需要两个手指touch
        
        [_imageView addGestureRecognizer:doubleTap];
        [_imageView addGestureRecognizer:twoFingerTap];
        
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - 计算图片原始高度，用于高度自适应
- (CGRect)caculateOriginImageSizeWith:(UIImage *)image {
    
    CGFloat originImageHeight = [self imageCompressForWidth:image targetWidth:WIDTH].size.height;
    if (originImageHeight >= HEIGHT) {
        originImageHeight=HEIGHT;
    }
    
    CGRect frame = CGRectMake(0, (HEIGHT-originImageHeight)*0.5, WIDTH, originImageHeight);
    
    return frame;
}

/** 指定宽度按比例缩放图片 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
