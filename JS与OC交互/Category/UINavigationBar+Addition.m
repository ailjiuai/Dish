//
//  UINavigationBar+Addition.m
//  LearnDish
//
//  Created by iLogiEMAC on 15/12/25.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "UINavigationBar+Addition.h"
#import <objc/runtime.h>

static char * overlayKey;
@implementation UINavigationBar (Addition)
- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
        
        self.overlay =[[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        //防止事件截获
        self.overlay.userInteractionEnabled = NO;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}
@end
