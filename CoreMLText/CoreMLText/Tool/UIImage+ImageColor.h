//
//  UIImage+ImageColor.h
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/8.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import <UIKit/UIKit.h>

@interface UIImage (ImageColor)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage *)imageFromColor:(UIColor *)color;
/**图片压缩 指定大小*/
- (UIImage *)scaleImage:(CGFloat)width;
@end
