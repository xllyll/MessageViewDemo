//
//  ViewController.m
//  MessgaeViewDemo
//
//  Created by xinyu_mac on 15/4/1.
//  Copyright (c) 2015年 xllyll. All rights reserved.
//

#import "ViewController.h"
#import "YLYMessageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YLYMessageView *messageView = [[YLYMessageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:messageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
