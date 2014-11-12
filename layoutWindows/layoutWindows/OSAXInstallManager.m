//
//  OSAXInstallManager.m
//  layoutWindows
//
//  Created by APP on 14/11/12.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import "OSAXInstallManager.h"

@implementation OSAXInstallManager

+ (BOOL)installOSAX
{
    static NSString * const scriptingAdditions  = @"ScriptingAdditions";
    static NSString * const osaxFileName        = @"layoutWindowsOSAX.osax";
    
    NSError *error = nil;
    BOOL isDirectory = NO;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    
    NSString *userLibraryPath = searchPaths.firstObject;
    
    NSString *scriptingAdditionsPath = [userLibraryPath stringByAppendingPathComponent:scriptingAdditions];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:scriptingAdditionsPath isDirectory:&isDirectory] == YES)
    {
        if (isDirectory == NO)
        {
            return NO;
        }
    }
    else
    {
        if (NO == [fileManager createDirectoryAtPath:scriptingAdditionsPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            return NO;
        }
    }
    
    NSString *osaxPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:osaxFileName];
    
    NSString *osaxLinkedPath = [scriptingAdditionsPath stringByAppendingPathComponent:osaxFileName];
    
    if (NO == [fileManager fileExistsAtPath:osaxPath isDirectory:&isDirectory] && isDirectory)
    {
        return NO;
    }
    else
    {
        [fileManager removeItemAtPath:osaxLinkedPath error:nil];
        
        id fileSystemOfLinkedOSAX = [[fileManager attributesOfItemAtPath:scriptingAdditionsPath error:&error] objectForKey:NSFileSystemNumber];
        if (error)
        {
            return NO;
        }
        id fileSystemOfOSAX = [[fileManager attributesOfItemAtPath:osaxPath error:&error] objectForKey:NSFileSystemNumber];
        if (error)
        {
            return NO;
        }
        
        if ([fileSystemOfLinkedOSAX isEqual:fileSystemOfOSAX])
        {
            if (NO == [fileManager linkItemAtPath:osaxPath toPath:osaxLinkedPath error:&error])
            {
                return NO;
            }
        }
        else
        {
            if ( NO == [fileManager copyItemAtPath:osaxPath toPath:osaxLinkedPath error:&error])
            {
                return NO;
            }
        }
        return YES;
    }
}

@end
