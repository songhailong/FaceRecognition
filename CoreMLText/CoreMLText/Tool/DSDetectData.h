//
//  DSDetectData.h
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Vision/Vision.h>

//VNFaceLandmarkRegion，该对象作为一个具有里程碑意义的集合，用于定义脸部的特定区域(包括可能所有的地标点)。VNFaceLandmarkRegion是一个抽象基类

@interface DSDetectFaceData : NSObject
@property (nonatomic, strong)VNFaceObservation * _Nullable observation;

@property (nonatomic, strong)NSMutableArray * _Nullable  allPoints;
//面部轮廓
@property(nonatomic,strong)VNFaceLandmarkRegion2D * _Nullable faceContour;
//左眼，右眼
@property(nonatomic,strong)VNFaceLandmarkRegion2D* _Nullable leftEye;
@property(nonatomic,strong)VNFaceLandmarkRegion2D* _Nullable rightEye;
//鼻子，鼻梁
@property(nonatomic,strong)VNFaceLandmarkRegion2D * _Nullable nose;
@property(nonatomic,strong)VNFaceLandmarkRegion2D * _Nullable noseCrest;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable medianLine;
// 外唇，内唇
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable outerLips;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable innerLips;
// 左瞳,右瞳
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable leftPupil;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable rightPupil;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable leftEyebrow;
// 左眉毛，右眉毛
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable rightEyebrow;

@end
@interface DSDetectData : NSObject
// 所有识别的人脸坐标
@property(nonatomic,strong)NSMutableArray * _Nullable  faceAllRect;
//所有识别的文本坐标
@property(nonatomic,strong)NSMutableArray *_Nonnull textAllRect;
//所有识别的特征
@property(nonatomic,strong)NSMutableArray * _Nonnull facePoints;
@end
