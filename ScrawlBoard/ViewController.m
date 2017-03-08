//
//  ViewController.m
//  ScrawlBoard
//
//  Created by 耳东米青 on 2017/3/7.
//  Copyright © 2017年 耳东米青. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<MainViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) MainView * mainView;
@property (nonatomic, strong) UIImagePickerController *currentPickerController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.mainView) {
        self.mainView = [[[UINib nibWithNibName:@"MainView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] lastObject];
        self.mainView.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.mainView.delegate = self;
        self.mainView.pathMaxWidth = 30;
        
        [self.view addSubview:self.mainView];
    }
}

#pragma mark - MainViewDelegate

- (void)openPhotoAlbum
{
    //打开相册
    [self takeFromAlbum];
}

- (void)takeFromAlbum
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init] ;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    imagePickerController.allowsEditing = YES;
    [imagePickerController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    self.currentPickerController = imagePickerController;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    
    image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //截取图片的高度和宽度的照片，防止变形
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.width);
    image = [self cropWithImage:image rect:rect];
    
    if (!image)
    {
        [self cancelPicutre];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"获取图片失败，请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self cancelPicutre];
    
    //添加图片到数组内
    self.mainView.backImage = image;
}

- (void)cancelPicutre
{
    [self.currentPickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)cropWithImage:(UIImage *)image rect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:1
                                    orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
