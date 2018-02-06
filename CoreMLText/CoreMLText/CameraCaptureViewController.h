//
//  CameraCaptureViewController.h
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/13.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisionTool.h"
@interface CameraCaptureViewController : UIViewController
/**初始化方法*/
- (instancetype _Nullable )initWithDetectionType:(DSDetectionType)type;
@end
