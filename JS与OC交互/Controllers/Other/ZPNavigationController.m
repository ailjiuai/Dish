//
//  ZPNavigationController.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/16.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPNavigationController.h"

@interface ZPNavigationController ()

@end

@implementation ZPNavigationController

+ (void)initialize
{
    UINavigationBar * bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"topBar"] forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;
}

@end
