//
//  CancellableRequest.h
//  niaowo
//
//  Created by Robert Bu on 11/4/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynchronousConnection : NSObject<NSURLConnectionDataDelegate> {
    NSURLConnection* _connection;
    NSThread* _thread;
    
    NSMutableData* _data;
    NSURLResponse* _response;
    NSError* _error;
    
    BOOL _finished;
    id _callbackBlock;
}

+ (AsynchronousConnection*)connectionWithRequest:(NSURLRequest*)request completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* error))handler;

- (void)cancelRequest;

@end
