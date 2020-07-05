//
//  ViewController.m
//  Method Swizzing Test
//
//  Created by 刘思维 on 2020/7/2.
//  Copyright © 2020 刘思维. All rights reserved.
//

#import "ViewController.h"
#import "objc/runtime.h"
#import "Person.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self reloveTest];
    [self forwardTest];
}

// runtime动态转发
- (void)reloveTest {
    [self performSelector:@selector(foo:)];
}
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(foo:)) {// 动态解析 指定新的IMP
        class_addMethod([self class], sel, (IMP)foodMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void foodMethod(id obj, SEL _cmd) {
    NSLog(@"Doing foo");
}

// runtime备用接收者（快速转发）
- (void)forwardTest {
    [self performSelector:@selector(foo)];
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(foo)) {
//        return [Person new];
//    }
    return [super forwardingTargetForSelector:aSelector];
}

// runtime完整消息转发（慢速转发）
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"foo"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];// 签名 进入forwardforwardInvocation
    }
    return [super methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    
    Person *p = [Person new];
    if ([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}

// runtime方法交换
- (void)exchangeTest {
    UITableView *tab = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    [tab reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}




@end
