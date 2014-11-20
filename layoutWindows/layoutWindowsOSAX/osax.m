//
//  osax.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HotKeyManager.h"

__attribute__((constructor))
static void hackIntoAutomatically()
{
    [HotKeyManager engineHotKeyListen];
    
    NSMenu* menu = [NSApp windowsMenu];
    if (!menu)
    {
        NSLog(@"found no Window menu in NSApp");
    }
    
    [menu insertItem:[NSMenuItem separatorItem] atIndex:[menu numberOfItems]];
    
    NSUInteger i = 0, lastSeparator = -1;
    for (NSMenuItem* item in [menu itemArray])
    {
        if ([item isSeparatorItem])
        {
            lastSeparator = i;
        }
        else if ([item action] == @selector(arrangeInFront:))
        {
            i += 1;
            break;
        }
        i++;
    }
    
    NSMenuItem *addItem = [[NSMenuItem alloc] initWithTitle:@"123" action:NULL keyEquivalent:@""];
    [menu insertItem:addItem atIndex:i];
}

OSErr hackInto(const AppleEvent *ev, AppleEvent *reply, long refcon)
{
    NSLog(@"hackInto");
    return noErr;
}

OSErr hackEnd(const AppleEvent *ev, AppleEvent *reply, long refcon)
{
    NSLog(@"hackEnd");
    NSMenu* menu = [NSApp windowsMenu];
    if (!menu)
    {
        NSLog(@"found no Window menu in NSApp");
    }
    
    [menu insertItem:[NSMenuItem separatorItem] atIndex:[menu numberOfItems]];
    
    NSUInteger i = 0, lastSeparator = -1;
    for (NSMenuItem* item in [menu itemArray])
    {
        if ([item isSeparatorItem])
        {
            lastSeparator = i;
        }
        else if ([item action] == @selector(arrangeInFront:))
        {
            i += 1;
            break;
        }
        i++;
    }
    
    NSMenuItem *addItem = [[NSMenuItem alloc] initWithTitle:@"234" action:NULL keyEquivalent:@""];
    [menu insertItem:addItem atIndex:i];
    
    return noErr;
}