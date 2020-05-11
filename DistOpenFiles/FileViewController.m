//
//  FileViewController.m
//  OpenFileExample
//
//  Created by Dist on 2017/7/26.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "FileViewController.h"
#import "FileProgressView.h"
#import "FilePhotoView.h"
#import <WebKit/WebKit.h>
#import <AFNetworking/AFNetworking.h>

@interface FileViewController () <UIGestureRecognizerDelegate>

/******************* view *******************/
@property (nonatomic, strong) FileProgressView *progressView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) FilePhotoView *photoView;
@property (nonatomic, strong) UILabel *dwgLabel;

@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSURLSessionDownloadTask  *downloadTask;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
// navigation bar
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *reloadButton;
//status bar
@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;
@property (nonatomic, strong) NSTimer *delayHiddenNavTimer;
@property (nonatomic, assign) BOOL statusHidden;

@end

@implementation FileViewController

- (instancetype)initWithFileName:(NSString *)fileName filePath:(NSString *)filePath materialId:(NSString *)materialId local:(BOOL)local {
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.filePath = filePath;
        self.materialId = materialId;
        self.local = local;
        self.statusHidden = YES;
        if (local) {
            self.localPath = filePath;
        }
    }
    return self;
}

- (void)dealloc {
    if (_delayHiddenNavTimer) {
        [_delayHiddenNavTimer invalidate];
        _delayHiddenNavTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    //    self.extendedLayoutIncludesOpaqueBars = YES;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // config scrollView insets
    [self configScrollViewInsets];
    // config subView
    [self configNavigationBar];
    [self configSubView];
    [self addGesture];
    // download file
    if (self.local || [[NSFileManager defaultManager] fileExistsAtPath:self.localPath]) {
        [self openFile];
    } else {
        [self downloadFile];
    }
    // delay hidden navi
    _delayHiddenNavTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(hiddenNavi) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
    // Stop all animations on nav bar
    [self.navigationController.navigationBar.layer removeAllAnimations];
    // If a timer exists then cancel and release
    if (_delayHiddenNavTimer) {
        [_delayHiddenNavTimer invalidate];
        _delayHiddenNavTimer = nil;
    }
}

- (void)configScrollViewInsets {
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)configNavigationBar {
    self.title = self.fileName;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.reloadButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.navigationItem.rightBarButtonItems = @[item2, item1];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    //    navBar.translucent = YES;
    //    navBar.barStyle = UIBarStyleBlack;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)configSubView {
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.dwgLabel];
    
    // addConstraints
    [self addConstraints];
}

- (void)addGesture {
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNavi)];
    ges.delegate = self;
    ges.numberOfTapsRequired = 1;
    ges.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:ges];
    // 手势冲突解决
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    doubleTapGesture.delegate = self;
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapGesture];
    // 这句话的意思就是当后面的手势识别失败的时候,才执行前面的手势
    [ges requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)hiddenNavi {
    // If a timer exists then cancel and release
    if (_delayHiddenNavTimer) {
        [_delayHiddenNavTimer invalidate];
        _delayHiddenNavTimer = nil;
    }
    //BOOL hidden = self.navigationController.navigationBarHidden;
    self.statusHidden = [UIApplication sharedApplication].statusBarHidden;
    BOOL animated = YES;
    CGFloat animationDuration = (animated ? 0.35 : 0);
    // Non-view controller based
    [[UIApplication sharedApplication] setStatusBarHidden:!self.statusHidden withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
    [UIView animateWithDuration:animationDuration animations:^(void) {
        [self setNeedsStatusBarAppearanceUpdate];
        CGFloat alpha = !self.statusHidden ? 0 : 1;
        // Nav bar slides up on it's own on iOS 7+
        [self.navigationController.navigationBar setAlpha:alpha];
    } completion:^(BOOL finished) {}];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return !_statusHidden;
}

- (void)addConstraints {
    self.progressView.bounds = CGRectMake(0, 0, 150, 150);
    self.progressView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    self.photoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.wkWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.dwgLabel sizeToFit];
    self.dwgLabel.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
}

- (void)viewDidLayoutSubviews {
    self.progressView.bounds = CGRectMake(0, 0, 150, 150);
    self.progressView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    self.photoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.wkWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.dwgLabel sizeToFit];
    self.dwgLabel.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.downloadTask cancel];
}

#pragma mark - getter

- (FileProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[FileProgressView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _progressView.center = self.view.center;
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _progressView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [WKWebView new];
        //[_wkWebView setBackgroundColor:[UIColor blackColor]];
        [_wkWebView setHidden:YES];
//        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}

- (FilePhotoView *)photoView {
    if (!_photoView) {
        _photoView = [FilePhotoView new];
        [_photoView setBackgroundColor:[UIColor blackColor]];
        [_photoView setHidden:YES];
    }
    return _photoView;
}

- (UILabel *)dwgLabel {
    if (!_dwgLabel) {
        _dwgLabel = [UILabel new];
        [_dwgLabel setText:@"若要打开文件，请单击右上角“刷新”按钮。"];
        [_dwgLabel setFont:[UIFont systemFontOfSize:16]];
        [_dwgLabel setTextColor:[UIColor blackColor]];
        [_dwgLabel setHidden:YES];
    }
    return _dwgLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        //[_closeButton sizeToFit];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithRed:34.0/255.0 green:152.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [_closeButton setTitleColor:[UIColor colorWithRed:34.0/255.0 green:152.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        //[_reloadButton sizeToFit];
        [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor colorWithRed:34.0/255.0 green:152.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [_reloadButton setTitleColor:[UIColor colorWithRed:34.0/255.0 green:152.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        [_reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(openFile) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (NSString *)localPath {
    if (!_localPath) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileLocalPath = [documentPath stringByAppendingPathComponent:@"material"];
        BOOL dictionary;
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileLocalPath isDirectory:&dictionary]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:fileLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _localPath = [NSString stringWithFormat:@"%@/%@.%@",fileLocalPath,self.materialId,self.fileName.pathExtension];
    }
    return _localPath;
}

#pragma mark - download file

- (void)downloadFile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.filePath]];
    __weak __typeof__(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *progress){
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        CGFloat haveFinished = [[NSString stringWithFormat:@"%.2f",[progress fractionCompleted]] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.progressView setHaveFinished:haveFinished];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:self.localPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"%@",[error description]);
        } else {
            [strongSelf downloadFinish];
        }
    }];
    [downloadTask resume];
    self.downloadTask = downloadTask;
}

- (void)downloadFinish {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openFile];
    });
}

- (void)openFile {
    [self.progressView removeFromSuperview];
    self.progressView = nil;
    NSString *fileExt = [self.fileName pathExtension];
    fileExt = [fileExt lowercaseString];
    if ([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"] || [fileExt isEqualToString:@"bmp"] || [fileExt isEqualToString:@"jpeg"]) {
        [self.photoView setHidden:NO];
        self.photoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.photoView showImageFilePath:self.localPath];
    } else if ([fileExt isEqualToString:@"dwg"] || [fileExt isEqualToString:@"zip"] || [fileExt isEqualToString:@"rar"] || [fileExt isEqualToString:@"tif"]) {
        [self.dwgLabel setHidden:NO];
        UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.localPath]];
        self.documentController = documentController;
        [self.documentController presentOptionsMenuFromRect:CGRectMake(455, 440, 100, 100) inView:self.view animated:YES];
    } else if ([fileExt isEqualToString:@"txt"]) {
        self.wkWebView.hidden = NO;
        /**
         * 中文乱码问题(txt)
         */
        NSData *txtData = [NSData dataWithContentsOfFile:self.localPath];
        // 判断是UNICODE编码
        NSString *isUNICODE = [[NSString alloc] initWithData:txtData encoding:NSUTF8StringEncoding];
        // 还是ANSI编码
        NSString *isANSI = [[NSString alloc] initWithData:txtData encoding:-2147482062];
        if (isUNICODE) {
            NSString *retStr = [[NSString alloc] initWithCString:[isUNICODE UTF8String] encoding:NSUTF8StringEncoding];
            NSData *data = [retStr dataUsingEncoding:NSUTF16StringEncoding];
            [data writeToFile:self.localPath atomically:YES];
        } else if(isANSI) {
            NSData *data = [isANSI dataUsingEncoding:NSUTF16StringEncoding];
            [data writeToFile:self.localPath atomically:YES];
        }
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.localPath]]];
        // 自定义一个编码方式
        // [self.webView loadData:txtData MIMEType:@"text/txt" textEncodingName:@"GBK" baseURL:[NSURL fileURLWithPath:self.localPath]];
    } else {
        self.wkWebView.hidden = NO;
        NSURL *url = [NSURL fileURLWithPath:self.localPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.wkWebView loadRequest:request];
    }
}

#pragma mark - 事件传递

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

