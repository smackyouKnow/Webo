//
//  CCYPhotoViewController.m
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoViewController.h"
#import "CCYPhotoProgressView.h"
#import <YYWebImage/YYWebImage.h>
//#import <SDWebImage/UIImageView+WebCache.h>
@interface CCYPhotoViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)CCYPhotoProgressView *progressView;

@end

@implementation CCYPhotoViewController
{
    UIScrollView *_scrollView;
    YYAnimatedImageView *_imageView;
    
    NSURL *_url;
    //    NSInteger _photoIndex;
    UIImage *_placeholder;
}

+ (instancetype)viewWithURLString:(NSString *)urlString photoIndex:(NSInteger)photoIndex placeholder:(UIImage *)placeholder {
    return [[self alloc] initWithURLString:urlString photoIndex:photoIndex placeholder:placeholder];
}

- (instancetype)initWithURLString:(NSString *)urlString photoIndex:(NSInteger)photoIndex placeholder:(UIImage *)placeholder {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"/bmiddle/" withString:@"/large/"];
        _url = [NSURL URLWithString:urlString];
        _photoIndex = photoIndex;
        _placeholder = [UIImage imageWithCGImage:placeholder.CGImage scale:1.0 orientation:placeholder.imageOrientation];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self loadImage];
    
}


- (void)setupUI {
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.rootViewController.view.bounds];
    [self.view addSubview:_scrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    NSLog(@"%@", NSStringFromCGRect(_scrollView.frame));
    
    //展位图(正在加载显示的缩略图)
    _imageView = [[YYAnimatedImageView alloc]initWithImage:_placeholder];
    _imageView.center = self.view.center;
    [_scrollView addSubview:_imageView];
    
    //进度图
    _progressView = [[CCYPhotoProgressView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _progressView.center = self.view.center;
    [self.view addSubview:_progressView];
    _progressView.progress = 1.0;
    
    //设置缩放限制
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.delegate = self;
}

//加载图片
- (void)loadImage {

    [_imageView yy_setImageWithURL:_url placeholder:_placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.progress = (float)receivedSize / expectedSize;
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image == nil) {
            return;
        }

        [self setImagePosition:image];
    }];

    
//    [_imageView sd_setImageWithURL:_url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        self.progressView.progress = (float)receivedSize / expectedSize;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image == nil) {
//            return ;
//        }
//
//        [self setImagePosition:image];
//    }];
    
   
}


//设置图片的位置
- (void)setImagePosition:(UIImage *)image {
    CGSize size = [self imageSizeWithScreen:image];
    
    _imageView.frame = CGRectMake(0, self.scrollView.bounds.origin.y, size.width, size.height);
    _scrollView.contentSize = size;
    
    //短图的情况,将它放在中间
    if (size.height < _scrollView.bounds.size.height) {
        CGFloat offSetY = (_scrollView.bounds.size.height - size.height) / 2.0;
        _scrollView.contentInset = UIEdgeInsetsMake(offSetY, 0, offSetY, 0);
    }
}

//获取图片高度
- (CGSize)imageSizeWithScreen: (UIImage *)image {
    CGSize size = [UIScreen mainScreen].bounds.size;
    size.height = image.size.height * size.width / image.size.width;
    
    return size;
}

#pragma mark - UIScrollViewDelegate
//实现放大缩小必须实现的方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end
