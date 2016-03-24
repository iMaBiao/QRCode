//
//  MBCreateController.m
//  QRCode
//
//  Created by biao on 16/3/24.
//  Copyright © 2016年 biao. All rights reserved.
//

#import "MBCreateController.h"
#import <CoreImage/CoreImage.h>

@interface MBCreateController ()
@property(nonatomic,weak)UIImageView *imageView;
@end

@implementation MBCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 150, 200, 200)];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"生成" forState:UIControlStateNormal];
    button.frame  = CGRectMake(130, 460, 100, 50);
    button.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(create2Dbarcode) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  生成二维码
 */
- (void)create2Dbarcode{
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString  = @"https://github.com/iMaBiao";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.显示二维码
    //    self.imageView.image = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(outputImage)];
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
