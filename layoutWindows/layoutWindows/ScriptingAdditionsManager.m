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
#import "OSAXInstallManager.h"

static NSString * const runningApplicationsPropertyOfNSWorkspace = @"runningApplications";
static NSString * const isFinishedLaunchingPropertyOfNSRunningApplication = @"isFinishedLaunching";
static NSMutableSet *didInjectApps = nil;

@implementation ScriptingAdditionsManager

- (void)engineScriptingAdditions
{
    [[NSWorkspace sharedWorkspace] addObserver:self forKeyPath:runningApplicationsPropertyOfNSWorkspace options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)offScriptingAdditions
{
    [[NSWorkspace sharedWorkspace] removeObserver:self forKeyPath:runningApplicationsPropertyOfNSWorkspace];
    [self stopInjection];
    [OSAXInstallManager unInstallOSAX];
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
    if (didInjectApps == nil)
    {
        didInjectApps = [NSMutableSet setWithCapacity:0];
    }
    
    if ([didInjectApps containsObject:runningApp.bundleIdentifier] == NO)
    {
        NSLog(@"inject %@", runningApp.localizedName);
        [didInjectApps addObject:runningApp.bundleIdentifier];
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
}

- (void)stopInjection
{
    for (NSString *runningAppBundleIdentifier in didInjectApps)
    {
        SBApplication *app = [SBApplication applicationWithBundleIdentifier:runningAppBundleIdentifier];
        if (!app)
        {
            NSLog(@"Can't generate sbapp with app %@", runningAppBundleIdentifier);
            return;
        }
        
        [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
        [app sendEvent:kASAppleScriptSuite id:kGetAEUT parameters:0];
        
        [app setSendMode:kAENoReply | kAENeverInteract | kAEDontRecord];
        [app sendEvent:'lawd' id:'unlo' parameters:0];
    }
    
    [didInjectApps removeAllObjects];
    didInjectApps = nil;
}

@end
