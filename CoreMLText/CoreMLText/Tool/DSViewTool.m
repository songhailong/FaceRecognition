//
//  DSViewTool.m
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "DSViewTool.h"

@implementation DSViewTool


+(UIImage *)drawImage:(UIImage *)source observation:(VNFaceObservation *)observation pointArray:(NSArray *)pointArray{
    UIImage *sourceImage = source;
    for (VNFaceLandmarkRegion2D * landmark2D in pointArray) {
        CGPoint points[landmark2D.pointCount];
        //转换坐标点
        for (int i=0;i<landmark2D.pointCount;i++) {
            //返回的坐标点  是在人脸矩形框上面的坐标点 转换图像的坐标
            CGPoint point = landmark2D.normalizedPoints[i];
            //人脸矩形框
            CGFloat rectwith=sourceImage.size.width* observation.boundingBox.size.width;
            CGFloat rectHeight=sourceImage.size.height*observation.boundingBox.size.height;
            CGPoint p=CGPointMake(point.x*rectwith+observation.boundingBox.origin.x*sourceImage.size.width, point.y*rectHeight+observation.boundingBox.origin.y*sourceImage.size.height);
            
            
            points[i]=p;
            
        }
        //开启图片上下文
        UIGraphicsBeginImageContextWithOptions(sourceImage.size, false, 1);
        //开启上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor greenColor] set];
        CGContextSetLineWidth(context, 2);
        //设置翻转
        CGContextTranslateCTM(context, 0, sourceImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        //设置线类型
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
        // 设置抗锯齿
        CGContextSetShouldAntialias(context, true);
        CGContextSetAllowsAntialiasing(context, true);
        //绘制
        CGRect rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
        CGContextDrawImage(context, rect, sourceImage.CGImage);
        //添加绘制路径
        CGContextAddLines(context, points, landmark2D.pointCount);
        //画线
        CGContextDrawPath(context, kCGPathStroke);
        // 结束绘制
        sourceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return sourceImage;
}

+(UIView *)getRectViewWithFrame:(CGRect)frame{
    UIView *boxView=[[UIView alloc] initWithFrame:frame];
    //透明色
    boxView.backgroundColor = [UIColor clearColor];
    //边框颜色
    boxView.layer.borderColor = [UIColor orangeColor].CGColor;
    boxView.layer.borderWidth = 2;
    return boxView;
}
@end
