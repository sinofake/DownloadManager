//
//  ViewController.m
//  下载管理
//
//  Created by sskh on 14-5-22.
//  Copyright (c) 2014年 sskh. All rights reserved.
//

#import "ViewController.h"
#import "DownloadCenter/DownloadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", HOME_URL, LOGIN_URL];
    [[DownloadManager sharedManager] addDownloadToQueue:url APIType:LOGIN_TYPE];
    
    /**POST请求方式：
     NSDictionary *dict = @{<#key#>: <#object, ...#>};
     [[DownloadManager sharedManager] addDownloadToQueue:url APIType:LOGIN_TYPE dict:dict];
     */
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinish:) name:url object:nil];
}

- (void)loginFinish:(NSNotification *)notification
{
    /**
     下载管理类中处理请求结果后发出通知:
     [[NSNotificationCenter defaultCenter] postNotificationName:dh.url object:dh.url];
     
     下面的[notification object]就是上面的dh.url;
     */
    id ret = [[[DownloadManager sharedManager] resultDict] objectForKey:[notification object]];
    
    NSLog(@"%s, ret:%@", __func__, ret);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
