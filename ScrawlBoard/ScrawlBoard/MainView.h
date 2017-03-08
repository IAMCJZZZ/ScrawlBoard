//
//  MainView.h
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewDelegate <NSObject>

- (void)openPhotoAlbum;

@end

@interface MainView : UIView

@property (nonatomic, weak) id <MainViewDelegate> delegate;

/**
 画笔最大的宽度（默认20）
 */
@property (nonatomic, assign) CGFloat pathMaxWidth;

/**
 画板背景图片（设置后背景颜色会被覆盖）
 */
@property (nonatomic, strong) UIImage * backImage;

@end
