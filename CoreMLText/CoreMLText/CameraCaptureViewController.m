//
//  CameraCaptureViewController.m
//  CoreMLText
//
//  Created by 靓萌服饰靓萌服饰 on 2017/12/13.
//  Copyright © 2017年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "CameraCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VisionTool.h"
typedef void(^detectFaceRequestHandler)(VNRequest *request, NSError * _Nullable error);
@interface CameraCaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    //session通道
    AVCaptureSession *_captureSession;
    //输入设备
    AVCaptureDevice *_videoDevice;
    //输入流
    AVCaptureDeviceInput *_videoInput;
    //输出流
    AVCaptureVideoDataOutput *_dataOutput;
    //图层
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
}
@property (nonatomic, strong)NSMutableArray *layers;
@property (nonatomic, strong)NSMutableArray *hats;
@property(nonatomic,assign)DSDetectionType detectionType;
@property (nonatomic, copy) detectFaceRequestHandler faceHandler;
@end

@implementation CameraCaptureViewController

- (instancetype _Nullable )initWithDetectionType:(DSDetectionType)type{
    if (self = [super init]) {
        _detectionType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initCapture
{
    [self addSession];
    [_captureSession beginConfiguration];
    
    [self addVideo];
   // [self addPreviewLayer];
    
    [_captureSession commitConfiguration];
    [_captureSession startRunning];
}
/**
 @abstract
 每当AVCaptureVideoDataOutput实例输出一个新的视频帧时就调用。
 @param 输出
 输出帧的AVCaptureVideoDataOutput实例。
 @param sampleBuffer
 一个CMSampleBuffer对象，包含视频帧数据和关于框架的附加信息，比如它的格式和表示时间。
 @param连接
 从视频接收到的AVCaptureConnection。
 @discussion
 当输出捕获并输出一个新的视频帧、解码或重新编码它的视频设置属性指定的时候，委托就会接收此消息。委托可以与其他api一起使用提供的视频框架进行进一步的处理。这种方法将呼吁指定的调度队列输出sampleBufferCallbackQueue财产。该方法被定期调用，因此必须有效防止捕获性能问题，包括删除帧。
 需要在这个方法的范围之外引用CMSampleBuffer对象的客户机必须对它进行CFRetain，然后在它们完成时将它作为CFRelease。
 注意，为了保持最佳性能，一些示例缓冲区直接引用可能需要由设备系统和其他捕获输入重用的内存池。这常常是未压缩设备本地捕获的情况，在那里，内存块尽可能地复制。如果多个样本缓冲区对这种内存池的引用太长，输入将不再能够将新样本复制到内存中，并且这些样本将被删除。如果您的应用程序从而丢弃样品提供CMSampleBuffer对象保留太久,但它需要对样本数据的访问很长一段时间,考虑将数据复制到新的缓冲区,然后调用CFRelease样本缓冲区如果是以前留存,以便可以重用它引用的内存。
 */
-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //基于图像缓冲区类型。像素缓冲区为图像缓冲区实现内存存储
    
    //CMSampleBufferRef * 特定媒体类型的样本
    
    CVPixelBufferRef BufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    //人脸请求
    VNDetectFaceRectanglesRequest * detectFaceRequest=[[VNDetectFaceRectanglesRequest alloc] init];
VNImageRequestHandler*detectFaceRequestHandler=[[VNImageRequestHandler alloc]initWithCVPixelBuffer:BufferRef options:@{}];
    //发送请求
     [detectFaceRequestHandler performRequests:@[detectFaceRequest] error:nil];
    NSArray *results=detectFaceRequest.results;
    dispatch_async(dispatch_get_main_queue(), ^{
    if (self.detectionType==DSDetectionTypeFaceRectangles) {
        //矩形删除
        for (CALayer *layer in self.layers) {
            [layer removeFromSuperlayer];
        }
        
    }else if (self.detectionType == DSDetectionTypeFaceHat){
        //帽子删除
        for (UIImageView *imageV in self.hats) {
            [imageV removeFromSuperview];
        }
        
    }
        [self.layers removeAllObjects];
        [self.hats removeAllObjects];
        for (VNFaceObservation *observation in results) {
            CGRect oldRect = observation.boundingBox;
            CGFloat w =oldRect.size.width*self.view.frame.size.width;
            CGFloat h = oldRect.size.height *self.view.frame.size.height;
            CGFloat x =oldRect.origin.x*self.view.frame.size.width;
            CGFloat y = self.view.bounds.size.height-h-(self.view.bounds.size.height*oldRect.origin.y);
            // 添加矩形
            CGRect rect = CGRectMake(x, y, w, h);
            CALayer *testLayer = [[CALayer alloc]init];
            testLayer.borderWidth = 2;
            testLayer.cornerRadius = 3;
            testLayer.borderColor = [UIColor redColor].CGColor;
            testLayer.frame = CGRectMake(x, y, w, h);
            
            [self.layers addObject:testLayer];
            
            // 添加帽子
            CGFloat hatWidth = w;
            CGFloat hatHeight = h;
            CGFloat hatX = rect.origin.x - hatWidth / 4 + 3;
            CGFloat hatY = rect.origin.y -  hatHeight;
            CGRect hatRect = CGRectMake(hatX, hatY, hatWidth, hatHeight);
            
            UIImageView *hatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hat"]];
            hatImage.frame = hatRect;
            [self.hats addObject:hatImage];
        }
        if (self.detectionType == DSDetectionTypeFaceRectangles) {
            for (CALayer *layer in self.layers) {
                [self.view.layer addSublayer:layer];
            }
        }else if (self.detectionType==DSDetectionTypeFaceHat){
            
            // 帽子
            for (UIImageView *imageV in self.hats) {
                [self.view addSubview:imageV];
            }
        }
        
    });
    
}
-(void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
}
/// 添加video
- (void)addVideo
{
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addDataOutput];
}
/// 添加videoinput
- (void)addVideoInput
{
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:NULL];
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
}

/// 添加数据输出
- (void)addDataOutput
{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_dataOutput setSampleBufferDelegate:self queue:dispatch_queue_create("CameraCaptureSampleBufferDelegateQueue", NULL)];
    
    if ([_captureSession canAddOutput:_dataOutput]) {
        [_captureSession addOutput:_dataOutput];
        AVCaptureConnection *captureConnection = [_dataOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if ([captureConnection isVideoOrientationSupported]) {
            [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        // 设置输出图片方向
        captureConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
}
/// 获取设备
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}
- (void)addSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    //设置视频分辨率
    //注意,这个地方设置的模式/分辨率大小将影响你后面拍摄照片/视频的大小,
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
}
- (void)getAuthorization
{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoStatus)
    {//已授权
        case AVAuthorizationStatusAuthorized:
            //未授权
        case AVAuthorizationStatusNotDetermined:
            [self initCapture];
            break;
        //未允许授权
        case AVAuthorizationStatusDenied:
       //权限限制
        case AVAuthorizationStatusRestricted:
            [self showMsgWithTitle:@"相机未授权" andContent:@"请打开设置-->隐私-->相机-->快射-->开启权限"];
            break;
        default:
            break;
    }
}
- (void)showMsgWithTitle:(NSString *)title andContent:(NSString *)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil
                                          cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"去开启"];
    [alert show];
    
    alert.delegate = self;
}

- (NSMutableArray *)layers
{
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (NSMutableArray *)hats
{
    if (!_hats) {
        _hats = @[].mutableCopy;
    }
    return _hats;
}




@end
