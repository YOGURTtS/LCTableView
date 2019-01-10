//
//  EHITableView.m
//  TestTableView
//
//  Created by LuckyCat on 2017/12/26.
//  Copyright © 2017年 LuckyCat. All rights reserved.
//

#import "EHITableView.h"

@interface EHITableView ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    CGFloat lastContentOffset; // ScoreView滑动位置
}
/** 真正的TableView */
@property (nonatomic, strong) UITableView *mainTable;

@end

@implementation EHITableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataType = EHITableViewDataTypeRow;
        _endDecelerateCount = 1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainTable.frame = self.bounds;
    _noDataView.center = self.mainTable.center;
}

#pragma mark - Setter

- (void)setNoDataView:(UIView *)noDataView {
    _noDataView = noDataView;
    
    [self addSubview:_noDataView];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    if (self.dataType == EHITableViewDataTypeAll && _dataArray.count) {
        NSAssert([_dataArray[0] isKindOfClass:[NSArray class]], @"EHITableViewDataTypeAll数据为嵌套数组");
    }
    
    [self.mainTable reloadData];
    _noDataView.hidden = _dataArray.count;
}

- (void)setRefreshHeader:(MJRefreshNormalHeader *)refreshHeader {
    _refreshHeader = refreshHeader;
    
    self.mainTable.mj_header = refreshHeader;
}

- (void)setRefreshFooter:(MJRefreshBackNormalFooter *)refreshFooter {
    _refreshFooter = refreshFooter;
    
    self.mainTable.mj_footer = refreshFooter;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.dataType) {
        case EHITableViewDataTypeRow:
            return 1;
            break;
        case EHITableViewDataTypeSection:
            return self.dataArray.count;
            break;
        case EHITableViewDataTypeAll:
            return self.dataArray.count;
            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.dataType) {
        case EHITableViewDataTypeRow:
            return self.dataArray.count;
            break;
        case EHITableViewDataTypeSection:
            return 1;
            break;
        case EHITableViewDataTypeAll:
            return [self.dataArray[section] count];
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.delegate tableView:self heightForHeaderInSection:section];
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:self viewForHeaderInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.delegate tableView:self heightForFooterInSection:section];
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:self viewForFooterInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    if (self.cellClass) {
        return tableView.rowHeight;
    }
    id<EHICellViewModelProtocol> cellViewModel = [self cellViewModelWithIndexPath:indexPath];
    return cellViewModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = self.cellClass;
    id object = [self cellViewModelWithIndexPath:indexPath];
    if (!cellClass) {
        id<EHICellViewModelProtocol> cellViewModel = object;
        cellClass = [cellViewModel.class cellClass];
    }
    NSString *identifier = NSStringFromClass(cellClass);
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        if (self.isNibCell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] objectAtIndex:0];
        } else {
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    if ([cell respondsToSelector:@selector(setViewModel:)]) {
        [cell performSelector:@selector(setViewModel:) withObject:object];
    }
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell performSelector:@selector(setModel:) withObject:object];
    }
    if ([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:tableViewCell:viewModel:)]) {
        [self.delegate tableView:self cellForRowAtIndexPath:indexPath tableViewCell:cell viewModel:object];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<EHICellViewModelProtocol> cellViewModel = [self cellViewModelWithIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:viewModel:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath viewModel:cellViewModel];
    }
    NSLog(@"didSelectRowAtIndexPath：%ld  %ld， %@", (long)indexPath.section, (long)indexPath.row, cellViewModel);
}

#pragma mark - Method

/** 根据数据类型和位置取数据 */
- (id<EHICellViewModelProtocol>)cellViewModelWithIndexPath:(NSIndexPath *)indexPath {
    switch (self.dataType) {
        case EHITableViewDataTypeRow:
            return self.dataArray[indexPath.row];
            break;
        case EHITableViewDataTypeSection:
            return self.dataArray[indexPath.section];
            break;
        case EHITableViewDataTypeAll:
            return self.dataArray[indexPath.section][indexPath.row];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (fabs(scrollView.contentOffset.y) < 25) {
        self.endDecelerateCount ++;
    } else {
        self.endDecelerateCount = 0;
    }
    if (self.endDecelerateCount == 2 && scrollView.contentOffset.y == 0) {
        if ([self.delegate respondsToSelector:@selector(tableView:didScrollWithDirection:)]) {
            self.endDecelerateCount = 0;
            [self.delegate tableView:self didScrollWithDirection:NO];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > lastContentOffset) {
        self.endDecelerateCount = 0;
        if ([self.delegate respondsToSelector:@selector(tableView:didScrollWithDirection:)]) {
            [self.delegate tableView:self didScrollWithDirection:YES];
        }
    } else {
        if (self.endDecelerateCount == 1 || scrollView.contentOffset.y < -100) {
            if ([self.delegate respondsToSelector:@selector(tableView:didScrollWithDirection:)]) {
                self.endDecelerateCount = 0;
                [self.delegate tableView:self didScrollWithDirection:NO];
            }
        }
    }
}

#pragma mark - Getter

- (UITableView *)mainTable {
    if (!_mainTable) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.showsVerticalScrollIndicator = YES;
        
        tableView.tableFooterView = [[UIView alloc] init];

        _mainTable = tableView;
        [self addSubview:_mainTable];
    }
    return _mainTable;
}

@end
