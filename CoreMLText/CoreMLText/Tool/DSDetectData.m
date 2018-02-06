//
//  DSDetectData.m
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "DSDetectData.h"

@implementation DSDetectData
- (NSMutableArray *)textAllRect{
    if (!_textAllRect) {
        _textAllRect = @[].mutableCopy;
    }
    return _textAllRect;
}
- (NSMutableArray *)faceAllRect
{
    if (!_faceAllRect) {
        _faceAllRect = @[].mutableCopy;
    }
    return _faceAllRect;
}

- (NSMutableArray *)facePoints{
    if (!_facePoints) {
        _facePoints = @[].mutableCopy;
    }
    return _facePoints;
}
@end
@implementation DSDetectFaceData
- (NSMutableArray *)allPoints
{
    if (!_allPoints) {
        _allPoints = @[].mutableCopy;
    }
    return _allPoints;
}
@end
