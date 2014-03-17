//
//  CameraViewController.h
//  WifiCameraDemo
//
//  Created by bosma on 14-3-17.
//  Copyright (c) 2014年 cn.com.bosma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) UITableView * cameraTableView;
@property(strong, nonatomic) UIBarButtonItem * cameraEditBtn;

@end
