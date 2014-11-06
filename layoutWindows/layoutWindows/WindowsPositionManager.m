//
//  WindowsPositionManager.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "WindowsPositionManager.h"
#import "WindowStateItemManager.h"

@interface WindowsPositionManager(WindowsPositionManagerPrivate)

+ (void)relayoutFullScreenBottomPosition;
+ (void)relayoutLeftRightBottomPosition;
+ (void)relayoutLeftRightTopRightBottomPosition;

+ (void)relayoutRightTopPosition;
+ (void)relayoutRightTopRightBottomTopPosition;

@end

@implementation WindowsPositionManager

+ (void)reLayoutBottomWindowsPositionWhenThisWindowBottom: (NSWindow *)aWindow
{
    NSInteger numOfBottomWindows = [WindowStateItemManager getInstance].numOfSinkWindows;
    if (aWindow.level != WINDOW_STATE_BOTTOM)
    {
        numOfBottomWindows++;
    }
    switch (numOfBottomWindows)
    {
        case BOTTOM_FULL_SCREEN_POSITION:
        {
            [self relayoutFullScreenBottomPosition];
            break;
        }
        case BOTTOM_LEFT_RIGHT_POSITION:
        {
            [self relayoutLeftRightBottomPosition];
            break;
        }
        case BOTTOM_LEFT_RIGHT_TOP_RIGHT_BOTTOM_POSITION:
        {
            [self relayoutLeftRightTopRightBottomPosition];
            break;
        }
        default:
        {
            break;
        }
    }
}

+ (void)reLayoutTopWindowsPositionWhenThisWindowTop: (NSWindow *)aWindow
{
    NSInteger numOfTopWindows = [WindowStateItemManager getInstance].numOfFloatWindows;
    if (aWindow.level != WINDOW_STATE_TOP)
    {
        numOfTopWindows++;
    }
    switch (numOfTopWindows)
    {
        case TOP_RIGHT_SCREEN_POSITION:
        {
            [self relayoutRightTopPosition];
            break;
        }
        case TOP_RIGHT_TOP_RIGHT_BOTTOM_POSITION:
        {
            [self relayoutRightTopRightBottomTopPosition];
            break;
        }
        default:
        {
            break;
        }
    }
}

+ (void)resumeWindowStateAccordingWindowStateItem: (WindowStateItem *)aWindowStateItem
{
    [aWindowStateItem.window setFrame:aWindowStateItem.windowFrame display:YES animate:YES];
    [aWindowStateItem.window setLevel:aWindowStateItem.windowLevel];
    [aWindowStateItem.window setMovable:aWindowStateItem.isMovable];
}

@end

@implementation WindowsPositionManager(WindowsPositionManagerPrivate)

+ (void)relayoutFullScreenBottomPosition
{
    NSMutableArray *fullScreenWindowList = [WindowStateItemManager getInstance].firstObject;
    WindowStateItem *fullScreenWindowStateItem = fullScreenWindowList.lastObject;
    NSWindow *fullScreenWindow = fullScreenWindowStateItem.window;
    [fullScreenWindow setFrame:[self fullScreenPosition] display:YES animate:YES];
}

+ (void)relayoutLeftRightBottomPosition
{
    
}

+ (void)relayoutLeftRightTopRightBottomPosition
{
    
}

+ (void)relayoutRightTopPosition
{
    NSMutableArray *rightScreenWindowList = [WindowStateItemManager getInstance].firstObject;
    WindowStateItem *rightScreenWindowStateItem = rightScreenWindowList.lastObject;
    NSWindow *fullScreenWindow = rightScreenWindowStateItem.window;
    [fullScreenWindow setFrame:[self rightScreenPosition] display:YES animate:YES];
}

+ (void)relayoutRightTopRightBottomTopPosition
{
    
}

+ (NSRect)rightScreenPosition
{
    NSRect frame;
    CGFloat ScreenHalfWidth = [NSScreen mainScreen].frame.size.width/2;
    
    frame.origin.x      = ScreenHalfWidth;
    frame.origin.y      = 0.0f;
    frame.size.width    = ScreenHalfWidth;
    frame.size.height   = [NSScreen mainScreen].frame.size.height;
    return frame;
}

+ (NSRect)fullScreenPosition
{
    //TODO:screen
    NSRect frame;
    frame.origin.x      = 0.0f;
    frame.origin.y      = 0.0f;
    frame.size.width    = [NSScreen mainScreen].frame.size.width;
    frame.size.height   = [NSScreen mainScreen].frame.size.height;
    return frame;
}

@end