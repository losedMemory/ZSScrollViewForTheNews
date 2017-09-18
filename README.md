# ZSScrollViewForTheNews
###效果图
![image](https://github.com/losedMemory/ZSScrollViewForTheNews/blob/master/ZSScrollViewForTheNews/%E5%91%B5%E5%91%B5.gif)
###在滑动到过程中,当前频道的label由大变小,下一个频道由小变大,并且会有一个扫描文字的效果
###其中最重要的代码是对label的drawRect方法的重写
	- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_fillColor set];
    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    //向当前绘图环境所创建的内存中的图片上填充一个矩形，绘制使用指定的混合模式。
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
 
}
这样做还是相对比较简单的,之前遇到一个demo也是实现这样的效果,但是文字大小并没有渐变的效果,因为他是将文字直接绘制到scrollView中,并且第二次绘制,有一个clearColor的view再将文字绘制,才形成了那种效果,其中的精华是[path addClip];这个方法:它所在的context的可见区域就变成了它的“fill area”，接下来的绘制，如果在这个区域外都会被无视,遗憾这样做不能让文字大小变化,至少我还没有想出来,贴一下他的代码,学习

	- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    UIFont *font = [UIFont systemFontOfSize:PGFONT];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName : font ,
                          NSForegroundColorAttributeName : NORMALFONTCOLOR,
                          NSParagraphStyleAttributeName : style
                          };
    //遍历数组
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //计算行高
        CGFloat textTextHeight = [obj boundingRectWithSize: CGSizeMake( ITEMWIDTH , INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: dic context: nil].size.height;
        [obj drawInRect:CGRectMake(idx*ITEMWIDTH, (PGHEIGHT-textTextHeight)/2 , ITEMWIDTH, PGHEIGHT) withAttributes:dic];
    }];
    [[UIColor clearColor] setStroke];
    
    
    CGContextRestoreGState(ref);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bcView.frame];
    
    [path addClip];
    NSDictionary *dic1 = @{NSFontAttributeName : font ,
                           NSForegroundColorAttributeName : SELECTFONTCOLOR,
                           NSParagraphStyleAttributeName : style
                           };
    
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat textTextHeight = [obj boundingRectWithSize: CGSizeMake( ITEMWIDTH , INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: dic context: nil].size.height;
        [obj drawInRect:CGRectMake(idx*ITEMWIDTH, (PGHEIGHT-textTextHeight)/2 , ITEMWIDTH, PGHEIGHT) withAttributes:dic1];
    }];
    CGContextAddPath(ref, path.CGPath);
    [[UIColor clearColor] setStroke];
    CGContextDrawPath(ref, kCGPathStroke);
    
    
    CGContextStrokePath(ref);
    }






	
