//
//  ZPArticle.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/14.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPArticle.h"
#import "TFHpple.h"
@implementation ZPArticle
- (void)parseWithHpple:(TFHpple *)hpple  originHtml:(NSString *)htmlURL complete:(Complete)finish
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _originHTML = htmlURL;
        TFHppleElement  * element =  [[hpple searchWithXPathQuery:@"//div[@class=\'cp_headerimg_w\']"] firstObject];
        TFHppleElement * titleElement = [[element children] firstObject];
        
        NSDictionary * dic = [titleElement attributes];
        
        //标题
        _title = dic[@"alt"];
        //图片
        _src = dic[@"src"];
        
        //说明
        
        TFHppleElement  * materials =  [[hpple searchWithXPathQuery:@"//div[@class=\'materials\']"] firstObject];
        NSMutableString * str = [NSMutableString string];
        for (TFHppleElement * e in materials.children) {
            if ([e.tagName isEqualToString:@"p"])
            {
                [str appendString:e.text];
            }
        }
        _content = str;
        
        //做法
        //标题
        TFHppleElement  * cpc_h2 =  [[hpple searchWithXPathQuery:@"//div[@class=\'measure\']"] firstObject];
        
        for (TFHppleElement * e in cpc_h2.children ) {
            
            if ([e.attributes[@"class"] isEqualToString:@"cpc_h2"]) {
                _cpcTitle = e.text;
            }
        }
        //步骤1
        TFHppleElement *contentElement = [[hpple searchWithXPathQuery:@"//div[@class=\"editnew edit\"] | //div[@class=\"edit\"]"] firstObject];
         NSString *content = [contentElement raw];
        if (content) {
            
            // 去除内联样式
            
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@" style=\"[^\"]*\"" options:NSRegularExpressionCaseInsensitive error:nil];
            content = [reg stringByReplacingMatchesInString:content options:kNilOptions range:NSMakeRange(0, [content length]) withTemplate:@""];
            
            NSRegularExpression * img = [NSRegularExpression regularExpressionWithPattern:@"<[img]+([^>]*?)[\\s\'\"](.*?)>" options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray * reslt = [img matchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length)];
            
            NSString * finishContent =  content;
            for (NSTextCheckingResult * result in reslt) {
                
                
                NSRange range = result.range;
                NSString * imgURL = [content substringWithRange:range];
                if ([imgURL hasPrefix:@"<img"])
                {
                    NSMutableString * imgFinish = [NSMutableString string];
                    NSArray * imgArrs = [imgURL componentsSeparatedByString:@">"];
                    [imgFinish appendFormat:imgArrs[0]];
                    [imgFinish appendFormat:@"width=\"100%%\" "];
                    [imgFinish appendFormat:@">"];
                    finishContent =    [finishContent stringByReplacingOccurrencesOfString:imgURL withString:imgFinish];
                }
                
            }
            _cMethod = finishContent;
           
        }
         finish();
    });

}
- (NSString *)toHTML
{
    static NSString * const kImageURL = @"<!--image-->";
    static NSString *const kTitlePlaceholder = @"<!-- title -->";
    static NSString *const kSourcePlaceholder = @"<!-- source -->";
    static NSString *const kTimePlaceholder = @"<!-- introduction -->";
    static NSString *const kSummaryPlaceholder = @"<!-- summary -->";
    static NSString *const kContentPlaceholder = @"<!-- content -->";
//    static NSString *const kCSSPlaceholder = @"<!-- css -->";
//    static NSString *const kOriginPlaceholder = @"<!-- origin -->";
    
    static NSString *htmlTemplate = nil;
    
    if (!htmlTemplate) {
        NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"article" withExtension:@"html"];
        htmlTemplate = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString *html = htmlTemplate;
    
//    PRAppSettings *settings = [PRAppSettings sharedSettings];
//    
//    NSString *css;
//    
//    if ([settings isNightMode]) {
//        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"night" withExtension:@"css"];
//        css = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
//    }
//    else {
//        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"day" withExtension:@"css"];
//        css = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
//    }
//    
//    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//        switch (settings.fontSize) {
//            case PRArticleFontSizeSmall:
//                css = [css stringByAppendingString:@"h1{font-size:18px;}.content, summary {font-size: 15px;line-height:22px;}.source, .time{font-size: 11px;}"];
//                break;
//            case PRArticleFontSizeNormal:
//                css = [css stringByAppendingString:@"h1{font-size:20px;}.content, summary {font-size: 17px;line-height:25px;}.source, .time{font-size: 13px;}"];
//                break;
//            case PRArticleFontSizeBig:
//                css = [css stringByAppendingString:@"h1{font-size:24px;}.content, summary {font-size: 20px;line-height:29px;}.source, .time{font-size: 15px;}"];
//                break;
//                
//            default:
//                break;
//        }
//    }
//    else {
//        switch (settings.fontSize) {
//            case PRArticleFontSizeSmall:
//                css = [css stringByAppendingString:@"h1{font-size:28px;}.content, summary {font-size: 20px;line-height:30px;}.source, .time{font-size: 15px;}"];
//                break;
//            case PRArticleFontSizeNormal:
//                css = [css stringByAppendingString:@"h1{font-size:36px;}.content, summary {font-size: 24px;line-height:36px;}.source, .time{font-size: 17px;}"];
//                break;
//            case PRArticleFontSizeBig:
//                css = [css stringByAppendingString:@"h1{font-size:44px;}.content, summary {font-size: 32px;line-height:46px;}.source, .time{font-size: 20px;}"];
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//    if (settings.inclineSummary) {
//        css = [css stringByAppendingString:@"summary {font-style: italic;}"];
//    }
    
//    html = [html stringByReplacingOccurrencesOfString:kCSSPlaceholder withString:css];
    if (_src) {
        html = [html stringByReplacingOccurrencesOfString:kImageURL withString:_src];
    }
    if (_title) {
        html = [html stringByReplacingOccurrencesOfString:kTitlePlaceholder withString:self.title];
    }
   
    if (_content) {
        html = [html stringByReplacingOccurrencesOfString:kTimePlaceholder withString:_content];
    }
    if (_cpcTitle) {
        html = [html stringByReplacingOccurrencesOfString:kSummaryPlaceholder withString:_cpcTitle];
    }
    if (_cMethod) {
        html = [html stringByReplacingOccurrencesOfString:kContentPlaceholder withString:_cMethod];
        
//        if (settings.isImageWIFIOnly && ![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
//            for (NSString *imgSrc in self.imgSrcs) {
//                html = [html stringByReplacingOccurrencesOfString:imgSrc withString:[@"plainreader://article.body.img?" stringByAppendingString:imgSrc]];
//            }
//        }
    }
    html = [html stringByReplacingOccurrencesOfString:kSourcePlaceholder withString:_originHTML];
    return html;

}

@end
