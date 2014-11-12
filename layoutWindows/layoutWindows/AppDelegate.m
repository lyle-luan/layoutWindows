//
//  AppDelegate.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "AppDelegate.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import <Carbon/Carbon.h>

#import "HotKeyManager.h"
#import "OSAXInstallManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [OSAXInstallManager installOSAX];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(someAppDidEngine:) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    
//    [HotKeyManager engineHotKeyListen];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
}

- (void) someAppDidEngine:(NSNotification*)notification
{
    NSDictionary* appInfo = [notification userInfo];
    NSString* appName = [appInfo objectForKey:@"NSApplicationName"];
    NSLog(@"appName: %@", appName);
    
    pid_t pid = [[appInfo objectForKey:@"NSApplicationProcessIdentifier"] intValue];
    SBApplication *app = [SBApplication applicationWithProcessIdentifier:pid];
    app.delegate = self;
    if (!app)
    {
        NSLog(@"Can't find app with pid %d", pid);
        return;
    }
    
    [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
    // SBApplication的父类SBObject的方法sendEvent。
    [app sendEvent:kASAppleScriptSuite id:kGetAEUT parameters:0];
    
    [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
    id injectReply = [app sendEvent:'lawd' id:'load' parameters:0];
    if (injectReply != nil)
    {
        NSLog(@"cnwd unexpected injectReply: %@", injectReply);
    }
}

@end
