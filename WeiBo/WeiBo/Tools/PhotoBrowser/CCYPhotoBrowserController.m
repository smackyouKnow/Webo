//
//  CCYPhotoBrowserController.m
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoBrowserController.h"
#import "CCYPhotoBrowserPhotos.h"
#import "CCYPhotoViewController.h"
#import "CCYPhotoBrowserAnimator.h"
#import "CCYPhotoProgressView.h"

@interface CCYPhotoBrowserController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong)CCYPhotoBrowserPhotos *photos;
/** 判断是否隐藏状态栏 */
@property (nonatomic, assign)BOOL statusBarHidden;
@property (nonatomic, strong)CCYPhotoBrowserAnimator *animator;
/** 记录当前的控制器 */
@property (nonatomic, strong)CCYPhotoViewController *currentController;
@property (nonatomic, strong)UIButton *pageCountButton;
@property (nonatomic, strong)UILabel *messageLabel;

@end

@implementation CCYPhotoBrowserController

+ (instancetype)photoBrowserWithSelectedIndex:(NSInteger)selectedIndex urls:(NSArray<NSString *> *)urls parentImageViews:(NSArray<UIImageView *> *)parentImageViews {
    return [[self alloc] initWithSelectedIndex:selectedIndex urls:urls parentImageViews:parentImageViews];
}

- (instancetype)initWithSelectedIndex:(NSInteger)selectedIndex urls:(NSArray<NSString *> *)urls parentImageViews:(NSArray<UIImageView *> *)parentImageViews {
    if (self = [super init]) {
        //创建model
        _photos = [[CCYPhotoBrowserPhotos alloc]init];
        _photos.selectedIndex = selectedIndex;
        _photos.urls = urls;
        _photos.parentImageViews = parentImageViews;
        
        _statusBarHidden = NO;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        _animator = [CCYPhotoBrowserAnimator animatorWithPhotos:_photos];
        self.transitioningDelegate = _animator;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

//#pragma mark - 生命周期，控制状态栏变化
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    _statusBarHidden = YES;
//    [UIView animateWithDuration:0.25 animations:^{
//        [self setNeedsStatusBarAppearanceUpdate];
//    }];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    _statusBarHidden = NO;
//    [self setNeedsStatusBarAppearanceUpdate];
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}
//
//
//- (BOOL)prefersStatusBarHidden {
//    return _statusBarHidden;
//}

#pragma mark - 设置界面
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    //分页控制器
    UIPageViewController *pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @20}];
    pageController.dataSource = self;
    pageController.delegate = self;
    
    //创建当前点击图片的控制器
    CCYPhotoViewController *viewer = [self viewerWithIndex:_photos.selectedIndex];
    
    [pageController setViewControllers:@[viewer] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.view addSubview:pageController.view];
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    _currentController = viewer;
    
    //手势识别
    self.view.gestureRecognizers = pageController.gestureRecognizers;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveGesture:)];
    [self.view addGestureRecognizer:pinch];
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveGesture:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.view addGestureRecognizer:longPress];
    
    pinch.delegate = self;
    rotate.delegate = self;
    
    //分页按钮
    _pageCountButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    CGPoint center = self.view.center;
    center.y = _pageCountButton.bounds.size.height;
    _pageCountButton.center = center;
    
    _pageCountButton.layer.cornerRadius = 6;
    _pageCountButton.layer.masksToBounds = YES;
    
    _pageCountButton.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    //设置按钮文字
    [self setPageButtonIndex:_photos.selectedIndex];
    [self.view addSubview:_pageCountButton];
    
    //提示标签(默认隐藏)
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    _messageLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.layer.cornerRadius = 6;
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.transform = CGAffineTransformMakeScale(0, 0);
    _messageLabel.center = self.view.center;
    [self.view addSubview:_messageLabel];
}

#pragma mark - 手势监听方法
//点击
- (void)tapGesture {
    _animator.fromImageView  = _currentController.imageView;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//旋转和捏合
- (void)interactiveGesture:(UIGestureRecognizer *)gesture {
    //放大就隐藏状态栏
    _statusBarHidden = (_currentController.scrollView.zoomScale > 1.0);
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (_statusBarHidden) {
        self.view.backgroundColor = [UIColor blackColor];
        self.view.transform = CGAffineTransformIdentity;
        self.view.alpha = 1.0f;
        _pageCountButton.hidden = (_photos.urls.count == 1);
        return;
    }
    
    CGAffineTransform transform = self.view.transform;
    if ([gesture isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gesture;
        CGFloat scale = pinch.scale;
        transform = CGAffineTransformScale(transform, scale, scale);
        pinch.scale = 1.0;
    } else if ([gesture isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer *rotateGesture = (UIRotationGestureRecognizer *)gesture;
        CGFloat rotate = rotateGesture.rotation;
        transform = CGAffineTransformRotate(transform, rotate);
        
        rotateGesture.rotation = 0;
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            _pageCountButton.hidden = YES;
            self.view.backgroundColor = [UIColor clearColor];
            self.view.transform = transform;
            self.view.alpha = transform.a;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            [self tapGesture];
            break;
        default:
            break;
    }
}

- (void)longPressGesture:(UIGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if (_currentController.imageView.image == nil) {
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"保存至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.currentController.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *message = (error == nil) ? @"保存成功" : @"保存失败";
    
    _messageLabel.text = message;
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.messageLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            self.messageLabel.transform = CGAffineTransformMakeScale(0, 0);
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(CCYPhotoViewController *)viewController {
    NSInteger index = viewController.photoIndex;
    
    if (index-- <= 0) {
        return nil;
    }
    return [self viewerWithIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(CCYPhotoViewController *)viewController {
    NSInteger index = viewController.photoIndex;
    
    if (++index >= _photos.urls.count) {
        return nil;
    }
    return [self viewerWithIndex:index];
}

//根据对应的index返回对应的单图控制器
- (CCYPhotoViewController *)viewerWithIndex:(NSInteger)index {
    return [CCYPhotoViewController viewWithURLString:_photos.urls[index] photoIndex:index placeholder:_photos.parentImageViews[index].image];
}

#pragma mark - UIPageViewControllerDelegate
//滚动结束
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    CCYPhotoViewController *viewer = pageViewController.viewControllers[0];
    
    _photos.selectedIndex = viewer.photoIndex;
    _currentController = viewer;
    [self setPageButtonIndex:viewer.photoIndex];
}

//设置按钮文字
- (void)setPageButtonIndex:(NSInteger)index {
    _pageCountButton.hidden = (_photos.urls.count == 1);
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", index + 1] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [attributeText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" / %ld", _photos.urls.count] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]}]];
    
    [_pageCountButton setAttributedTitle:attributeText forState:UIControlStateNormal];
}

@end
