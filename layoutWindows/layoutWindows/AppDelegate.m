//
//  AppDelegate.m
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "AppDelegate.h"
#import "OSAXInstallManager.h"
#import "ScriptingAdditionsManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) ScriptingAdditionsManager *scriptingAdditionsManager;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [OSAXInstallManager installOSAX];
    _scriptingAdditionsManager = [[ScriptingAdditionsManager alloc] init];
    [_scriptingAdditionsManager engineScriptingAdditions];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [_scriptingAdditionsManager offScriptingAdditions];
}

@end
