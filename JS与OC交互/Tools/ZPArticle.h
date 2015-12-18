//
//  ZPArticle.h
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/14.
//  Copyright © 2015年 zp. All rights reserved.
//

typedef void(^Complete)(void);

#import <Foundation/Foundation.h>
@class TFHpple;
@interface ZPArticle : NSObject

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * src;

@property (nonatomic,copy) NSString * content;

@property (nonatomic,copy) NSString * cpcTitle;

@property (nonatomic,copy) NSString * cMethod;
@property (nonatomic,copy) NSString * originHTML;
- (void)parseWithHpple:(TFHpple *)hpple originHtml:(NSString *)htmlURL complete:(Complete)finish;
- (NSString *)toHTML;

@end
