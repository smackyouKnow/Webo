//
//  FPSLabel.m
//  CCYFPSLabel
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "FPSLabel.h"

#define kSize CGSizeMake(50, 25)

@implementation FPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _lll;
}

+ (instancetype)shared {
    static FPSLabel *label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (label == nil) {
            label = [[FPSLabel alloc]init];
        }
    });
    return label;
}
    
    
+ (void)show {
    UIWindow * fpsWindow = [UIApplication sharedApplication].keyWindow;
    fpsWindow.backgroundColor = [UIColor clearColor];
    FPSLabel *fpslabel = [FPSLabel shared];
    fpslabel.frame = CGRectMake(20, fpsWindow.bounds.size.height - 100, 100, 30);
    [fpsWindow addSubview:fpslabel];
}
    
+ (void)dismiss {
    [[FPSLabel shared]removeFromSuperview];
}
    
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0  && frame.size.height == 0) {
        frame.size = kSize;
    }
    
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return self;
}

- (void)dealloc {
    [_link invalidate];
}
    
- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}
    
- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 3)];
//    [text setColor:color range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
//    [text setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    self.font = _font;
    [text addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(text.length - 4, 1)];
//    [text setFont:_subFont range:NSMakeRange(text.length - 4, 1)];
    
    self.attributedText = text;
}
    
@end
