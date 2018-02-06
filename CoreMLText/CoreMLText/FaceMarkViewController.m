//
//  FaceMarkViewController.m
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/6.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "FaceMarkViewController.h"
#import "VisionTool.h"
#import "DSViewTool.h"
#import "DSDetectData.h"
#import "UIImage+ImageColor.h"

@interface FaceMarkViewController ()
@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, assign) DSDetectionType detectionType;
@end

@implementation FaceMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.showImageView];
    _showImageView.backgroundColor=[UIColor redColor];
    UIImage *image=[UIImage imageNamed:@"face.png"];
     //转换CIImage
    [self detectFace:image];
    //_showImageView.image=image;
    //CIImage *converImage=[[CIImage alloc] initWithImage:image];
    //设置回调
//    CompletionHandler completionHandler = ^(VNRequest *request, NSError * _Nullable error) {
//        NSArray *observations = request.results;
//        [self handleImageWithType:type image:image observations:observations complete:complete];
//    };
   
}
-(void)detectFace:(UIImage *)image{
    UIImage *localImage = [image scaleImage:SCREEN_WIDTH];
    [self.showImageView setImage:localImage];
//    NSLog(@"%zd----%zd",localImage.size.width,localImage.size.height);
    self.showImageView.frame= CGRectMake(0, 64,localImage.size.width, localImage.size.height);
    self.detectionType=DSDetectionTypeFace;
    [VisionTool detectImageWithType:self.detectionType image:localImage complete:^(DSDetectData *detectDate) {
        switch (self.detectionType) {
            case DSDetectionTypeFace:
                for (NSValue *rectVaue in detectDate.faceAllRect) {
                    [self.showImageView addSubview:[DSViewTool getRectViewWithFrame:rectVaue.CGRectValue]];
                }
                break;

            case DSDetectionTypeLandmark:
                for (DSDetectFaceData *facedate in detectDate.facePoints) {
                    
                    UIImage *image1=[DSViewTool drawImage:localImage observation:facedate.observation pointArray:facedate.allPoints];
                    NSLog(@"imageiii--%@",image1);
                    self.showImageView.image=[DSViewTool drawImage:localImage observation:facedate.observation pointArray:facedate.allPoints];
                }
                break;

            default:
                break;
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.width)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.backgroundColor = [UIColor orangeColor];
    }
    return _showImageView;
}



@end
