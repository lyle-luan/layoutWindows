//
//  WindowsManager.h
//  layoutWindows
//
//  Created by APP on 14/11/6.
//  Copyright (c) 2014年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindowsManager : NSObject

+ (WindowsManager *)getInstance;

- (void)dontBotherMeWindow;
- (void)comeBackWindow;
- (void)needAlltimeWindow;

@end
