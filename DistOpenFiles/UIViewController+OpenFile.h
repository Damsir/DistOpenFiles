//
//  UIViewController+ShowFileDetail.h
//  OpenFileExample
//
//  Created by Dist on 17/4/20.
//  Copyright © 2017年 dist. All rights reserved.
//  读取pdf文件等等

#import <UIKit/UIKit.h>

@interface UIViewController (OpenFile)
/*
 * name    : 文件名 如：文件.pdf
 * filePath: 文件的下载路径
 * fileId  : 文件的Id(唯一标识) 如：8656b3fb-95c5-4855-9b90-90f572fd5d32
 */
- (void)openFileWithName:(NSString *)name filePath:(NSString *)filePath fileId:(NSString *)fileId local:(BOOL)local;

@end
