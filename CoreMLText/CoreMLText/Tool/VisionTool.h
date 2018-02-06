//
//  VisionTool.h
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSDetectData.h"
#import <UIKit/UIKit.h>
typedef void (^delectImageHandler)(DSDetectData * detectDate);
typedef NS_ENUM(NSInteger,DSDetectionType) {
    DSDetectionTypeFace,     // 人脸识别
    DSDetectionTypeLandmark, // 特征识别
    DSDetectionTypeTextRectangles,  // 文字识别
    DSDetectionTypeFaceHat,
    DSDetectionTypeFaceRectangles
};
@interface VisionTool : NSObject
//转换坐标
+ (CGRect)convertRect:(CGRect)oldRect imageSize:(CGSize)imageSize;
/**
 识别图片
 */
+(void)detectImageWithType:(DSDetectionType)type image:(UIImage *)image complete:(delectImageHandler)complete;
@end
