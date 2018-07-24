//
//  FileProgressView.h
//  OpenFileExample
//
//  Created by Dist on 2017/7/26.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileProgressView : UIView

@property (nonatomic,assign) float haveFinished;
@property (nonatomic,assign) CGRect rect;

@property (nonatomic,assign) float strokeStart;
@property (nonatomic,assign) float strokeEnd;

@property (nonatomic,assign) float lineWidth;

@end
