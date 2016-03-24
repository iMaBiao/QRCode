//
//  MBScanController.m
//  QRCode
//
//  Created by biao on 16/3/24.
//  Copyright © 2016年 biao. All rights reserved.
//

#import "MBScanController.h"
#import <AVFoundation/AVFoundation.h>
@interface MBScanController ()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic,weak)AVCaptureSession *session;

@property(nonatomic,weak)AVCaptureVideoPreviewLayer *layer;

@end

@implementation MBScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"扫描" forState:UIControlStateNormal];
    button.frame  = CGRectMake(130, 460, 100, 50);
    button.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(sacn2Dbarcode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sacn2Dbarcode{
    //1、创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    self.session = session;
    
    //2 添加输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    //3 添加输出数据
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [session addOutput:output];
    
    //3.1 设置输入元数据类型（类型是二维码）
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //4  添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //    layer.frame = self.view.bounds;
    layer.frame = CGRectMake(30, 150, 300, 300);
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    //5 开始扫描
    [self.session startRunning];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        //object为返回的数据
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        
        NSLog(@"%@",object.stringValue);
        //2 停止扫描
        [self.session stopRunning];
        
        //3 将预览图层移除
        [self.layer removeFromSuperlayer];
        
        
    }else{
        NSLog(@"没有扫描到数据");
    }
}

@end
