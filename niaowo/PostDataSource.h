//
//  PostDataSource.h
//  niaowo
//
//  Created by Robert Bu on 9/16/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PostDataSource : NSObject<NSOutlineViewDataSource> {
    NSMutableArray* _topics;
}

@property (retain) NSMutableArray* topics;

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;

@end
