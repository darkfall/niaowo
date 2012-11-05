//
//  CancellableRequest.m
//  niaowo
//
//  Created by Robert Bu on 11/4/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import "AsynchronousConnection.h"

@implementation AsynchronousConnection

- (id)init {
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil];
    
    _data = nil;
    _response = nil;
    _error = nil;
    _callbackBlock = nil;
    _connection = nil;
    
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler {
    self = [self init];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    _callbackBlock = handler;
    
    return self;
}

- (void)dealloc {
    if(_connection) {
        [_connection cancel];
    }
    if(_thread && [_thread isExecuting]) {
        [_thread cancel];
    }
}

+ (AsynchronousConnection*)connectionWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler {
    AsynchronousConnection* conn = [[AsynchronousConnection alloc] initWithRequest:request completionHandler:handler];
    if(!conn) {
        return nil;
    }
    
    [conn start];
    return conn;
}

- (void)start {
    _finished = NO;
    _data = [[NSMutableData alloc] init];
    
    [_thread start];
}

- (void)cancelRequest {
    if(_connection) {
        [_connection cancel];
    }
    [_thread cancel];
    
    _data = nil;
    _response = nil;
    _error = nil;
}

- (void)threadMain {
    [_connection start];
    while(!_finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)onFinished {
    dispatch_async(dispatch_get_main_queue(), ^(){
        ((void (^)(NSURLResponse* response, NSData* data, NSError* error))(_callbackBlock))(_response, _data, _error);
    });
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    return;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _finished = YES;
    
    [self onFinished];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _error = error;
    _finished = YES;
    
    [self onFinished];
}

@end
