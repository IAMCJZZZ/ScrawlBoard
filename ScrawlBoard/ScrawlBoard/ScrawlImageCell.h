//
//  ScrawlImageCell.h
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrawlImageCell;

@protocol ScrawlImageCellDelegate <NSObject>

- (void)didClickedDeleteButtonWithCell:(ScrawlImageCell *)cell;

@end

@interface ScrawlImageCell : UICollectionViewCell

@property (nonatomic, weak) id <ScrawlImageCellDelegate> delegate;

@property (nonatomic, strong) UIImage * image;

@end
