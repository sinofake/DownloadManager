//

//
//  Created by shengshikanghe on 13-10-4.
//  Copyright (c) 2013年 shengshikanghe. All rights reserved.
//

#import "DownloadHelper.h"

@implementation DownloadHelper
@synthesize downloadData,delegate = _delegate,APIType = _APIType,url = _url;

- (void)dealloc
{
    if (httpConnection) {
        [httpConnection cancel];
    }
    if (formRequest) {
        formRequest.delegate = nil;
        [formRequest clearDelegatesAndCancel];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        downloadData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)cancel
{
    if (httpConnection) {
        [httpConnection cancel];
    }
    if (formRequest) {
        formRequest.delegate = nil;
        [formRequest clearDelegatesAndCancel];
    }
}

- (void)startDownload
{
    if (self.url.length > 0) {
        NSLog(@"%@",self.url);
        NSURL *newUrl = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
        NSURLRequest *request = [NSURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.f];
        httpConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)startDownloadByPost:(NSDictionary *)dict
{
    if (self.url.length > 0) {
        NSLog(@"%@",self.url);
        NSURL *newUrl = [NSURL URLWithString:self.url];
        formRequest = [[ASIFormDataRequest alloc] initWithURL:newUrl];
        for (NSString *key in dict) {
            id object = [dict objectForKey:key];
            if ([object isKindOfClass:[NSData class]]) {
                [formRequest setData:object forKey:key];
            } else {
                [formRequest setPostValue:object forKey:key];
            }
        }
        formRequest.delegate = self;
        [formRequest startAsynchronous];
        
        //formRequest.cachePolicy = ASIDontLoadCachePolicy;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response   
{
    [downloadData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloadCompleted:)]) {
        [self.delegate performSelector:@selector(downloadCompleted:) withObject:self];
    } else {
        NSLog(@"下载完成的回调方法%@没有实现",NSStringFromSelector(@selector(downloadCompleted:)));
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(downloadError:)]) {
        [self.delegate performSelector:@selector(downloadError:) withObject:self];
    } else {
        NSLog(@"Error:%@",[error localizedDescription]);
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    [downloadData setLength:0];
    [downloadData appendData:[request responseData]];
    if ([self.delegate respondsToSelector:@selector(downloadCompleted:)]) {
        [self.delegate performSelector:@selector(downloadCompleted:) withObject:self];
    } else {
        NSLog(@"下载完成的回调方法%@没有实现",NSStringFromSelector(@selector(downloadCompleted:)));
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(downloadError:)]) {
        [self.delegate performSelector:@selector(downloadError:) withObject:self];
    } else {
        NSLog(@"下载失败");
    }
}

@end














