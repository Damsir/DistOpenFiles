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

- (void)openFileWithName:(NSString *)name filePath:(NSString *)filePath fileId:(NSString *)fileId local:(BOOL)local {
    FileViewController *fileViewController = [[FileViewController alloc] initWithFileName:name filePath:filePath fileId:fileId local:local];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fileViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
