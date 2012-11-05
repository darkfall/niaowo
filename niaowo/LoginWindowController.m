//
//  LoginWindowController.m
//  niaowo
//
//  Created by Robert Bu on 11/3/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import "LoginWindowController.h"
#import "API.h"

@implementation LoginWindowController

- (IBAction)onLogin:(id)sender {
    [_loginButton setEnabled:FALSE];
    [_loginProgress startAnimation:self];
    
    [API session:[_usernameField stringValue] password:[_passwordField stringValue] handler:^(int result){
        if(result) {
            [_loginProgress stopAnimation:self];
            
            [NSApp endSheet:_loginSheet];
            
            ((void (^)())(_sheetCallbackBlock))();
        } else {
            [_loginProgress stopAnimation:self];
            [_loginButton setEnabled:YES];
            
            NSAlert* alert = [NSAlert alertWithMessageText:@"错误的用户名/密码" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
            [alert runModal];
        }
    }];
}

- (id)init {
    [NSBundle loadNibNamed:@"LoginWindow" owner:self];
    self = [super initWithWindowNibName:@"LoginWindow"];
    
    return self;
}

- (void)beginSheetModalForWindow:(NSWindow*)window completionHandler:(void (^)())handler {
    [NSApp beginSheet:_loginSheet
       modalForWindow:window
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
    
    _sheetCallbackBlock = handler;
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
}

@end
