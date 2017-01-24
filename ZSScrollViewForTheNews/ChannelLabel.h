//
//  ChannelLabel.h
//  ZSScrollViewForTheNews
//
//  Created by 周松 on 17/1/19.
//  Copyright © 2017年 周松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelLabel : UILabel

@property (nonatomic,assign) CGFloat scale;  //缩放比

@property (nonatomic,strong) NSArray *channelArray;

@property (nonatomic,strong) UIColor *fillColor;//填充色

@property (nonatomic,assign) CGFloat progress;//进度

@end
