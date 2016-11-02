//
//  ViewController.m
//  CHTBubbleDragViewDemo
//
//  Created by cht on 16/11/2.
//  Copyright © 2016年 cht. All rights reserved.
//

#import "ViewController.h"
#import "CHTBubbleDragView.h"
#import "UIView+CHTFrame.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
//    CHTBubbleDragView *bubbleDragView = [[CHTBubbleDragView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    bubbleDragView.center = CGPointMake(self.view.width/2, self.view.height/2);
//    [self.view addSubview:bubbleDragView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CHTBubbleDragView *bubbleDragView = [[CHTBubbleDragView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        bubbleDragView.themeColor = [UIColor greenColor];
        bubbleDragView.textColor = [UIColor blackColor];
        bubbleDragView.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row * 1000];
        bubbleDragView.center = CGPointMake(SCREENWIDTH - 15 - bubbleDragView.width/2, 50);
        [cell.contentView addSubview:bubbleDragView];

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
