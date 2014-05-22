//
//  HttpDownloadDelegate.h
//
//  Created by shengshikanghe on 13-10-4.
//  Copyright (c) 2013年 shengshikanghe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownloadHelper;

@protocol HttpDownloadDelegate <NSObject>
- (void)downloadCompleted:(DownloadHelper *)dh;

@optional
- (void)downloadError:(DownloadHelper *)dh;

@end
