//
//  MainController.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/16.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "MainController.h"
#import "ZPCoverView.h"
#import "ZPDishSearchResultController.h"
#import "ZPHTTPClient.h"

#import "TFHpple.h"
#import "UIImageView+DishImage.h"
#import "ZPDishCell.h"

#import "OC-SW-Bridege.h"
#import "ViewController.h"
@interface MainController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ZPCoverView * _cover;
    
    UISearchBar * _searchBar;
    
    ZPDishSearchResultController * _resultController;
    
    NSMutableArray *  dishArrs;
//    NSMutableArray * titleArrs;
    
    UITableView * _tableView;
    
}
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    dishArrs = [NSMutableArray array];
    
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if ([[UITableView appearance] respondsToSelector:@selector(setSeparatorInset:)]) {
        [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
    }
  
    //搜索
    [self addSearchBar];
    [self addTableView];
    //请求数据
    [self getData];
    
}
- (void)addTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 69, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    [self.view addSubview:tableView];
    _tableView = tableView;
}
- (void)getData
{
    [[ZPHTTPClient shareClient] requestWithMethod:get url:@"http://www.meishij.net/" pramater:nil response:^(NSError *error, id responese) {
        TFHpple * hpple = [[TFHpple alloc]initWithHTMLData:responese];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray * div_elements =   [hpple searchWithXPathQuery:@"//div[@id=\"index_zzw_main\"]/div[@*]"];
            
            static NSInteger index = 0;
            for (TFHppleElement * e in div_elements) {
                if (e.attributes[@"c"]) {
                    NSInteger  c = [e.attributes[@"c"] integerValue];
                    NSArray * li_elements =   [hpple searchWithXPathQuery:[NSString stringWithFormat:@"//div[@id=\"index_zzw_main\"]/div[%d]/ul/li",c]];
                    NSInteger li_index = 1;
                    for (TFHppleElement * li_element in li_elements)
                    {
                        //图片和菜名
                        TFHppleElement * imgs_element = [li_element firstChildWithClassName:@"img"];
                        TFHppleElement * img_element  = imgs_element.children.firstObject;
                        
                        
                        //获取菜名的简介内容
                        NSArray * strong_elements =   [hpple searchWithXPathQuery:[NSString stringWithFormat:@"//div[@id=\"index_zzw_main\"]/div[%d]/ul/li[%d]/div/strong",c,li_index]];
                        TFHppleElement * text_element = strong_elements.firstObject;
                        
                        if (imgs_element.hasChildren && [img_element.tagName isEqualToString:@"img"]) {
                            NSDictionary  * hrefAttr  = imgs_element.attributes;
                            NSDictionary  * imgAttr = img_element.attributes;
                            if (hrefAttr[@"href"] && hrefAttr[@"title"] && imgAttr[@"src"]) {
                                //对象赋值
                                ZPDishModel * m = [[ZPDishModel alloc]init];
                                m.title = hrefAttr[@"title"];
                                m.imageUrl = imgAttr[@"src"];
                                if (text_element.text) {
                                    m.content = text_element.text;
                                }
                                m.toUrl = hrefAttr[@"href"];
                                [dishArrs addObject:m];
                            }
                        }
                        li_index ++;
                        index ++;
                    }
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                            [_tableView reloadData];
            });
        });
        
    }];
}

- (void)addSearchBar
{
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, 10, self.view.frame.size.width-120, 30)];
    bar.searchBarStyle = UISearchBarStyleDefault;
    bar.delegate = self;
    _searchBar = bar;
    self.navigationItem.titleView = bar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dishArrs.count;
}

- (ZPDishCell *)createDishCell:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"CellIdentifier";
    ZPDishCell * cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPDishCell" owner:nil options:nil] firstObject];
    }
    [cell setDataSource:dishArrs indexPath:indexPath];
    return cell;
}
- (ZPDishCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self createDishCell:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static ZPDishCell * cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPDishCell" owner:nil options:nil] firstObject];
        }
    });
    [cell setDataSource:dishArrs indexPath:indexPath];
    
    [cell updateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutSubviews];
    [cell layoutIfNeeded];
 
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //图片的高度和获取的height 高度对比
    height = MAX(height, 136);
   
    return height+1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    

}
//估算
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static ZPDishCell * cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPDishCell" owner:nil options:nil] firstObject];
        }
    });
    [cell setDataSource:dishArrs indexPath:indexPath];
    
    [cell updateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //图片的高度和获取的height 高度对比
    height = MAX(height, 136);
    
    return height+1;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPDishModel * m = dishArrs[indexPath.row];
    ViewController * vc = [[ViewController alloc]init];
    vc.htmlURL = m.toUrl;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // 1.显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];

    if (!_cover)
    {
        _cover =  [ZPCoverView coverWithTarget:self action:@selector(handleClick:)];
        _cover.frame = self.view.bounds;
        
    }
    _cover.alpha = 0;
    [self.view addSubview:_cover];
   [UIView animateWithDuration:0.5 animations:^{
       [_cover reset];
       
   }];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [_resultController.view removeFromSuperview];
    }else
    {
        //搜索结果
        if (!_resultController) {
            _resultController = [[ZPDishSearchResultController alloc]init];
            _resultController.view.frame = _cover.frame;
            _resultController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addChildViewController:_resultController];
        }
        _resultController.searchText = searchText;
        [self.view addSubview:_resultController.view];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self removeCover];
}
//移除遮盖
- (void)removeCover
{
    if (_cover) {
        [UIView animateWithDuration:0.5 animations:^{
            _cover.alpha = 0;
        } completion:^(BOOL finished) {
            [_cover removeFromSuperview];
           
        }];
    }
    // 2.隐藏取消按钮
    [_searchBar setShowsCancelButton:NO animated:YES];
    
    // 3.退出键盘
    [_searchBar resignFirstResponder];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    return YES;
}
- (void)handleClick:(UITapGestureRecognizer *)gesture
{
    [self removeCover];
}


- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
@end
