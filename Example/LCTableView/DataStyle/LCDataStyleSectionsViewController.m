//
//  LCDataStyleSectionsViewController.m
//  LCTableView_Example
//
//  Created by LuckyCat on 2019/1/16.
//  Copyright © 2019年 LuckyCat7848. All rights reserved.
//

#import "LCDataStyleSectionsViewController.h"
#import "UITableView+LCAdd.h"
#import "LCActionCellViewModel.h"

@interface LCDataStyleSectionsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LCDataStyleSectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多个section,1个row";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configDatas];
}

- (void)configDatas {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        LCActionCellViewModel *cellVM = [[LCActionCellViewModel alloc] init];
        cellVM.cellHeight = 120;
        cellVM.textStr = @"就我自几个儿~";
        [dataArray addObject:cellVM];
    }
    [self.tableView.lc_dataArray addObjectsFromArray:dataArray];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor lightGrayColor];
    return label;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.lc_dataStyle = LCTableViewDataStyleSections;
        tableView.lc_Delegate = self;
        
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
