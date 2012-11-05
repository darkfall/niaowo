//
//  Post.h
//  niaowo
//
//  Created by Robert Bu on 9/16/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Topic : NSObject {
}

@property (copy) NSString* author;
@property (copy) NSString* desc;
@property (copy) NSString* body; // used in topic
@property (copy) NSString* createdAt;
@property (copy) NSString* updatedAt;
@property (copy) NSString* title;

@property (assign) NSUInteger viewPoint;
@property (assign) NSUInteger topicId;
@property (assign) NSUInteger memberId;
@property (assign) NSUInteger messageId;

@end
