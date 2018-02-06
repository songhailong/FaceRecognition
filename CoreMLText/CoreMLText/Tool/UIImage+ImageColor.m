//
//  UIImage+ImageColor.m
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/8.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "UIImage+ImageColor.h"

@implementation UIImage (ImageColor)
//+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
///**生成透明图片*/
//+ (UIImage *)imageFromColor:(UIColor *)color{
//    
//}
/**图片压缩 指定大小*/
- (UIImage *)scaleImage:(CGFloat)width{
    CGFloat height = self.size.height *width/self.size.width;
    //开启图片上下文
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    //画图片
    [self drawInRect:CGRectMake(0, 0, width, height)];
    //得到图片
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *tempData = UIImageJPEGRepresentation(result, 0.5);
    return [UIImage imageWithData:tempData];
}
@end
