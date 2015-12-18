//
//  ZPHTTPClient.h
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/14.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block)(NSError *error,id responese);
typedef enum
{
    get ,
    post
    
} kHTTPMethod;

@interface ZPHTTPClient : NSObject
@property (nonatomic,assign)kHTTPMethod method;
+ (ZPHTTPClient *)shareClient;
- (void)requestWithMethod:(kHTTPMethod)method url:(NSString *)url  pramater:(id)pramater response:(Block)block;
@end
