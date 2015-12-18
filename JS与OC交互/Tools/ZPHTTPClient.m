//
//  ZPHTTPClient.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/14.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPHTTPClient.h"
#import "AFNetworking.h"



@implementation ZPHTTPClient
{
    AFHTTPSessionManager * manager;
}
+ (ZPHTTPClient *)shareClient
{
    static ZPHTTPClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc]init];
    });
    return client;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];

}
- (void)requestWithMethod:(kHTTPMethod)method url:(NSString *)url  pramater:(id)pramater  response:(Block)block{
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_3) {
          url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }else
//    {
//        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
  
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    switch (method) {
        case get:
        {
           NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
               if (error) {
                   block(error,nil);
               }else
               {
                   block(nil,responseObject);
               }
            }];
            [dataTask resume];
        }
            break;
            
        default:
            break;
    }
}
@end
