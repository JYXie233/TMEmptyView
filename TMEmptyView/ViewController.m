//
//  ViewController.m
//  TMEmptyView
//
//  Created by Tom on 15/4/13.
//  Copyright (c) 2015年 Tom. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+TMCategory.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController{
    NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 10;
    [_tableView addReloadBlock:^{
        [self loadData];
    }];
}

-(void)loadData{
    if (count == 10) {
        count = 5;
    }else if(count == 5){
        count = 0;
    }else{
        count = 10;
    }
    [_tableView reloadData];
}

- (IBAction)changeCountAction:(id)sender {
    [self loadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    cell.textLabel.text = @"详细信息";
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
