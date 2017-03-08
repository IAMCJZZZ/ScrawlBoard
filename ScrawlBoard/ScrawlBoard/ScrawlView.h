//
//  ScrawlView.h
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1]

@interface ScrawlView : UIView

/**
 所有的路径
 */
@property (nonatomic, strong) NSMutableArray * paths;

/**
 画笔颜色
 */
@property (nonatomic, strong) UIColor * pathColor;

/**
 画笔宽度
 */
@property (nonatomic, assign) CGFloat pathWidth;

@end


/******************************** PathAttribute ***********************************/

@interface PathAttribute : NSObject

/**
 画笔颜色
 */
@property (nonatomic, strong) UIColor * pathColor;

/**
 画笔宽度
 */
@property (nonatomic, assign) CGFloat pathWidth;

/**
 路径
 */
@property (nonatomic, strong) NSMutableArray * path;

@end






