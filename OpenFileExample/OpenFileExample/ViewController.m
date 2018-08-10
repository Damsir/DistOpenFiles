//
//  ViewController.m
//  OpenFileExample
//
//  Created by 吴定如 on 2018/7/23.
//  Copyright © 2018年 Dist. All rights reserved.
//

#import "ViewController.h"
#import "DistOpenFile.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = self.view.center;
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clicked
{
    [self openFileWithName:@"阿里巴巴Java开发手册.pdf" filePath:@"http://61.133.111.94:82/LYYD/Temp/Materials/380/2984.pdf" materialId:@"1" local:NO];
//    [self openFileWithName:@"word文件.xlsx" filePath:@"http://192.168.1.36/JRYDService/Temp/Materials/1328/17503..xlsx" materialId:@"1" local:NO];
//    http://192.168.1.36/JRYDService/Temp/Materials/1328/17503..xlsx
//    [self openFileWithName:@"阿里巴巴Java开发手册.jpg" filePath:@"http://61.133.111.94:82/LYYD/Temp/Materials/165/633.jpg" materialId:@"1" local:NO];
    //[self openFileWithName:@"阿里巴巴Java开发手册.dwg" filePath:@"http://61.133.111.94:82/LYYD/Temp/Materials/165/2904.dwg" materialId:@"1" local:NO];
    //http://61.133.111.94:82/LYYD/Temp/Materials/165/632.pdf
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
