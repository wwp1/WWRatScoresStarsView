//
//  ViewController.m
//  WWRatScoresStarsView
//
//  Created by 王万鹏 on 2018/5/15.
//  Copyright © 2018年 王万鹏. All rights reserved.
//

#import "ViewController.h"
#import "WWRatScoresStarsView.h"


@interface ViewController ()<WWRatScoresStarsViewDelegate, UITableViewDelegate,UITableViewDataSource >

@property(nonatomic, strong)WWRatScoresStarsView *ratingView;
@property(nonatomic, strong)NSArray *dataSourceArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr = @[@"正常显示评分(3.6)",@"选择整数评分(1-5分)",@"选择小数评分(有0分)",@"显示大星星评分"];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50 * _dataSourceArr.count) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionFooterHeight = 0.01f;
    tableView.sectionHeaderHeight = 0.01f;
    tableView.rowHeight = 50;
    [self.view addSubview:tableView];
    
}

#pragma - mark  - WWRatScoresStarsViewDelegate
- (void)ratingStartsView:(WWRatScoresStarsView *)ratingView ratingNumber:(CGFloat)ratingNum {
    
    NSLog(@"选择的评分为：%f",ratingNum);
}

#pragma - mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _dataSourceArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!_ratingView) {
        _ratingView = [[WWRatScoresStarsView alloc]initWithFrame:CGRectMake(60 * self.view.frame.size.width/375, self.view.frame.size.height - 100, self.view.frame.size.width - 120 * self.view.frame.size.width/375, 36 * self.view.frame.size.width/375) height:25 type:WWRatScoresStarsNormalRating];
        _ratingView.backgroundColor = [UIColor lightGrayColor];
        _ratingView.delegate = self;
        [self.view addSubview:_ratingView];
    }
    
    _ratingView.starsType = indexPath.row;
    //正常显示评分(3.6)
    if (_ratingView.starsType == WWRatScoresStarsDefault) {
        _ratingView.ratNum = 3.6;
    }
    //选择整数评分(1-5分)
    else if (_ratingView.starsType == WWRatScoresStarsNormalRating) {
        _ratingView.ratNum = 4;
    }
    //选择小数评分(有0分)
    else if (_ratingView.starsType == WWRatScoresStarsFloatRating) {
        _ratingView.ratNum = 4.2;
    }
    //显示大星星评分
    else if (_ratingView.starsType == WWRatScoresStarsShow) {
        _ratingView.ratNum = 3;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
