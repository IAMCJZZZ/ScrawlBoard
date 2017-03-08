//
//  MainView.m
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import "MainView.h"
#import "ScrawlView.h"
#import "ScrawlImageCell.h"
#import <Photos/Photos.h>

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface MainView ()<UICollectionViewDelegate,UICollectionViewDataSource,ScrawlImageCellDelegate>

//背景颜色
@property (weak, nonatomic) IBOutlet UISlider *backRedSlider;
@property (weak, nonatomic) IBOutlet UISlider *backGreenSlider;
@property (weak, nonatomic) IBOutlet UISlider *backBlueSlider;
@property (weak, nonatomic) IBOutlet UIView *backColorView;
@property (nonatomic,assign) CGFloat backRedValue;
@property (nonatomic,assign) CGFloat backGreenValue;
@property (nonatomic,assign) CGFloat backBlueValue;

//画笔颜色
@property (weak, nonatomic) IBOutlet UISlider *pathRedSlider;
@property (weak, nonatomic) IBOutlet UISlider *pathGreenSlider;
@property (weak, nonatomic) IBOutlet UISlider *pathBlueSlider;
@property (weak, nonatomic) IBOutlet UIView *pathColorView;
@property (nonatomic,assign) CGFloat pathRedValue;
@property (nonatomic,assign) CGFloat pathGreenValue;
@property (nonatomic,assign) CGFloat pathBlueValue;

//画笔宽度
@property (weak, nonatomic) IBOutlet UISlider *pathWidthSlider;

//画板内容
@property (weak, nonatomic) IBOutlet UIView *scrawlBackView;
@property (weak, nonatomic) IBOutlet UIImageView *scrawlBackImageView;
@property (nonatomic, strong) ScrawlView * scrawlView;

//保存图片
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <UIImage *> * images;
@property (nonatomic, strong) UIActivityIndicatorView * loadingView;

@end

@implementation MainView

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithFrame:self.bounds];
        _loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //创建画板
    ScrawlView * scrawlView = [[ScrawlView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth)];
    
    [self.scrawlBackView addSubview:scrawlView];
    self.scrawlView = scrawlView;
    
    //创建保存的图片列表
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ScrawlImageCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"ScrawlImageCell"];
    
    //设置颜色的初始值
    self.backRedValue = 0.5;
    self.backGreenValue = 0.5;
    self.backBlueValue = 0.5;
    self.pathRedValue = 0;
    self.pathGreenValue = 0;
    self.pathBlueValue = 0;
    
    //设置最大宽度默认值
    self.pathMaxWidth = 20;
}

//设置path初始宽度
- (void)setPathMaxWidth:(CGFloat)pathMaxWidth
{
    _pathMaxWidth = pathMaxWidth;
    
    self.scrawlView.pathWidth = 0.5 * pathMaxWidth;
}

//设置背景图片
- (void)setBackImage:(UIImage *)backImage
{
    _backImage = backImage;
    
    self.scrawlView.backgroundColor = [UIColor clearColor];
    self.scrawlBackImageView.image = backImage;
}

/** 橡皮擦(功能待优化) */
- (IBAction)clickEraserButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.scrawlView.pathColor = self.scrawlView.backgroundColor;
    } else {
        self.scrawlView.pathColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
    }
}

/** 撤销 */
- (IBAction)clickRepealButton:(id)sender
{
    if (self.scrawlView.paths.count > 0) {
        [self.scrawlView.paths removeLastObject];
        [self.scrawlView setNeedsDisplay];
    }
}

/** 清除 */
- (IBAction)clickClearButton:(id)sender
{
    [self.scrawlView.paths removeAllObjects];
    [self.scrawlView setNeedsDisplay];
}

/** 保存当前画板图片 */
- (IBAction)clickSaveButton:(id)sender
{
    if (self.scrawlView.paths.count > 0) {
        [self.images addObject:[self captureImageWithView:self.scrawlBackView rect:CGRectMake(0, 0, kWidth, kWidth)]];
        [self.collectionView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.images.count - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前画板没有内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

/** 打开图片相册 */
- (IBAction)clickImageAlbumButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(openPhotoAlbum)]) {
        [self.delegate openPhotoAlbum];
    }
}

/** 保存所有图片到相册 */
- (IBAction)clickSaveToPhotoAlbumButton:(id)sender
{
    if (self.images.count > 0) {
        
        [self saveImageToPhotoAlbum:self.images];
        
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"没有图片可以保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//iOS8之后加入的，使用稍微复杂一点(需要引入Photos.framework)，但是它允许进行批量的操作，例如添加、修改、删除等。如果要做更近复杂的操作的话，这种方式是比较推荐的方式。（最下面还有一种保存入相册的方式）
- (void)saveImageToPhotoAlbum:(NSArray *)images
{
    [self.loadingView startAnimating];
    
    for (int i = 0; i < self.images.count ; i++) {
        
        UIImage * image = self.images[i];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success && i == self.images.count - 1) {
                
                [self removeLoadingView];
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScrawlImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScrawlImageCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.image = (UIImage *)self.images[indexPath.row];
    
    return cell;
}
//每个section不同的item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}
//定义UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}

#pragma mark - ScrawlImageCellDelegate
//点击删除按钮
- (void)didClickedDeleteButtonWithCell:(ScrawlImageCell *)cell
{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    
    if (indexPath) {
        [self.images removeObjectAtIndex:indexPath.row];
        
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}
//修改画笔宽度
- (IBAction)pathWidthSliderChange:(UISlider *)sender
{
    self.scrawlView.pathWidth = (CGFloat)sender.value * self.pathMaxWidth;
}
- (IBAction)backRedSliderChange:(UISlider *)sender
{
    self.backRedValue = (CGFloat)sender.value;
    self.scrawlView.backgroundColor = RGBCOLOR(self.backRedValue, self.backGreenValue, self.backBlueValue);
    self.backColorView.backgroundColor = RGBCOLOR(self.backRedValue, self.backGreenValue, self.backBlueValue);
}
- (IBAction)backGreenSliderChange:(UISlider *)sender
{
    self.backGreenValue = (CGFloat)sender.value;
    self.scrawlView.backgroundColor = RGBCOLOR(self.backRedValue, self.backGreenValue, self.backBlueValue);
    self.backColorView.backgroundColor = RGBCOLOR(self.backRedValue, self.backGreenValue, self.backBlueValue);
}
- (IBAction)backBlueSliderChange:(UISlider *)sender
{
    self.backBlueValue = (CGFloat)sender.value;
    self.scrawlView.backgroundColor = RGBCOLOR(self.backRedValue, self.backGreenValue, self.backBlueValue);
    self.backColorView.backgroundColor = RGBCOLOR(self.backRedValue, self.backGreenValue, self.backBlueValue);
}
- (IBAction)pathRedSliderChange:(UISlider *)sender
{
    self.pathRedValue = (CGFloat)sender.value;
    self.scrawlView.pathColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
    self.pathColorView.backgroundColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
}
- (IBAction)pathGreenSliderChange:(UISlider *)sender
{
    self.pathGreenValue = (CGFloat)sender.value;
    self.scrawlView.pathColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
    self.pathColorView.backgroundColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
}
- (IBAction)pathBlueSliderChange:(UISlider *)sender
{
    self.pathBlueValue = (CGFloat)sender.value;
    self.scrawlView.pathColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
    self.pathColorView.backgroundColor = RGBCOLOR(self.pathRedValue, self.pathGreenValue, self.pathBlueValue);
}

/** 移除loadingView */
- (void)removeLoadingView
{
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    self.loadingView  = nil;
}

//截取图片
- (UIImage *)captureImageWithView:(UIView *)view rect:(CGRect)rect
{
    CGRect screenRect =  rect;
    
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}



@end


/* 这个也可以保存到相册，使用起来很方便，传入UIImage就可以了，也不需要担心iOS不同版本的问题。唯一缺点就是无法找到对应添加的图片
 - (void)saveImageToPhotoAlbum:(UIImage *)image
 {
 UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
 }
 
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 {
 
 NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
 }
 */










