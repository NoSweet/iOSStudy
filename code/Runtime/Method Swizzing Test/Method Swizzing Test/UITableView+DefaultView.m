//
//  UITableView+DefaultView.m
//  Method Swizzing Test
//
//  Created by 刘思维 on 2020/7/2.
//  Copyright © 2020 刘思维. All rights reserved.
//

#import "UITableView+DefaultView.h"
#import "objc/runtime.h"

@implementation UITableView (DefaultView)

+ (void)load {
    Method originMethod = class_getInstanceMethod(self, @selector(reloadData));
    Method currentMethod = class_getInstanceMethod(self, @selector(llReloadData));
    method_exchangeImplementations(originMethod, currentMethod);
}

- (void)llReloadData {
    [self reloadData];
}

@end
