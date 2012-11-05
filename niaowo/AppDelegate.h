//
//  AppDelegate.h
//  niaowo
//
//  Created by Robert Bu on 9/16/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "LoginWindowController.h"

@class PostDataSource;
@class AsynchronousConnection;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate, NSWindowDelegate> {
    LoginWindowController* _loginPanel;
    PostDataSource* _postDataSource;
    
    NSUInteger _currentPage;
    NSUInteger _totalPages;
    
    IBOutlet NSOutlineView *_postList;
    IBOutlet WebView *_topicView;
    IBOutlet NSTextField *_pageLabel;
    IBOutlet NSProgressIndicator *_loadingProgressIndicator;
    
    AsynchronousConnection* _pageRequestConn;
    AsynchronousConnection* _topicRequestConn;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)onLoginIn:(id)sender;
- (IBAction)onPrevPageClicked:(id)sender;
- (IBAction)onNextPageClicked:(id)sender;

@end
