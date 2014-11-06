//
//  WindowStateItem.h
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface WindowStateItem : NSObject

@property (nonatomic, readonly) NSWindow *window;
@property (nonatomic, readonly) NSRect windowFrame;
@property (nonatomic, readonly) NSInteger windowLevel;
@property (nonatomic, readonly) BOOL isMovable;
@property (nonatomic, readonly) BOOL isResizable;
@property (nonatomic, readwrite) NSInteger position;

- (id)initWithNSWindow: (NSWindow *)aWindow;

@end
