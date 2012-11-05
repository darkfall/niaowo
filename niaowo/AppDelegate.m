//
//  AppDelegate.m
//  niaowo
//
//  Created by Robert Bu on 9/16/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import "AppDelegate.h"
#import "PostDataSource.h"
#import "API.h"
#import "Topic.h"
#import "Settings.h"
#import "Comment.h"

@implementation AppDelegate

- (void)dealloc
{
}

- (void)requestForPostsAtPage:(NSUInteger)page {
    [_loadingProgressIndicator startAnimation:self];
    
    // cancel previous connection
    if(_pageRequestConn != nil) {
        [_pageRequestConn cancelRequest];
    }
    _pageRequestConn = [API requestTopicsForPage:page handler:^(NSArray* topics, NSUInteger currentPage, NSUInteger totalPages) {
        if(topics) {
            [_postDataSource.topics removeAllObjects];
            [_postDataSource.topics addObjectsFromArray:topics];
        
            [_postList reloadData];
        
            _currentPage = currentPage;
            _totalPages = totalPages;
        }
        
        [_loadingProgressIndicator stopAnimation:self];
        _pageRequestConn = nil;
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_postList setDelegate:self];
    _postDataSource = [[PostDataSource alloc] init];
    [_postList setDataSource:_postDataSource];

    [_window setDelegate:self];
    [_window makeKeyAndOrderFront:self];
    
    _loginPanel = [[LoginWindowController alloc] init];
    [_loginPanel beginSheetModalForWindow:_window completionHandler:^() {
        [self requestForPostsAtPage:1];
    }];
}

- (void)onLoginIn:(id)sender {
    _loginPanel = [[LoginWindowController alloc] init];
    [_loginPanel beginSheetModalForWindow:_window completionHandler:^() {
        [self requestForPostsAtPage:1];
    }];
}

- (IBAction)onPrevPageClicked:(id)sender {
    if(_currentPage > 1) {
        _currentPage -= 1;
        [_pageLabel setStringValue:[NSString stringWithFormat:@"%lu/%lu", _currentPage, _totalPages]];

        [self requestForPostsAtPage:_currentPage];
    }
}

- (IBAction)onNextPageClicked:(id)sender {
    if(_currentPage < _totalPages) {
        _currentPage += 1;
        [_pageLabel setStringValue:[NSString stringWithFormat:@"%lu/%lu", _currentPage, _totalPages]];

        [self requestForPostsAtPage:_currentPage];
    }
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [_postList selectedRow];
    if(row >= 0) {
        Topic* topic = [[_postDataSource topics] objectAtIndex:row];
        
        if(_topicRequestConn != nil) {
            [_topicRequestConn cancelRequest];
        }
        
        [[_topicView mainFrame] loadHTMLString:@"Loading..." baseURL:nil];

        _topicRequestConn = [API requestTopicContent:topic handler:^(Topic *topic, NSArray *comments) {
            NSMutableString *httpString = [NSMutableString string];
            
            [httpString appendFormat:@"<html><header></header><body>"];
            [httpString appendFormat:@"<div id='topic'><h3>%@</h3><div id='body'>%@</div>", topic.title, topic.body];
            [httpString appendFormat:@"Author: <span id='author'>%@</span>           Created-On: <span id='created'>%@</span></div>",
             topic.author,
             topic.createdAt];
            
            for(TopicComment* comment in comments) {
                NSUInteger index = [comments indexOfObject: comment];
                
                [httpString appendFormat:@"<div id='comment'><h4>%ld 楼</h4><div id='body'>%@</div>",
                 index,
                 comment.body];
                [httpString appendFormat:@"Author: <span id='author'>%@</span>           Created-On: <span id='created'>%@</span></div>",
                 comment.author,
                 comment.createdAt];
            }
            [httpString appendFormat:@"</body></html>"];
            
            [[_topicView mainFrame] loadHTMLString:httpString baseURL:nil];
            _topicRequestConn = nil;
        }];

    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if(!flag) {
        [[self window] makeKeyAndOrderFront:self];
        return YES;
    }
    return NO;
}

@end
