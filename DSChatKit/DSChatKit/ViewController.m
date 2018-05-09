//
//  ViewController.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "ViewController.h"
#import "DSInputView.h"
@interface ViewController ()<DSInputViewDelegate, DSInputActionDelegate>

@property (nonatomic, strong) DSInputView *sessionInputView;
@property (nonatomic, strong) DSSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
