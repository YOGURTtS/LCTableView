//
//  LCActionCell.h
//  1haiiPhone
//
//  Created by LuckyCat on 2018/7/31.
//  Copyright © 2018年 EHi. All rights reserved.
//
//  cell样式：UILabel+箭头
//

#import <UIKit/UIKit.h>
#import "LCActionCellViewModel.h"

@interface LCActionCell : UITableViewCell

/** 数据赋值 */
@property (nonatomic, strong) LCActionCellViewModel *viewModel;

@end
