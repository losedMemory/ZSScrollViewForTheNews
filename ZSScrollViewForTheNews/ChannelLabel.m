//
//  ChannelLabel.m
//  ZSScrollViewForTheNews
//
//  Created by 周松 on 17/1/19.
//  Copyright © 2017年 周松. All rights reserved.
//

#import "ChannelLabel.h"

@implementation ChannelLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:FONT];
    }
    return self;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    CGFloat realScale = 1 + scale / 5;
    self.transform = CGAffineTransformMakeScale(realScale, realScale);
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_fillColor set];
    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    //向当前绘图环境所创建的内存中的图片上填充一个矩形，绘制使用指定的混合模式。
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
 

}





@end
