//
//
//
//  Created by shengshikanghe on 13-10-5.
//  Copyright (c) 2013年 shengshikanghe. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadHelper.h"

@implementation DownloadManager
@synthesize resultDict;

+ (id)sharedManager
{
    static id _s;
    if (_s == nil) {
        _s = [[[self class] alloc] init];
    }
    return _s;
}

- (id)init
{
    self = [super init];
    if (self) {
        downloadQueue = [[NSMutableDictionary alloc] init];
        resultDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addDownloadToQueue:(NSString *)url APIType:(NSInteger)type
{
    DownloadHelper *dh = [[DownloadHelper alloc] init];
    dh.url = url;
    dh.APIType = type;
    dh.delegate = self;
    [dh startDownload];
    [downloadQueue setObject:dh forKey:url];
    //[ShareApp showLoadingView];
}

- (void)addDownloadToQueue:(NSString *)url APIType:(NSInteger)type dict:(NSDictionary *)dict
{
    DownloadHelper *dh = [[DownloadHelper alloc] init];
    dh.url = url;
    dh.APIType = type;
    dh.delegate = self;
    [dh startDownloadByPost:dict];
    [downloadQueue setObject:dh forKey:url];
    //[ShareApp showLoadingView];
}

- (void)cancelDownloadForUrl:(NSString *)url
{
    DownloadHelper *dh = [downloadQueue objectForKey:url];
    if (dh) {
        [dh cancel];
        [downloadQueue removeObjectForKey:url];
    }
}

- (void)clearResultDict
{
    [resultDict removeAllObjects];
    [ASIHTTPRequest setSessionCookies:nil];
}

- (void)delayRemoveDownloadRequest:(DownloadHelper *)dh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [downloadQueue removeObjectForKey:dh.url];
    });
}

//从服务器获得的请求结果在这里进行解析
- (void)downloadCompleted:(DownloadHelper *)dh
{
    switch (dh.APIType) {
        case LOGIN_TYPE:
            [self parseLogin:dh];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:dh.url object:dh.url];
    
    
    //下载完成后将请求从队列中清除
    [self delayRemoveDownloadRequest:(DownloadHelper *)dh];
}

//网络请求失败处理
- (void)downloadError:(DownloadHelper *)dh
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [av show];
    
    [resultDict setObject:@"NetworkError" forKey:dh.url];//网络出错

    [[NSNotificationCenter defaultCenter] postNotificationName:dh.url object:dh.url];
    
    //下载失败后将请求从队列中清除
    [self delayRemoveDownloadRequest:dh];
}

- (id)handleDownloadData:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"in %s error:%@",__FUNCTION__,[error localizedDescription]);
        return nil;
    }
    return jsonDict;
    
    //调试用
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
   return nil;
}

- (void)parseLogin:(DownloadHelper *)dh
{
    NSDictionary *jsonDict = [self handleDownloadData:dh.downloadData];
    
    if (jsonDict) {
        //将解析结果存入结果字典
        [resultDict setObject:jsonDict forKey:dh.url];
    }
}



@end













