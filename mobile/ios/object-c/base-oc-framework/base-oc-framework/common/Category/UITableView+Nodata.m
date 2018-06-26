//
//  UITableView+Nodata.m
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "UITableView+Nodata.h"

@implementation UITableView (Nodata)

- (void)tableViewWithPlaceholderView:(UIView *)emptyView rowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        // 没有数据时，默认提示的view
        self.backgroundView = emptyView;
    }else{
        self.backgroundView = nil;
    }
}

@end
