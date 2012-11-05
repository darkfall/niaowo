//
//  LoginWindowController.h
//  niaowo
//
//  Created by Robert Bu on 11/3/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoginWindowController : NSWindowController {
    id _sheetCallbackBlock;
    IBOutlet NSProgressIndicator *_loginProgress;
    IBOutlet NSButton *_loginButton;
    IBOutlet NSPanel* _loginSheet;
    IBOutlet NSTextField *_usernameField;
    IBOutlet NSSecureTextField *_passwordField;
}

- (void)beginSheetModalForWindow:(NSWindow*)window completionHandler:(void (^)())handler;

- (IBAction)onLogin:(id)sender;
@end
