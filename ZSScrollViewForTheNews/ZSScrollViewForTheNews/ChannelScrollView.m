//
//  ChannelScrollView.m
//  ZSScrollViewForTheNews
//
//  Created by 周松 on 17/1/19.
//  Copyright © 2017年 周松. All rights reserved.
//

#import "ChannelScrollView.h"
#import "ChannelLabel.h"

@interface ChannelScrollView ()

@end
@implementation ChannelScrollView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.channelLabel = [[ChannelLabel alloc]initWithFrame:CGRectMake(0, 0, ITEMWIDTH, ITEMHEIGHT)];
        [self addSubview:self.channelLabel];
    }
    return self;
}






@end
