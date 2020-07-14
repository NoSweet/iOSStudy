//
//  ViewController.m
//  Isa-swizzling
//
//  Created by superme on 2020/7/13.
//  Copyright © 2020 ldd. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>


@interface Person : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *name;

@end

@implementation Person

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end

NSString *demo_getLastName(id self, SEL selector) {
    return @"apple";
}

@interface ViewController ()

@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSMutableArray<Person *> *people;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 非集合
    self.person = [Person new];
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    self.person.name = @"Tom";
//    [self setValue:@"Tom" forKey:@"person.name"];
    
    // 集合
    self.people = [NSMutableArray array];
    Person *person0 = [[Person alloc] init];
    person0.name = @"Tom";
    [self.people addObject:person0];
    Person *person1 = [[Person alloc] init];
    person1.name = @"Jerry";
    [self.people addObject:person1];
    NSString *key = @"people";
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    Person *person2 = [[Person alloc] init];
    person2.name = @"Frank";
    NSMutableArray *people = [self mutableArrayValueForKey:key];
    [people addObject:person2];
    NSLog(@"People: \n%@  people: %@", self.people, people);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"new name: %@", change[NSKeyValueChangeNewKey]);
    } else if ([keyPath isEqualToString:@"people"]) {
        NSLog(@"new array: %@", change[NSKeyValueChangeNewKey]);
        NSArray<Person *> *people = change[NSKeyValueChangeNewKey];
        NSLog(@"new person: %@", people.firstObject.name);
    }
}

- (void)test1 {
    Person *person = [Person new];
    person.firstName = @"Tom";
    person.lastName = @"Goole";
    NSLog(@"person full name : %@ %@",person.firstName,person.lastName);
    
    // 创建一个子类
    NSString *oldName = NSStringFromClass([person class]);
    NSString *newName = [NSString stringWithFormat:@"Subclass_%@",oldName];
    Class customClass = objc_allocateClassPair([person class], newName.UTF8String, 0);
    objc_registerClassPair(customClass);
    
    // 重写get方法
    SEL sel = @selector(lastName);
    Method method = class_getInstanceMethod([person class], sel);
    const char *type = method_getTypeEncoding(method);
    class_addMethod(customClass, sel, (IMP)demo_getLastName, type);
    // 修改isa指针
    object_setClass(person, customClass);
    
    NSLog(@"person full name: %@ %@",person.firstName, person.lastName);
    
    Person *person2 = [Person new];
    person2.firstName = @"Jerry";
    person2.lastName = @"Google";
    NSLog(@"person2 full name: %@ %@",person2.firstName, person2.lastName);
}


@end
