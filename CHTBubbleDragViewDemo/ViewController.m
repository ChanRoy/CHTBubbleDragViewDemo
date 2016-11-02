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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CHTBubbleDragView *bubbleDragView = [[CHTBubbleDragView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bubbleDragView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
