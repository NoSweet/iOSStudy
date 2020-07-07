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
//    [self barrier];
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
    NSLog(@"---download8---%@",[NSThread currentThread]);
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
}

// 同步函数 + 主队列: 死锁 崩溃
- (void)syncAndMainQueue {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"---download5---%@",[NSThread currentThread]);
    });
}

// 线程通信
- (void)threadTongXin {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

// 栅栏函数
- (void)barrier {
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("current", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i ++) {
            NSLog(@"%d-download1--%@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
            NSLog(@"%zd-download2--%@",i,[NSThread currentThread]);
        }
    });
    
    // 栅栏函数
    dispatch_barrier_async(queue, ^{
        NSLog(@"我是一个栅栏函数！");
    });
    dispatch_async(queue, ^{
           for (NSInteger i = 0; i<3; i++) {
               NSLog(@"%zd-download3--%@",i,[NSThread currentThread]);
           }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
            NSLog(@"%zd-download4--%@",i,[NSThread currentThread]);
        }
    });
    
}

// 延迟执行
- (void)delay {
    /*
     第一个参数:延迟时间
     第二个参数:要执行的代码
     如果想让延迟的代码在子线程中执行，也可以更改在哪个队列中执行 dispatch_get_main_queue() -> dispatch_get_global_queue(0, 0)
     */
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"---%@",[NSThread currentThread]);
    });
    
//    [self performSelector:<#(nonnull SEL)#> withObject:<#(nullable id)#> afterDelay:<#(NSTimeInterval)#>];
//    [NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> repeats:<#(BOOL)#> block:<#^(NSTimer * _Nonnull timer)block#>];
}

// 一次性代码
- (void)onceCode {
    // 整个程序运行过程中只会执行一次
    // onceToken记录程序是否执行过
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

// 快速迭代
- (void)apply {
    /*
         第一个参数:迭代的次数
         第二个参数:在哪个队列中执行
         第三个参数:block要执行的任务
         */
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
    });
}

// 队列组（同栅栏函数）
- (void)queueGroup {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 执行队列组任务
    dispatch_group_async(group, queue, ^{
        
    });
    // 队列中的任务执行完毕之后
    dispatch_group_notify(group, queue, ^{
        
    });
}
// group实例
- (void)groupTest {
    
}

@end
