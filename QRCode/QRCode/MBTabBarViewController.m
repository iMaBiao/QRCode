//
//  MBTabBarViewController.m
//  QRCode
//
//  Created by biao on 16/3/24.
//  Copyright © 2016年 biao. All rights reserved.
//

#import "MBTabBarViewController.h"
#import "MBNavigationController.h"
#import "MBCreateController.h"
#import "MBScanController.h"
@interface MBTabBarViewController ()

@end

@implementation MBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildsVCs];
    
}
- (void)addChildsVCs{
    MBCreateController *create = [[MBCreateController alloc]init];
    [self addChildVC:create title:@"生成二维码"];
    MBScanController *scan = [[MBScanController alloc]init];
    [self addChildVC:scan title:@"扫描二维码"];
    
}
- (void)addChildVC:(UIViewController *)childVc title:(NSString *)title{
    
    MBNavigationController *nav = [[MBNavigationController alloc]initWithRootViewController:childVc];
    childVc.title = title;
    [self addChildViewController:nav];
    
}

@end
