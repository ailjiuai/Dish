//
//  ZPDishSearchResultController.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/16.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPDishSearchResultController.h"
#import "ZPHTTPClient.h"
#import "TFHpple.h"
#import "OC-SW-Bridege.h"
@interface ZPDishSearchResultController ()
{
    NSInteger pageIndex;
    NSMutableArray * arrays;
}
@end

@implementation ZPDishSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrays = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    pageIndex = 1;
  
}
- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    
    if (arrays.count) {
        [arrays removeAllObjects];
    }
    NSString * url = [NSString stringWithFormat:@"http://so.meishi.cc/ajax/ajaxtitle.php?words=%@",_searchText];
    [[ZPHTTPClient shareClient]requestWithMethod:get url:url pramater:nil response:^(NSError *error, id responese) {
        TFHpple * hpple = [[TFHpple alloc]initWithHTMLData:responese];
        NSArray * array =  [hpple searchWithXPathQuery:@"//a"];
        for (TFHppleElement * e in array) {
            ZPDishSearchResultModel * m = [ZPDishSearchResultModel new];
            m.title = e.text;

            if ([e objectForKey:@"href"]) {
                 m.hrefHTML = [e objectForKey:@"href"];
            }
            if (e.hasChildren && [e.firstChild.tagName isEqualToString:@"span"]) {
                m.subTitle = e.firstChild.text;
                
            }
            [arrays addObject:m];
            
        }
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return arrays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.font = cell.textLabel.font;
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    ZPDishSearchResultModel * m = arrays[indexPath.row];
    cell.textLabel.text = m.title;
    cell.detailTextLabel.text = m.subTitle;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
