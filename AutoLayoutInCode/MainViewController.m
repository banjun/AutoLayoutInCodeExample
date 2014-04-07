//
//  MainViewController.m
//  AutoLayoutInCode
//
//  Created by jun on 2014/04/07.
//  Copyright (c) 2014年 banjun. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic) UIView *leftColumn, *rightColumn;

@end

@implementation MainViewController

- (void)loadView
{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // auto layout setup programatically, without xib nor storyboard
    
    self.leftColumn = [[UIView alloc] init];
    self.leftColumn.translatesAutoresizingMaskIntoConstraints = NO;
    self.leftColumn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.leftColumn];
    self.rightColumn = [[UIView alloc] init];
    self.rightColumn.backgroundColor = [UIColor redColor];
    self.rightColumn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.rightColumn];
    
    
    // shortcut for constraint visual format
    NSNumber *padding = @8;
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding);
    void (^addConstraint)(UIView *, NSString *, NSDictionary *) = ^(UIView *superview, NSString *format, NSDictionary *views) {
        [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]];
    };
    
    // 2 columns layout
    NSDictionary *columns = NSDictionaryOfVariableBindings(_leftColumn, _rightColumn);
    addConstraint(self.view, @"H:|-padding-[_leftColumn]-padding-[_rightColumn(==_leftColumn)]-padding-|", columns);
    addConstraint(self.view, @"V:|-padding-[_leftColumn]-padding-|", columns);
    addConstraint(self.view, @"V:|-padding-[_rightColumn]-padding-|", columns);
    
    // 3 rows in left
    {
        NSArray *leftRows = @[[[UIView alloc] init],
                              [[UIView alloc] init],
                              [[UIView alloc] init],
                              ];
        UIView *previousRow = nil;
        for (UIView *row in leftRows) {
            row.translatesAutoresizingMaskIntoConstraints = NO;
            row.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
            [self.leftColumn addSubview:row];
            addConstraint(self.leftColumn, @"H:|-padding-[row]-padding-|", @{@"row": row});
            if (previousRow) {
                addConstraint(self.leftColumn, @"V:[prev]-padding-[next(==prev)]", @{@"prev": previousRow, @"next": row});
            }
            previousRow = row;
        }
        addConstraint(self.leftColumn, @"V:|-padding-[row]", @{@"row": leftRows[0]}); // first
        addConstraint(self.leftColumn, @"V:[row]-padding-|", @{@"row": leftRows.lastObject}); // last
    }
    
    // 10 rows in right
    {
        NSArray *rightRows = @[[[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               [[UIView alloc] init],
                               ];
        UIView *previousRow = nil;
        for (UIView *row in rightRows) {
            row.translatesAutoresizingMaskIntoConstraints = NO;
            row.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
            row.layer.cornerRadius = 4.0;
            [self.rightColumn addSubview:row];
            addConstraint(self.rightColumn, @"H:|-padding-[row]-padding-|", @{@"row": row});
            if (previousRow) {
                addConstraint(self.rightColumn, @"V:[prev]-padding-[next(==prev)]", @{@"prev": previousRow, @"next": row});
            }
            previousRow = row;
        }
        addConstraint(self.rightColumn, @"V:|-padding-[row]", @{@"row": rightRows[0]}); // first
        addConstraint(self.rightColumn, @"V:[row]-padding-|", @{@"row": rightRows.lastObject}); // last
    }
}

@end
