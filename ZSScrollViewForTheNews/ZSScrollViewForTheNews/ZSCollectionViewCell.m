//
//  ZSCollectionViewCell.m
//  ZSScrollViewForTheNews
//
//  Created by 周松 on 17/4/13.
//  Copyright © 2017年 周松. All rights reserved.
//

#import "ZSCollectionViewCell.h"


@interface ZSCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;


@end
@implementation ZSCollectionViewCell
-(UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        [self.contentView addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
        tableView.backgroundColor = [UIColor orangeColor];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}


@end
