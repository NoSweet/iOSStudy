//
//  ViewController.m
//  NSOperationTest
//
//  Created by superme on 2020/7/7.
//  Copyright © 2020 ldd. All rights reserved.
//

#import "ViewController.h"
#import "MyOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self invocation];
    [self blockOperation];
//    [self customOperation];
//    [self test2];
}

#pragma mark -----------------任务

// NSInvocationOperation
- (void)invocation {
    /*
    第一个参数:目标对象
    第二个参数:选择器,要调用的方法
    第三个参数:方法要传递的参数
    */
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    [op start];
}
- (void)run {
    NSLog(@"3333333------%@",[NSThread currentThread]);
}

// NSBlockOperation(最常用)
- (void)blockOperation {
    // 1 封装操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 要执行的操作，在主线程中执行
        NSLog(@"1----------%@",[NSThread currentThread]);
    }];
    
    // 2 追加操作，追加的操作在子线程中执行，可以追加多条操作
    [op addExecutionBlock:^{
        NSLog(@"-----2-------%@",[NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        sleep(2);
        NSLog(@"-----4-------%@",[NSThread currentThread]);
        
    }];
    NSLog(@"3");
    [op start];
    NSLog(@"4");
}

// 自定义子类
- (void)customOperation {
    MyOperation *op = [MyOperation new];
    [op start];
}

#pragma mark ---------------队列
- (void)test2 {
//    [self operationAndQueue];
    [self inportantOfNSOperation];
}

// 结合使用创建多线程
- (void)operationAndQueue {
    // 创建非主队列 同时具备并发和串行的功能，默认是并发队列
    NSOperationQueue *queue = [NSOperationQueue new];
    // 封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-------1----%@",[NSThread mainThread]);
    }];
    // 封装操作加入主队列
    [queue addOperation:op1];
//    [op1 start];
}

// 重要属性和方法
- (void)inportantOfNSOperation {
    // 1 NSOperation的依赖
    // 操作op1依赖op5 5完成之后执行1，不能循环依赖
    // 可以跨队列依赖，依赖别的队列的操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op1=====%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op2 ==== %@",[NSThread currentThread]);
    }];
    
    [op1 addDependency:op2];
    
    // 2 监听操作的完成
    // 当op1线程完成后，立刻就会执行block中的代码
    // block中的代码与op1不一定在一个线程中执行，但是一定在子线程中执行
    op1.completionBlock = ^{
        NSLog(@"已经完成了--%@",[NSThread currentThread]);
    };
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:op1];
    [queue addOperation:op2];
}
- (void)importOfNSOperationQueue {
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    /*
     默认是并发队列,如果最大并发数>1,并发
     如果最大并发数==1,串行队列
     系统的默认是最大并发数-1 ,表示不限制
     设置成0则不会执行任何操作
     */
     queue.maxConcurrentOperationCount = 1;
    
    // 暂停，恢复
    queue.suspended = YES;
    // 取消所有的任务，不在执行，不可逆
    [queue cancelAllOperations];
}


@end
