//
//  ViewController.m
//  Study_GL_1
//
//  Created by gxs on 12-12-22.
//  Copyright (c) 2012年 gxs. All rights reserved.
//

#import "ViewController.h"

#import "MyGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    MyGLView *renderView = [[MyGLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = renderView;
    [renderView release];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
