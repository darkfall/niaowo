//
//  API.h
//  niaowo
//
//  Created by Robert Bu on 10/28/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsynchronousConnection.h"

@class Topic;

@interface API : NSObject

/* accquire seesion and return cookie string */
+ (AsynchronousConnection*)session:(NSString*)username password:(NSString*)password handler:(void (^)(int))handler;
+ (AsynchronousConnection*)requestTopicsForPage:(NSUInteger)page handler:(void (^)(NSArray* topics, NSUInteger currentPage, NSUInteger totalPages))handler;
+ (AsynchronousConnection*)requestTopicContent:(Topic*)topic handler:(void (^)(Topic* topic, NSArray* comments))handler;

@end
