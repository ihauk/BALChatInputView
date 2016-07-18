//
//  GmacsMultiTextBoardView.m
//  GmacsIMKit
//
//  Created by yinfurong on 15/12/1.
//  Copyright © 2015年 xugang. All rights reserved.
//

#import "BALShortcutTextListView.h"

@implementation BALShortcutTextListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 45;
    }
    return self;
}
-(void)setShortcutTextArray:(NSArray *)shortcutTextArray
{
    _shortcutTextArray = shortcutTextArray;
    [self reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shortcutTextArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSString *text = [self.shortcutTextArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *text = [self.shortcutTextArray objectAtIndex:indexPath.row];
    if ([self.shortcutDelegate respondsToSelector:@selector(shortcutTextListView:didSelectAtIndex:text:)]) {
        
        [self.shortcutDelegate shortcutTextListView:self didSelectAtIndex:indexPath.row text:text];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}

@end
