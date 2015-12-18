//
//  ZPCoverView.h
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/16.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPCoverView : UIView
+ (id)cover;
- (void)reset;
+ (id)coverWithTarget:(id)target action:(SEL)action;
@end
