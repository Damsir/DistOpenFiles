//
//  FileViewController.h
//  OpenFileExample
//
//  Created by Dist on 2017/7/26.
//  Copyright © 2017年 Dist. All rights reserved.
//  文件查看

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController

/**
 * fileName: 文件名字
 * filePath: 文件地址
 * fileId  : 文件标识
 * local   : 是否是本地文件
 */
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *fileId;
@property (nonatomic,assign) BOOL local;

- (instancetype)initWithFileName:(NSString *)fileName filePath:(NSString *)filePath fileId:(NSString *)fileId local:(BOOL)local;

@end
