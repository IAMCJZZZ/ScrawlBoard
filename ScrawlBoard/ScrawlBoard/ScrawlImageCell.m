//
//  ScrawlImageCell.m
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import "ScrawlImageCell.h"
#import "CJImageBrowser.h"

@interface ScrawlImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ScrawlImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClickAction)];
    [self.imageView addGestureRecognizer:tap];
    
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

- (IBAction)clickDeleteButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickedDeleteButtonWithCell:)]) {
        [self.delegate didClickedDeleteButtonWithCell:self];
    }
}

- (void)imageViewClickAction
{
    [CJImageBrowser showImage:self.imageView];
}


@end
