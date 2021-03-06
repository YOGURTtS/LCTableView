//
//  LCTableViewIMP.h
//  LCTableView_Example
//
//  Created by LuckyCat on 2019/1/14.
//  Copyright © 2019年 LuckyCat7848. All rights reserved.
//
//  默认实现TableView的代理方法
//

#import <Foundation/Foundation.h>
#import "LCCellDataProtocol.h"
#import "LCDefines.h"

@interface LCTableViewIMP : NSObject<UITableViewDelegate, UITableViewDataSource>

/** 数据类型 */
@property (nonatomic, assign) LCTableViewDataStyle dataStyle;

/**
 数据(如果LCTableViewDataStyleAll,为嵌套数组)
 */
@property (nonatomic, strong) NSArray *dataArray;

@end
