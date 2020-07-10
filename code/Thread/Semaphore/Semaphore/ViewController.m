//
//  ViewController.m
//  Semaphore
//
//  Created by superme on 2020/7/8.
//  Copyright © 2020 ldd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger ticketSurpsCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self semaphoreStnc];
//    [self initTicketStatusNotSafe];
    dispatch_queue_t q = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(q, ^{
        NSLog(@"11---%@",[NSThread currentThread]);
        dispatch_async(q, ^{
            NSLog(@"22---%@",[NSThread currentThread]);
        });
        dispatch_async(q, ^{
            
        });
    });
}

// semaphore 线程同步
- (void)semaphoreStnc {
    NSLog(@"current--%@",[NSThread currentThread]);
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0 );
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 任务1
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1----------%@",[NSThread currentThread]);
        
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semphore---end,numbwe== %d",number);
}

// 非线程安全
- (void)initTicketStatusNotSafe{
    NSLog(@"current-----%@",[NSThread currentThread]);
    NSLog(@"semaphore---begin");
    
    self.ticketSurpsCount = 50;
    
    dispatch_queue_t queue1 = dispatch_queue_create("1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
//        [weakSelf saleTicketNotSafe];
        NSLog(@"111111111111111111111111");
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
//        [weakSelf saleTicketNotSafe];
    NSLog(@"22222222222222222222222");
        [weakSelf saleTicketSafe];
    });
    
}

- (void)saleTicketNotSafe {
    while (1) {
        if (self.ticketSurpsCount > 0) {  //如果还有票，继续售卖
            self.ticketSurpsCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurpsCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

// 线程安全
- (void)saleTicketSafe {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurpsCount > 0) {  //如果还有票，继续售卖
            self.ticketSurpsCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurpsCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphore);
            break;
        }
        
        dispatch_semaphore_signal(semaphore);
        
    }
    
    
}

@end
