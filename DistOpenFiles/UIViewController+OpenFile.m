//
//  UIViewController+ShowFileDetail.m
//  OpenFileExample
//
//  Created by Dist on 17/4/20.
//  Copyright © 2017年 dist. All rights reserved.
//

#import "UIViewController+OpenFile.h"
#import "FileViewController.h"

@implementation UIViewController (OpenFile)

- (void)openFileWithName:(NSString *)name filePath:(NSString *)filePath materialId:(NSString *)materialId local:(BOOL)local
{
    FileViewController *fileViewController = [[FileViewController alloc] initWithFileName:name filePath:filePath materialId:materialId local:local];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fileViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
