//
//  PhotoView.h
//  ImageBrowser
//
//  Created by Dist on 16/9/1.
//  Copyright © 2016年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilePhotoView : UIView

/** 父视图 */
@property(nonatomic,strong)  UIScrollView *scrollView;

/** 图片视图 */
@property(nonatomic, strong) UIImageView *imageView;

/**
 *  传具体图片
 */
- (void)showImageFilePath:(NSString *)filePath;

@end
