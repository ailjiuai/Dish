//
//  ZPCoverView.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/16.
//  Copyright © 2015年 zp. All rights reserved.
//
#define kAlpha 0.6
#import "ZPCoverView.h"

@implementation ZPCoverView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.alpha = kAlpha;
    }
    return self;
}

+ (id)cover
{
    return [[self alloc]init];
}
- (void)reset
{
    self.alpha = kAlpha;
}
+ (id)coverWithTarget:(id)target action:(SEL)action
{
    ZPCoverView *cover = [self cover];
    
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    
    return cover;
}
@end
