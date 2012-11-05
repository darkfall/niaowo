//
//  API.m
//  niaowo
//
//  Created by Robert Bu on 10/28/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import "API.h"
#import "Settings.h"
#import "Topic.h"
#import "Comment.h"

#import "Categories/NSDictionary+URLQuery.h"

@implementation API


static NSString* SESSION_URL = @"https://www.niaowo.me/account/token";
static NSString* TOPIC_LIST_URL_FORMAT = @"https://www.niaowo.me/topics/page/%d.json";

static NSString* TOPIC_CONTENT_URL_FORMAT = @"https://www.niaowo.me/topics/%d.json?output=html";

+ (NSURL*)getPostListUrl:(NSUInteger)page {
    NSString* urlString = [NSString stringWithFormat:TOPIC_LIST_URL_FORMAT, page];
    return [NSURL URLWithString:urlString];
}

+ (NSURL*)getTopicURL:(NSUInteger)topicId {
    NSString* urlString = [NSString stringWithFormat:TOPIC_CONTENT_URL_FORMAT, topicId];
    return [NSURL URLWithString:urlString];
}

+ (AsynchronousConnection*)session:(NSString*)username password:(NSString*)password handler:(void (^)(int))handler{
    NSDictionary* query = @{@"api_key": API_KEY, @"api_secret": API_SECRET, @"username": username, @"password":password};
    
    NSData* body = [[query queryString] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SESSION_URL]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%ld", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    return [AsynchronousConnection connectionWithRequest:request
                                                completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if([data length] > 0 && error == nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if ([[result objectForKey:@"status"] isEqualToString:@"success"]) {
                handler(1);
            } else {
                handler(0);
            }
        } else {
            handler(0);
        }
    }];
}


+ (AsynchronousConnection*)requestTopicsForPage:(NSUInteger)page handler:(void (^)(NSArray* topics, NSUInteger currentPage, NSUInteger totalPages))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self getPostListUrl:page]];
    [request setHTTPMethod:@"GET"];
    
    return [AsynchronousConnection connectionWithRequest:request
                                                completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
       if(data.length > 0 && err == nil) {
           NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
           
           NSMutableArray* posts = [[NSMutableArray alloc] init];
           for(NSDictionary* dict in [result objectForKey:@"topics"]) {
               Topic* topic = [[Topic alloc] init];
               topic.desc = [dict valueForKey:@"desc"];
               topic.createdAt = [dict valueForKey:@"created_at"];
               topic.updatedAt = [dict valueForKey:@"updated_at"];
               topic.title = [dict valueForKey:@"title"];
               topic.memberId = [[dict valueForKey:@"member_id"] intValue];
               topic.topicId = [[dict valueForKey:@"id"] intValue];
               
               [posts addObject:topic];
           }
           
           NSDictionary* pageInfo = [result objectForKey:@"page"];
           handler(posts, [[pageInfo valueForKey:@"current_page"] intValue], [[pageInfo valueForKey:@"total_pages"] intValue]);
       } else {
           handler(nil, 0, 0);
       }
   }];
}

+ (AsynchronousConnection*)requestTopicContent:(Topic*)topic handler:(void (^)(Topic* topic, NSArray* comments))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self getTopicURL:[topic topicId]]];
    [request setHTTPMethod:@"GET"];
    
    __block Topic* t = topic;
    return [AsynchronousConnection connectionWithRequest:request
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
       if(data.length > 0 && err == nil) {
           NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
           
           NSDictionary* topicDict = [result objectForKey:@"topic"];
           
           t.body = [topicDict objectForKey:@"body"];
           
           id commentsDict = [result objectForKey:@"comments"];
           NSMutableArray* comments = [[NSMutableArray alloc] init];
           for(NSDictionary* commentDict in commentsDict) {               
               TopicComment* comment = [[TopicComment alloc] init];
               comment.body = [commentDict objectForKey:@"body"];
               comment.author = [commentDict objectForKey:@"author"];
               comment.createdAt = [commentDict objectForKey:@"created"];
               
               [comments addObject:comment];
           }
           
           handler(t, comments);
       } else {
           handler(nil, nil);
       }
   }];
}

@end
