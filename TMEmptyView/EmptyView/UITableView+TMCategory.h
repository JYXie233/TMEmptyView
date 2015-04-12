//
//  UITableView+TMCategory.h
//  TmFramework
//
//  Created by Tom on 15/4/12.
//  Copyright (c) 2015年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TMReloadBlcok)();

@interface UITableView (TMCategory)

-(void)addReloadBlock:(TMReloadBlcok)block;

@end
