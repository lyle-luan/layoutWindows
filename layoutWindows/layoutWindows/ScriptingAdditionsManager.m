//
//  ScriptingAdditionsManager.m
//  layoutWindows
//
//  Created by APP on 14/11/12.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "ScriptingAdditionsManager.h"
#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import <Carbon/Carbon.h>

@implementation ScriptingAdditionsManager

- (void)engineScriptingAdditions
{
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(someAppDidEngine:) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
}

- (void) someAppDidEngine:(NSNotification*)notification
{
    NSDictionary* appInfo = [notification userInfo];
    
    pid_t pid = [[appInfo objectForKey:@"NSApplicationProcessIdentifier"] intValue];
    SBApplication *app = [SBApplication applicationWithProcessIdentifier:pid];
    if (!app)
    {
        NSLog(@"Can't find app with pid %d", pid);
        return;
    }
    
    [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
    [app sendEvent:kASAppleScriptSuite id:kGetAEUT parameters:0];
    
    [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
    [app sendEvent:'lawd' id:'load' parameters:0];
}

@end
