//
//  osax.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HotKeyManager.h"

void hackIntoHere();

__attribute__((constructor))
static void hackIntoAutomatically()
{
    NSLog(@"hackIntoAutomatically");
    hackIntoHere();
}

OSErr hackInto(const AppleEvent *ev, AppleEvent *reply, long refcon)
{
    NSLog(@"hackInto");
    return noErr;
}

// 不确定是使用hackIntoAutomatically还是hackInto
// osax放在用户的library目录下hackInto不会触发
void hackIntoHere()
{
    NSLog(@"hackIntoHere");
    [HotKeyManager engineHotKeyListen];
    
    NSMenu* menu = [NSApp windowsMenu];
    if (!menu)
    {
        NSLog(@"found no Window menu in NSApp");
    }
    
    NSLog(@"menu item: %ld", (long)[menu numberOfItems]);
    
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
    
    NSLog(@"i:%lu", (unsigned long)i);
    
    NSMenuItem *addItem = [[NSMenuItem alloc] initWithTitle:@"123" action:NULL keyEquivalent:@""];
    [menu insertItem:addItem atIndex:i];
}