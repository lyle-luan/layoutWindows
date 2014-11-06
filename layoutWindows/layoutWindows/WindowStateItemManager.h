//
//  WindowStateItemManager.h
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WindowStateItem.h"

#define WINDOW_STATE_BOTTOM     (kCGDesktopIconWindowLevel)
#define WINDOW_STATE_TOP        (kCGFloatingWindowLevel)

@class WindowStateItem;
@class NSWindow;

@interface WindowStateItemManager : NSObject

@property (nonatomic, readonly) NSInteger numOfSinkWindows;
@property (nonatomic, readonly) NSInteger numOfFloatWindows;
@property (nonatomic, readonly) id firstObject;

+ (WindowStateItemManager *)getInstance;
- (void)addWindow: (NSWindow *)aWindow;
- (void)removeWindowStateItem: (WindowStateItem *)anWindowStateItem;
- (WindowStateItem *)originalWindowStateItemOfCurrentWindow: (NSWindow *)aWindow;

@end
