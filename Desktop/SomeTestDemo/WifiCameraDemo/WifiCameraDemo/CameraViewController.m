//
//  CameraViewController.m
//  WifiCameraDemo
//
//  Created by bosma on 14-3-17.
//  Copyright (c) 2014年 cn.com.bosma. All rights reserved.
//

#import "CameraViewController.h"
#import "Shop.h"
@interface CameraViewController ()
{
    NSMutableArray * _shop;//存放plist数组
    NSMutableArray * _deleteShop;//存放删除数据数组
}
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIBarButtonItem * cameraBackBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cameraBackBtnAction:)];
    self.cameraEditBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(cameraEditBtnAction:)];
    self.navigationItem.leftBarButtonItem=cameraBackBtn;
    self.navigationItem.rightBarButtonItem = self.cameraEditBtn;
    
    self.cameraTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, HEIGHT, WIDTH) style:UITableViewStylePlain];
    self.cameraTableView.delegate = self;
    self.cameraTableView.dataSource = self;
    [self.view addSubview:self.cameraTableView];
    
    
    //读取plist文件
    NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shops.plist" ofType:nil]];
    _shop = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in array) {
        Shop * s = [Shop shopWithDict:dict];
        [_shop addObject:s];
    }
    //NSLog(@"%@",_shop);
    _deleteShop = [[NSMutableArray alloc]init];
}

#pragma mark 返回按钮方法
- (void)cameraBackBtnAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 编辑按钮方法
- (void)cameraEditBtnAction:(UIButton*)sender{
    [self.cameraTableView setEditing:YES animated:YES];
    
    
    //获得所要删除数据的行号
    NSMutableArray * deletePaths = [NSMutableArray array];
    for (Shop * s in _deleteShop) {
        int row = [_shop indexOfObject:s];
        NSIndexPath * path = [NSIndexPath indexPathForRow:row   inSection:0];
        [deletePaths addObject:path];
    }
    //删除模型数据
    [_shop removeObjectsInArray:_deleteShop];
    //清空——deleteShop所有数据
    [_deleteShop removeAllObjects];
    //刷新表格(动画效果)
    //[_tableView reloadData];
    [self.cameraTableView deleteRowsAtIndexPaths:deletePaths withRowAnimation:UITableViewRowAnimationRight];
    
    
}


#pragma mark - 数据源方法
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //显示打勾数量
    if (_deleteShop.count==0) {
        self.title = @"视频";
        self.cameraEditBtn.enabled = NO;//不可以点击
    }else{
        self.cameraEditBtn.enabled = YES;//可以点击
        self.title = [NSString stringWithFormat:@"视频(%d)",_deleteShop.count];
    }
    return _shop.count;
}


#pragma mark 重用机制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    Shop * s = _shop[indexPath.row];
    cell.textLabel.text = s.name;
    cell.detailTextLabel.text = s.desc;
    cell.imageView.image = [UIImage imageNamed:s.icon];
    //如果_deleteShop包含s，则打勾
    if ([_deleteShop containsObject:s]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{//不需要打勾
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark 每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


#pragma mark 选中状态
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //控制当前行的数据是否选中
    Shop * s = _shop[indexPath.row];
    if ([_deleteShop containsObject:s]) {//之前选中，现在取消选中
        //移除
        [_deleteShop removeObject:s];
    }else{//之前没选中，现在选中
        //添加
        [_deleteShop addObject:s];
    }
    //刷新Row单一表格，效率更高
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark 取消选中状态
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Deselect-->%d",indexPath.row);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
