//
//
//
//  Created by shengshikanghe on 13-10-5.
//  Copyright (c) 2013年 shengshikanghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDownloadDelegate.h"

@interface DownloadManager : NSObject<HttpDownloadDelegate>
{
    NSMutableDictionary *downloadQueue;
    NSMutableDictionary *resultDict;
    
}
@property (nonatomic,readonly)NSMutableDictionary *resultDict;

+ (id)sharedManager;

- (void)clearResultDict;

- (void)addDownloadToQueue:(NSString *)url APIType:(NSInteger)type;
- (void)addDownloadToQueue:(NSString *)url APIType:(NSInteger)type dict:(NSDictionary *)dict;

- (void)cancelDownloadForUrl:(NSString *)url;

@end
