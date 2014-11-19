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

static NSString * const runningApplicationsPropertyOfNSWorkspace = @"runningApplications";
static NSString * const isFinishedLaunchingPropertyOfNSRunningApplication = @"isFinishedLaunching";

@implementation ScriptingAdditionsManager

- (void)engineScriptingAdditions
{
    [[NSWorkspace sharedWorkspace] addObserver:self forKeyPath:runningApplicationsPropertyOfNSWorkspace options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)offScriptingAdditions
{
    [[NSWorkspace sharedWorkspace] removeObserver:self forKeyPath:runningApplicationsPropertyOfNSWorkspace];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:runningApplicationsPropertyOfNSWorkspace] == YES)
    {
        NSArray *newRunningApps = [change objectForKey:NSKeyValueChangeNewKey];
        for (NSRunningApplication *runningApp in newRunningApps)
        {
            if (runningApp.isFinishedLaunching == YES)
            {
                [self injectApp:runningApp];
            }
            else
            {
                [runningApp addObserver:self forKeyPath:isFinishedLaunchingPropertyOfNSRunningApplication options:NSKeyValueObservingOptionNew context:nil];
            }
        }
        
        NSArray *oldRunningApps = [change objectForKey:NSKeyValueChangeOldKey];
        for (NSRunningApplication *runningApp in oldRunningApps)
        {
            if (runningApp.isFinishedLaunching == YES)
            {
                [self injectApp:runningApp];
            }
        }
    }
    else if([keyPath isEqualToString:isFinishedLaunchingPropertyOfNSRunningApplication] == YES)
    {
        NSRunningApplication *runningApp = (NSRunningApplication *)object;
        [runningApp removeObserver:self forKeyPath:isFinishedLaunchingPropertyOfNSRunningApplication];
        [self injectApp:runningApp];
    }
}

- (void)injectApp: (NSRunningApplication *)runningApp
{
    //TODO:暂存已经注入的app id，避免重复注入
    SBApplication *app = [SBApplication applicationWithBundleIdentifier:runningApp.bundleIdentifier];
    if (!app)
    {
        NSLog(@"Can't generate sbapp with app %@", runningApp.localizedName);
        return;
    }
    
    [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
    [app sendEvent:kASAppleScriptSuite id:kGetAEUT parameters:0];
    
    [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
    [app sendEvent:'lawd' id:'load' parameters:0];
}

@end
