//
//  ViewController.m
//  NSThreadTest
//
//  Created by 刘思维 on 2020/7/6.
//  Copyright © 2020 刘思维. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

// 线程创建
- (void)creatThread {
    // 方法一 需要手动开启
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
    
//    [thread sleep]
//    [NSThread sleepUntilDate:<#(nonnull NSDate *)#>]
//    [NSThread sleepForTimeInterval:<#(NSTimeInterval)#>];
    [NSThread exit];
    
    // 方法二 自动启动
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    
    // 方法三 隐式创建并启动
    [self performSelectorInBackground:@selector(run) withObject:nil];
    
    // 线程锁
    @synchronized (self) {
        // 互斥锁
    }
    
    // 线程通信
//    [self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>];
//    [self performSelector:<#(nonnull SEL)#> onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>];
    
}


@end
