//
//  UITableView+Nodata.h
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Nodata)

- (void)tableViewWithPlaceholderView:(UIView *)emptyView rowCount:(NSUInteger)rowCount;

@end
