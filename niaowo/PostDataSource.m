//
//  PostDataSource.m
//  niaowo
//
//  Created by Robert Bu on 9/16/12.
//  Copyright (c) 2012 Robert Bu. All rights reserved.
//

#import "PostDataSource.h"
#import "Topic.h"

@implementation PostDataSource

@synthesize topics = _topics;

#import "Settings.h"

- (id)init {
    self = [super init];
    
    if(self) {
        _topics = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return item == nil ? [_topics count] : 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return item == nil ? [_topics objectAtIndex:index]: nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return [(Topic*)item title];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return NO;
}

@end
