//
//  ZPDishCell.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/17.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPDishCell.h"
#import "UIImageView+DishImage.h"
#import "OC-SW-Bridege.h"
@interface ZPDishCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation ZPDishCell

- (void)setDataSource:(NSArray *)dataSource indexPath:(NSIndexPath *)indexPath
{
    ZPDishModel * m  = dataSource[indexPath.row];
     _title.text = m.title;
    _content.text = m.content;

    [_imgeView setImageWithURL:m.imageUrl placeholde:nil];

}
//- (void)didMoveToSuperview
//{
//    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
//           self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);   
//    }
//
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.content.preferredMaxLayoutWidth =CGRectGetWidth(_content.frame);
}
@end
