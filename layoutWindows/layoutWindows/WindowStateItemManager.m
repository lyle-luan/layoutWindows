//
//  WindowStateItemManager.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "WindowStateItemManager.h"

@interface WindowStateItemManager()

@property (nonatomic, readwrite) NSMutableArray *windowStateList;
@property (nonatomic, readwrite) NSInteger numOfSinkWindows;
@property (nonatomic, readwrite) NSInteger numOfFloatWindows;

@end

@interface WindowStateItemManager(WindowStateItemManagerPrivate)

- (NSMutableArray *)searchOriginalWindowStatesListOfWindow: (NSWindow *)aWindow;
- (NSInteger)numOfWindows: (BOOL)topYesOrBottomNo;
- (void)createWindowStateList;

@end

@implementation WindowStateItemManager

+ (WindowStateItemManager *)getInstance
{
    static WindowStateItemManager *windowStateItemManager = nil;
    if (windowStateItemManager == nil)
    {
        windowStateItemManager = [[super allocWithZone:nil] init];
        [windowStateItemManager createWindowStateList];
    }
    return windowStateItemManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self getInstance];
}

- (void)addWindow: (NSWindow *)aWindow
{
    WindowStateItem *newItem = [[WindowStateItem alloc] initWithNSWindow:aWindow];
    [[self searchOriginalWindowStatesListOfWindow:aWindow] addObject:newItem];
}

- (void)removeWindowStateItem: (WindowStateItem *)anElement
{
    if (anElement != nil)
    {
        NSMutableArray *currentWindowStateList = [self searchOriginalWindowStatesListOfWindow:anElement.window];
        [currentWindowStateList removeObject:anElement];
        if (currentWindowStateList.count == 0)
        {
            [self.windowStateList removeObject:currentWindowStateList];
        }
    }
}

- (WindowStateItem *)originalWindowStateItemOfCurrentWindow: (NSWindow *)aWindow
{
    NSMutableArray *currentWindowStateList = [self searchOriginalWindowStatesListOfWindow:aWindow];
    
    WindowStateItem *originalWindowStateItem = currentWindowStateList.lastObject;
    
    return originalWindowStateItem;
}

- (NSInteger)numOfFloatWindows
{
    return [self numOfWindows:YES];
}

- (NSInteger)numOfSinkWindows
{
    return [self numOfWindows:NO];
}

- (id)firstObject
{
    return _windowStateList.firstObject;
}

@end

@implementation WindowStateItemManager(WindowStateItemManagerPrivate)

- (void)createWindowStateList
{
    _windowStateList = [[NSMutableArray alloc] init];
}

- (NSMutableArray *)searchOriginalWindowStatesListOfWindow: (NSWindow *)aWindow
{
    for (NSMutableArray *indexArray in _windowStateList)
    {
        if (indexArray.count == 0)
        {
            [_windowStateList removeObject:indexArray];
            continue;
        }
        if (aWindow == ((WindowStateItem *)(indexArray.firstObject)).window)
        {
            return indexArray;
        }
    }
    
    NSMutableArray *newWindow = [[NSMutableArray alloc] init];
    [_windowStateList addObject:newWindow];
    
    return newWindow;
}

- (NSInteger)numOfWindows: (BOOL)topYesOrBottomNo
{
    _numOfSinkWindows = 0;
    _numOfFloatWindows = 0;
    
    WindowStateItem *currentWindowStateItem = nil;
    
    for (NSMutableArray *indexArray in _windowStateList)
    {
        if (indexArray.count == 0)
        {
            [_windowStateList removeObject:indexArray];
            continue;
        }
        currentWindowStateItem = (WindowStateItem *)(indexArray.lastObject);
        if (currentWindowStateItem.window.level == WINDOW_STATE_BOTTOM)
        {
            _numOfSinkWindows++;
        }
        else if (currentWindowStateItem.window.level == WINDOW_STATE_TOP)
        {
            _numOfFloatWindows++;
        }
    }
    if (topYesOrBottomNo == YES)
    {
        return _numOfFloatWindows;
    }
    else
    {
        return _numOfSinkWindows;
    }
}

@end