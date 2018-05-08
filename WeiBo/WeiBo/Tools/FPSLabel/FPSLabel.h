//
//  FPSLabel.h
//  CCYFPSLabel
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPSLabel : UILabel

+ (instancetype)shared;
    
+ (void)show;
    
+ (void)dismiss;

@end
