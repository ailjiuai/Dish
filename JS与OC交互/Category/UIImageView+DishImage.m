//
//  UIImageView+DishImage.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/17.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "UIImageView+DishImage.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (DishImage)
- (void)setImageWithURL:(NSString *)url placeholde:(UIImage *)image
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image options:SDWebImageRetryFailed |SDWebImageLowPriority |SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"---%@",error);
    }];
}
@end
