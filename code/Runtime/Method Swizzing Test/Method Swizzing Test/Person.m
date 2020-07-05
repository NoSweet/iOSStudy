//
//  Person.m
//  Method Swizzing Test
//
//  Created by 刘思维 on 2020/7/2.
//  Copyright © 2020 刘思维. All rights reserved.
//

#import "Person.h"
#import "objc/message.h"

@implementation Person

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        for (NSString *key in dic.allKeys) {
            id value = dic[key];
            // 赋值属性 set方法
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@",key.capitalizedString]);
            if (sel) {
                ((void(*)(id, SEL, id))objc_msgSend)(self, sel, value);
            }
        }
    }
    return self;
}

- (NSDictionary *)convertModelDic {
    // 获取属性列表
    unsigned const int count = 0;
    objc_property_t *t = class_copyPropertyList(self, &count);
    NSMutableDictionary *dic = [@{} mutableCopy];
    for (int i = 0; i < count; i ++) {
        // 获取key
        const void *proName = property_getName(t[i]);
        NSString *name = [NSString stringWithUTF8String:proName];
        // 获取值 get方法
        SEL sel = NSSelectorFromString(name);
        // 获取value
        if (sel) {
            id value = ((id(*)(id, SEL))objc_msgSend)(self, sel);
            dic[name] = value;
        }
    }
    free(t);
    return dic;
}

- (void)foo {
    NSLog(@"person foo");
}

@end
