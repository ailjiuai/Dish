//
//  ViewController.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/14.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "ZPHTTPClient.h"
#import "ZPArticle.h"
#import "OC-SW-Bridege.h"
#import "MBProgressHUD.h"
@interface ViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
{
    BOOL isStatusHidden;
    UIWebView * _webView;
    
    WKWebView * wkWebView;
   
}
@property (nonatomic,weak)IBOutlet NSLayoutConstraint * statusBarTopConstrait;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
//    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
         _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        [[_webView scrollView] setDecelerationRate:UIScrollViewDecelerationRateNormal];
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.delegate = self;
        _webView.delegate = self;
        
         [self.view addSubview:_webView];
//    }else
//    {
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
//        wkWebView= [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
//        wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
//        wkWebView.scrollView.scrollIndicatorInsets = wkWebView.scrollView.contentInset;
//        [self.view addSubview:wkWebView];
//    }
    [MBProgressHUD showHUDAddedTo:_webView animated:YES];
    [[ZPHTTPClient shareClient] requestWithMethod:get url:_htmlURL pramater:nil response:^(NSError *error, id responese) {

        NSData * data = responese;
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           TFHpple * hpple = [[TFHpple alloc]initWithHTMLData:data];
           ZPArticle * article = [[ZPArticle alloc]init];
           
           [article parseWithHpple:hpple   originHtml:_htmlURL complete:^{
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (_webView) {
                       [_webView loadHTMLString:[article toHTML] baseURL:[[NSBundle mainBundle] bundleURL]];
                   }else if (wkWebView) {
                       [wkWebView loadHTMLString:[article toHTML] baseURL:[[NSBundle mainBundle] bundleURL]];
                   }
                   
               });
           }];
          
       });
    

    }];
    

    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        return YES;
    }
    
    if ([request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"]) {
        
//        NSData * data = [[ZPImageCache shareImageCache] memoryCacheWithForkey:request.URL.absoluteString];
//        UIImage * image = [UIImage imageWithData:data];
//        UIImage *image = [self queryCachedImageForKey:query];
//        if (!image) {
//            return NO;
//        }
        
//        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//        imageInfo.image = image;
//        
//        JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                               initWithImageInfo:imageInfo
//                                               mode:JTSImageViewControllerMode_Image
//                                               backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
//        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
        
//        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
//        imageView.frame = CGRectMake(30, 100, 200, 400);
//        [self.view addSubview:imageView];
        return NO;
    }
    
//    PRBrowserViewController *vc = [[PRBrowserViewController alloc] init];
//    vc.request = request;
//    [self.stackController pushViewController:vc animated:YES];
    return NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
      [MBProgressHUD hideHUDForView:webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"error---%@",error);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSLog(@"---%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > -44) {
//        if ([UIApplication sharedApplication].isStatusBarHidden) {
//            return;
//        }
//        [UIView animateWithDuration:0.1 animations:^{
//           
//           
//            // pull up
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//            
//        }];
//    }else
//    {
//        if (![UIApplication sharedApplication].isStatusBarHidden) {
//            return;
//        }
//        [UIView animateWithDuration:0.1 animations:^{
//        // pull up
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//            
//        }];
//    }
//    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
