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
    pageIndex = 1;
  
}
- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
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
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    ZPDishSearchResultModel * m = arrays[indexPath.row];
    cell.textLabel.text = m.title;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
