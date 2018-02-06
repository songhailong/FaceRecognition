//
//  DSViewTool.h
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DSDetectData.h"
@interface DSViewTool : NSObject
/**返回带有标记人脸特征的 的图片*/
+ (UIImage *)drawImage:(UIImage *)source observation:(VNFaceObservation *)observation pointArray:(NSArray *)pointArray;
/**画出脸部的矩形框*/
+ (UIView *)getRectViewWithFrame:(CGRect)frame;
@end
