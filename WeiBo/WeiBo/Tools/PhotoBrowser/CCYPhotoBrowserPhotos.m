//
//  CCYPhotoBrowserPhotos.m
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoBrowserPhotos.h"

@implementation CCYPhotoBrowserPhotos

- (NSString *)description {
    NSArray *keys = @[@"selectedIndex", @"urls", @"parentImageViews"];

    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
