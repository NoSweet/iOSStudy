//
//  ViewController.m
//  GCDTest
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
//    [self creatQueue];
    
    [self test];
}

// 队列创建
- (void)creatQueue {
    // 并发队列
//    dispatch_queue_t queue = dispatch_queue_create("current", DISPATCH_QUEUE_CONCURRENT);
//
//    // 串行队列
//    dispatch_queue_t queue1 = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
//
//    // 全局并发队列
//    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
    // 主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 开启同步函数
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"哈哈哈");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"呵呵哒");
    });
    
}

- (void)test {
    NSLog(@"mainQueue == %@",[NSThread mainThread]);
    [self asyncAndCurrentQueue];
    [self asyncAndSerialQueue];
    [self syncAndCurrentQueue];
    [self syncAndSerialQueue];
    [self asyncAndMainQueue];
}

// 异步函数 + 并发队列: 开启新的线程，并发执行
- (void)asyncAndCurrentQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
}

// 异步函数 + 串行队列: 开启一条线程，任务串行执行
- (void)asyncAndSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("sieral", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"---download2---%@",[NSThread currentThread]);
    });
}

// 同步函数 + 并发队列: 不会开线程，任务串行执行
- (void)syncAndCurrentQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_sync(queue, ^{
        NSLog(@"---download3---%@",[NSThread currentThread]);
    });
}

// 同步函数 + 串行队列: 不会开启线程，任务串行执行
- (void)syncAndSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("sieral1", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"---download4---%@",[NSThread currentThread]);
    });
}

// 异步函数 + 主队列: 不会开线程，任务串行执行
- (void)asyncAndMainQueue {
    dispatch_async(dispatch_get_main_queue(), ^{
       NSLog(@"---download5---%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
       NSLog(@"---download6---%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
       NSLog(@"---download7---%@",[NSThread currentThread]);
    });
    NSLog(@"是串行执行么？ 是的！");
}

// 同步函数 + 主队列: 死锁 崩溃
- (void)syncAndMainQueue {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"---download5---%@",[NSThread currentThread]);
    });
}

@end
