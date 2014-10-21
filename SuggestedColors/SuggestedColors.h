//
//  Plugin.h
//  Plugin
//
//  Created by Javi Waitzel on 10/16/14.
//  Copyright (c) 2014 Monsters Inc. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SuggestedColors : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end