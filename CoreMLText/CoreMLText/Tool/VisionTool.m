//
//  VisionTool.m
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "VisionTool.h"
#import <Vision/Vision.h>
#import <objc/runtime.h>
typedef void(^CompletionHandler)(VNRequest * _Nullable request, NSError * _Nullable error);
@interface VisionTool()
@end
@implementation VisionTool
/// 转换坐标与大小
+ (CGRect)convertRect:(CGRect)oldRect imageSize:(CGSize)imageSize{
    CGFloat w = oldRect.size.width*imageSize.width;
    CGFloat h = oldRect.size.height*imageSize.height;
    CGFloat x = oldRect.origin.x * imageSize.width;
    CGFloat y = imageSize.height - (oldRect.origin.y * imageSize.height) - h;
    
    return CGRectMake(x, y, w, h);
}
#pragma mark******识别图片
+(void)detectImageWithType:(DSDetectionType)type image:(UIImage *)image complete:(delectImageHandler)complete{
    //转换 CIImage
    CIImage *converImage = [[CIImage alloc] initWithImage:image];
    //创建处理图片的请求类
    VNImageRequestHandler *detectRequestHandler=[[VNImageRequestHandler alloc] initWithCIImage:converImage options:@{}];
    //创建BaseRequest
    VNImageBasedRequest *detectRequest = [[VNImageBasedRequest alloc] init];
    CompletionHandler completionHandler = ^(VNRequest *request, NSError * _Nullable error) {
        NSArray *observations = request.results;
        [self handleImageWithType:type image:image observations:observations complete:complete];
    };
    switch (type) {
        case DSDetectionTypeFace:
            detectRequest=[[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:completionHandler];
            break;
            
       case DSDetectionTypeLandmark:
            detectRequest=[[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:completionHandler];
            break;
        case DSDetectionTypeTextRectangles:
            detectRequest=[[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:completionHandler];
            [detectRequest setValue:@(YES) forKey:@"reportCharacterBoxes"];
            break;
        default:
            break;
    }
    //发送识别请求
    [detectRequestHandler performRequests:@[detectRequest] error:nil];
}

+(void)handleImageWithType:(DSDetectionType)type image:(UIImage *)image observations:(NSArray*)observations complete:(delectImageHandler)complete{
    switch (type) {
             //人脸识别
        case DSDetectionTypeFace:
             [self faceRectangles:observations image:image complete:complete];
            break;
        // 人脸特征
        case DSDetectionTypeLandmark:
            [self faceLandmarks:observations image:image complete:complete];
            break;
        case DSDetectionTypeTextRectangles:
         //文字识别
            break;
        default:
            break;
    }
    
    
}
#pragma mark******处理人脸识别回调
+ (void)faceRectangles:(NSArray *)observations image:(UIImage *_Nullable)image complete:(delectImageHandler _Nullable )complete{
    NSMutableArray *tempArray = @[].mutableCopy;
    DSDetectData *detectData = [[DSDetectData alloc] init];
    for (VNFaceObservation *observation in observations) {

        //是这个图片的比例矩形框
        //observation.boundingBox
        NSValue *ractValue = [NSValue valueWithCGRect:[self convertRect:observation.boundingBox imageSize:image.size]];
        [tempArray addObject:ractValue];
    }
    detectData.faceAllRect=tempArray;
    if (complete) {
        complete(detectData);
    }
}
#pragma mark********人的面部特征的位置
+(void)faceLandmarks:(NSArray *)observations image:(UIImage *_Nullable)image complete:(delectImageHandler _Nullable )complete{
    DSDetectData *detectData=[[DSDetectData alloc] init];
    for (VNFaceObservation *observation in observations) {
        //创建存储特征存储模型
        DSDetectFaceData *facedate=[[DSDetectFaceData alloc] init];
        //获取细节特征
        VNFaceLandmarks2D *landmarks=observation.landmarks;
        [self getAllkeyWithClass:[VNFaceLandmarks2D class] isProperty:YES block:^(NSString *key) {
            if ([key isEqualToString:@"allPoints"]) {
                return;
            }
            // valueForKey 对象取值  region2d 对应细节具体特征
            //NSLog(@"key----%@",key);
            
            VNFaceLandmarkRegion2D *region2d=[landmarks valueForKey:key];
            [facedate setValue:region2d forKey:key];
            [facedate.allPoints addObject:region2d];
        }];
        facedate.observation=observation;
        [detectData.facePoints addObject:facedate];
    }
    if (complete) {
        complete(detectData);
    }
    
}
#pragma mark**********获取对象属性keys
+ (NSArray *)getAllkeyWithClass:(Class)class isProperty:(BOOL)property block:(void(^)(NSString *key))block{
    
    NSMutableArray *keys = @[].mutableCopy;
    unsigned int outCount = 0;
    
    Ivar *vars = NULL;
    objc_property_t *propertys = NULL;
    const char *name;
    
    if (property) {
        propertys = class_copyPropertyList(class, &outCount);
    }else{
        vars = class_copyIvarList(class, &outCount);
    }
    
    for (int i = 0; i < outCount; i ++) {
        
        if (property) {
            objc_property_t property = propertys[i];
            name = property_getName(property);
        }else{
            Ivar var = vars[i];
            name = ivar_getName(var);
        }
        
        NSString *key = [NSString stringWithUTF8String:name];
        block(key);
    }
    free(vars);
    return keys.copy;
}

@end
