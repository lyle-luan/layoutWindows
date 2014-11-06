//
//  WindowStateItem.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "WindowStateItem.h"

@implementation WindowStateItem

- (id)initWithNSWindow: (NSWindow *)aWindow
{
    self = [super init];
    if (self)
    {
        _window = aWindow;
        _windowFrame = aWindow.frame;
        _windowLevel = aWindow.level;
        _isMovable = aWindow.isMovable;
        _isResizable = aWindow.isResizable;
    }
    
    return self;
}

@end
