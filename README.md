# ScrawlBoard
#####a practical scrawl board 一个实用的涂鸦板
自定义RGB调整画板背景颜色和画笔颜色，也可以选择相册图片设置为背景图片，可以自定义调整画笔宽度，带有撤销、清除、保存、保存到相册功能
* 撤销 -> 撤销前一步的操作
* 清除 -> 清除画板内所有内容
* 保存 -> 保存当前图片
* 保存相册 -> 把之前保存的图片全部写入手机相册内

#####使用方法（详细用法）
```objective-c
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //创建画板
    if (!self.mainView) {
        self.mainView = [[[UINib nibWithNibName:@"MainView" bundle:[NSBundle mainBundle]]   instantiateWithOwner:self options:nil] lastObject];
        //设置为全屏
        self.mainView.frame = CGRectMake(0, 0, kWidth, kHeight);
        //代理
        self.mainView.delegate = self;
        //设置画笔最大宽度
        self.mainView.pathMaxWidth = 30;

        [self.view addSubview:self.mainView];
    }
}
//实现代理方法
#pragma mark - MainViewDelegate

- (void)openPhotoAlbum
{
    //打开相册
    [self takeFromAlbum];
}

- (void)takeFromAlbum
{
    //详细内容见Demo...
}
```

* 自定义颜色作为画板背景颜色

![颜色背景.png](http://upload-images.jianshu.io/upload_images/1825076-267f74a6d858e5f7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 用图片作为画板背景

![图片背景.png](http://upload-images.jianshu.io/upload_images/1825076-5f938d89e8b5caca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 保存后查看图片

![查看图片.png](http://upload-images.jianshu.io/upload_images/1825076-7155f8e9068d4fad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
