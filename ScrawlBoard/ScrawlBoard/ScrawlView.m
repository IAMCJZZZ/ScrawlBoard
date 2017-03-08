//
//  ScrawlView.m
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import "ScrawlView.h"

@interface ScrawlView ()

@end

@implementation ScrawlView

- (NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return  _paths;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(0.5, 0.5, 0.5);
        self.pathColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //获取当前上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //渲染所有路径
    for (int i = 0; i < self.paths.count; i++) {
        
        PathAttribute *pathAttribute = [self.paths objectAtIndex:i];
        
        //初始化路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        for (int j = 0; j < pathAttribute.path.count; j++) {
            
            CGPoint point = [[pathAttribute.path objectAtIndex:j]CGPointValue] ;
            
            if (j == 0) {
                CGPathMoveToPoint(path, &CGAffineTransformIdentity, point.x,point.y);
            }else{
                CGPathAddLineToPoint(path, &CGAffineTransformIdentity, point.x, point.y);
            }
        }
        
        //设置path样式
        CGContextSetStrokeColorWithColor(currentContext, pathAttribute.pathColor.CGColor);
        CGContextSetLineWidth(currentContext, pathAttribute.pathWidth);
        //路径添加到ct
        CGContextAddPath(currentContext, path);
        //描边
        CGContextStrokePath(currentContext);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //创建一个路径对象，放到paths里面
    PathAttribute *pathAttribute = [[PathAttribute alloc]init];
    
    pathAttribute.pathColor = self.pathColor;
    pathAttribute.pathWidth = self.pathWidth;
    pathAttribute.path = [NSMutableArray array];
    
    [self.paths addObject:pathAttribute];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取当前路径
    PathAttribute *pathAttribute = [self.paths lastObject];
    //获取移动到的点
    CGPoint movePoint = [[touches anyObject]locationInView:self];
    //收集路径上所有的点
    [pathAttribute.path addObject:[NSValue valueWithCGPoint:movePoint]];
    
    //苹果要求我们调用UIView类中的setNeedsDisplay方法，则程序会自动调用drawRect方法进行重绘
    [self setNeedsDisplay];
}

@end


#pragma mark - PathAttribute

@implementation PathAttribute

//呵呵哒

@end









