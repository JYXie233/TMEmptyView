//
//  UITableView+TMCategory.m
//  TmFramework
//
//  Created by Tom on 15/4/12.
//  Copyright (c) 2015年 Tom. All rights reserved.
//

#import "UITableView+TMCategory.h"
#import <objc/runtime.h>
#import "EmptyView.h"

@implementation UITableView (TMCategory)
static const void *reloadBlockkey = &reloadBlockkey;
static const void *emptyViewkey = &emptyViewkey;

+(void)load{
    [self swizzleSelector:@selector(reloadData) withSelector:@selector(beginReloadData)];
    //    [self swizzleSelector:@selector(initWithFrame:) withSelector:@selector(initWithFrame_debug:)];
}

-(void)beginReloadData{
    [self beginReloadData];
    if ([self reloadBlock]) {
        NSInteger sections = [self numberOfSections];
        BOOL isEmpty = YES;
        for (NSInteger i = 0; i < sections; i ++) {
            if ([self numberOfRowsInSection:i] > 0) {
                isEmpty = NO;
                break;
            }
        }
        if (isEmpty) {
            [self addSubview:[self emptyView]];
            [self layoutIfNeeded];
        }else{
            [[self emptyView] removeFromSuperview];
        }
        self.scrollEnabled = !isEmpty;
    }
}

+(void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethodInit=class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethodInit) {
        class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (UIView*)emptyView{
    
    EmptyView * view = objc_getAssociatedObject(self, emptyViewkey);
    if (view == nil) {
        view = [[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil][0];
        view.frame = self.bounds;
        [view.reloadBtn addTarget:self action:@selector(reloadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, emptyViewkey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    view.reloadBtn.enabled = YES;
    return objc_getAssociatedObject(self, emptyViewkey);
}

- (void)setEmptyView:(UIView *)emptyView{
    objc_setAssociatedObject(self, emptyViewkey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(TMReloadBlcok)reloadBlock{
    return objc_getAssociatedObject(self, reloadBlockkey);
}

-(void)setReloadBlock:(TMReloadBlcok)reloadBlock{
    objc_setAssociatedObject(self, reloadBlockkey, reloadBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)addReloadBlock:(TMReloadBlcok)block{
    [self setReloadBlock:block];
}

-(void)reloadBtnAction:(UIButton*)sender{
    sender.enabled = NO;
    if ([self reloadBlock]) {
        [self reloadBlock]();
    }
}

@end
