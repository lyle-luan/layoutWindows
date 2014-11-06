//
//  WindowsManager.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "WindowsManager.h"
#import "WindowStateItemManager.h"
#import "WindowsPositionManager.h"

@interface WindowsManager()

@property (nonatomic, readwrite) NSWindow *currentWindow;

@end

@interface WindowsManager(WindowsManagerPrivate)

- (NSWindow *)topWindow;
- (void)backupCurrentWindowState;
- (void)reLayoutWindowsbottomAlways;
- (void)spinCurrentWindowToDesktopUnderIcon:(BOOL)isUnderIcon responseToUserInteraction:(BOOL)interacted;
- (void)cantMoveCurrentWindow;
- (void)canMoveCurrentWindow;
- (void)reLayoutWindowsTopAlways;
- (void)floatCurrentWindowTop;

@end

@implementation WindowsManager

+ (WindowsManager *)getInstance
{
    static WindowsManager *windowsManager = nil;
    if (windowsManager == nil)
    {
        windowsManager = [[super allocWithZone:nil] init];
    }
    return windowsManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self getInstance];
}

- (void)dontBotherMeWindow
{
    self.currentWindow = [self topWindow];
    [self backupCurrentWindowState];
    [self reLayoutWindowsbottomAlways];
    [self spinCurrentWindowToDesktopUnderIcon:NO responseToUserInteraction:YES];
    [self cantMoveCurrentWindow];
}

- (void)needAlltimeWindow
{
    self.currentWindow = [self topWindow];
    [self backupCurrentWindowState];
    [self reLayoutWindowsTopAlways];
    [self floatCurrentWindowTop];
    [self canMoveCurrentWindow];
}

- (void)notNeedAlltimeWindow
{
    
}

- (void)comeBackWindow
{
    self.currentWindow = [self topWindow];
    WindowStateItem *originalWindowStateItem = [[WindowStateItemManager getInstance] originalWindowStateItemOfCurrentWindow: self.currentWindow];
    if (originalWindowStateItem != nil)
    {
        [WindowsPositionManager resumeWindowStateAccordingWindowStateItem:originalWindowStateItem];
        [[WindowStateItemManager getInstance] removeWindowStateItem:originalWindowStateItem];
    }
}

@end

@implementation WindowsManager(WindowsManagerPrivate)

- (NSWindow *)topWindow
{
    NSWindow* currentWindowMaybe = nil;
    
    currentWindowMaybe = [self retrospectTopWindow:[NSApp keyWindow]];
    if (currentWindowMaybe != nil)
    {
        if (![self isWindowShouldIgnored:currentWindowMaybe])
        {
            return currentWindowMaybe;
        }
    }
    
    currentWindowMaybe = [self retrospectTopWindow:[NSApp mainWindow]];
    if (currentWindowMaybe != nil)
    {
        if (![self isWindowShouldIgnored:currentWindowMaybe])
        {
            return currentWindowMaybe;
        }
    }
    
    for (NSWindow *windowIndex in [NSApp orderedWindows])
    {
        currentWindowMaybe = [self retrospectTopWindow:windowIndex];
        if (![self isWindowShouldIgnored:currentWindowMaybe])
        {
            return currentWindowMaybe;
        }
    }
    
    return nil;
}

- (void)backupCurrentWindowState
{
    [[WindowStateItemManager getInstance] addWindow:self.currentWindow];
}

- (void)reLayoutWindowsbottomAlways
{
    [WindowsPositionManager reLayoutBottomWindowsPositionWhenThisWindowBottom:self.currentWindow];
}

- (void)reLayoutWindowsTopAlways
{
    [WindowsPositionManager reLayoutTopWindowsPositionWhenThisWindowTop:self.currentWindow];
}

- (void)spinCurrentWindowToDesktopUnderIcon:(BOOL)isUnderIcon responseToUserInteraction:(BOOL)interacted
{
    if (isUnderIcon == NO)
    {
        [self.currentWindow setLevel:WINDOW_STATE_BOTTOM];
    }
}

- (void)floatCurrentWindowTop
{
    [self.currentWindow setLevel:WINDOW_STATE_TOP];
}

- (void)cantMoveCurrentWindow
{
    [self.currentWindow setMovable:NO];
}

- (void)canMoveCurrentWindow
{
    [self.currentWindow setMovable:YES];
}

- (NSWindow *)retrospectTopWindow:(NSWindow *)thisWindow
{
    while ([thisWindow parentWindow])
    {
        thisWindow = [thisWindow parentWindow];
    }
    
    return thisWindow;
}

- (BOOL)isWindowShouldIgnored:(NSWindow *)aWindow
{
    if ([aWindow isKindOfClass:[NSPanel class]])
    {
        NSLog(@"nspanel");
        return YES;
    }
    if (![aWindow isVisible])
    {
        NSLog(@"not isvisible");
        return YES;
    }
    return NO;
}

@end